import Foundation

/// A thread-safe recorder that captures the directed dependency edges discovered while probing the
/// container, together with the resolution stack used to break cyclic recursion.
///
/// The recorder is shared (by reference) across every ``RecordingDependency`` proxy created during a
/// single ``DependencyCheck/check()`` run. All mutable state is guarded by a lock, which makes the
/// `@unchecked Sendable` conformance sound.
final class DependencyEdgeRecorder: @unchecked Sendable {
    /// A directed edge `from -> to` meaning "the service `from` resolves the service `to`".
    struct Edge: Hashable {
        let from: DependencyKey
        let to: DependencyKey
    }

    private let lock = NSLock()
    private var _edges: Set<Edge> = []
    private var _visiting: [DependencyKey] = []

    /// Records a directed edge from one dependency to another.
    func record(from: DependencyKey, to: DependencyKey) {
        lock.lock()
        defer { lock.unlock() }
        _edges.insert(Edge(from: from, to: to))
    }

    /// Returns `true` when `key` is already on the current resolution stack (i.e. a back-edge).
    func isVisiting(_ key: DependencyKey) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return _visiting.contains(key)
    }

    /// Pushes a key onto the resolution stack.
    func push(_ key: DependencyKey) {
        lock.lock()
        defer { lock.unlock() }
        _visiting.append(key)
    }

    /// Pops the most recently pushed key from the resolution stack.
    func pop() {
        lock.lock()
        defer { lock.unlock() }
        if !_visiting.isEmpty {
            _visiting.removeLast()
        }
    }

    /// Returns an immutable snapshot of every recorded edge.
    func snapshotEdges() -> Set<Edge> {
        lock.lock()
        defer { lock.unlock() }
        return _edges
    }
}

/// A sentinel error used to unwind resolution as soon as a back-edge (cycle) is reached.
///
/// The edge that closes the cycle is recorded *before* this is thrown, so the graph remains complete.
enum CycleProbe: Error {
    case backEdge(DependencyKey)
}

/// A proxy ``Dependency`` used only while probing the container for cyclic dependencies.
///
/// It re-implements resolution itself (rather than delegating to the real container) so that it can
/// intercept *every* nested `resolve(...)` call and maintain a visiting-stack to break cyclic
/// recursion. Resolution runs on copies of the resolvers and a snapshot of the container, so the live
/// container — including its singletons — is never mutated. Every registration / mutation entry point
/// is a no-op during probing.
final class RecordingDependency: Dependency {
    /// The container's resolvers, used as the resolution source during probing.
    let resolvers: [DependencyKey: any DependencyResolver]
    /// The shared edge recorder + visiting-stack for this check run.
    let recorder: DependencyEdgeRecorder
    /// An immutable snapshot of the real container, backing the pure-read conformance requirements.
    let snapshot: DependencyCore
    /// The dependency currently being resolved (the source of any edge recorded from this proxy).
    let current: DependencyKey?

    init(
        resolvers: [DependencyKey: any DependencyResolver],
        recorder: DependencyEdgeRecorder,
        snapshot: DependencyCore,
        current: DependencyKey?
    ) {
        self.resolvers = resolvers
        self.recorder = recorder
        self.snapshot = snapshot
        self.current = current
    }

    /// Resolves `key` while recording the edge `current -> key` and guarding against cycles.
    ///
    /// - Records the edge (when there is a current source) before doing anything else.
    /// - Throws ``CycleProbe`` if `key` is already being resolved (a back-edge), stopping the
    ///   recursion that would otherwise overflow the stack.
    /// - Otherwise runs the resolver's block on a *copy*, passing a child proxy so nested resolves are
    ///   intercepted with `key` as their source.
    func recordingResolve<T>(key: DependencyKey, current: DependencyKey?) throws -> T {
        if let current {
            recorder.record(from: current, to: key)
        }
        if recorder.isVisiting(key) {
            throw CycleProbe.backEdge(key)
        }
        guard var resolver = resolvers[key] else {
            throw DependencyError.notFound(name: key.rawValue)
        }

        recorder.push(key)
        defer { recorder.pop() }

        let child = RecordingDependency(
            resolvers: resolvers,
            recorder: recorder,
            snapshot: snapshot,
            current: key
        )
        try resolver.resolve(dependencies: child)

        guard let value = try resolver.value() as? T else {
            throw DependencyError.notResolved(name: key.rawValue)
        }
        return value
    }

    // MARK: - DependencyResolve (recording)

    func resolve<T>(_ type: T.Type) throws -> T {
        try recordingResolve(key: DependencyKey(type: type), current: current)
    }

    func resolve<T>() throws -> T {
        try recordingResolve(key: DependencyKey(type: T.self), current: current)
    }

    func resolve<T>(key: DependencyKey) throws -> T {
        try recordingResolve(key: key, current: current)
    }

    // MARK: - DependencySubscript (recording getter, no-op setter)

    subscript<T>(_ keyPath: DependencyKey) -> T? {
        get { try? recordingResolve(key: keyPath, current: current) }
        set { /* probing must not mutate the container */ }
    }

    // MARK: - DependencyDescription / DependencyParameters (pure reads via snapshot)

    var environment: DependencyEnvironment {
        get { snapshot.environment }
        set { /* probing must not mutate the container */ }
    }

    var dependenciesCount: Int { snapshot.dependenciesCount }

    var providersCount: Int { snapshot.providersCount }

    var description: String { snapshot.description }

    // MARK: - DependencyProvider (no provider side effects during a check)

    func willBoot() -> Self { self }
    func willShutdown() -> Self { self }
    func didEnterBackground() -> Self { self }
    func didBoot() -> Self { self }

    func registerProvider(_ provider: any Provider) {}
    func unregisterProvider(_ provider: any Provider) {}

    // MARK: - Registration / unregistration (no-ops during probing)

    func register<T>(_ type: T.Type, completion: @escaping @Sendable (any Dependency) throws -> T) {}
    func register<T>(_ type: T.Type) where T: DependencyServiceType {}
    func register(_ dependency: any DependencyResolver) {}
    func register<T>(key: DependencyKey, completion: @escaping @Sendable (any Dependency) throws -> T) {}

    func registerOperation<T>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) throws {}

    func unregister<T>(_ type: T.Type) {}

    func registerSingleton<T>(completion: @escaping @Sendable (any Dependency) throws -> T) throws {}
    func registerSingleton<T>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) throws {}
    func registerSingleton<T>(_ type: T.Type) throws where T: DependencyServiceType {}
    func unregisterSingleton<T>(_ type: T.Type) {}
    func unregisterSingleton(key: DependencyKey) {}

    func registerSingletonOperation<T>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) throws {}

    // MARK: - DependencyCheck (avoid recursive self-check)

    func check() throws {}
}
