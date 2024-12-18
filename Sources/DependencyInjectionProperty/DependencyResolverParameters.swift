import DependencyInjection
import Foundation

/// A factory for creating `DependencyResolver` instances, which are responsible for resolving dependencies.
///
/// The `DependencyResolverFactory` provides methods to build `DependencyResolver` objects, which can be used to manage dependency resolution, optionally with singleton behavior.
extension DependencyResolverFactory {
    public static func build<T: Sendable>(
        key: DependencyKey,
        resolveBlock: @escaping @Sendable (any Dependency, [any Sendable]) throws -> T
    ) -> any DependencyResolver {
        DependencyResolverParameters(
            key: key,
            resolveBlock: resolveBlock
        )
    }

    public static func build<T: Sendable>(
        resolveBlock: @escaping @Sendable (any Dependency, [any Sendable]) throws -> T
    ) -> any DependencyResolver {
        DependencyResolverParameters(
            resolveBlock: resolveBlock
        )
    }
}

/// A struct responsible for resolving dependencies.
private struct DependencyResolverParameters: DependencyResolver {
    /// A typealias representing a closure that resolves a dependency.
    /// - Parameter Dependency: The dependency container.
    /// - Returns: The resolved dependency of type `T`.
    typealias ResolveBlock<T: Sendable> = @Sendable (any Dependency, [any Sendable]) throws -> T

    fileprivate final class Storage: @unchecked Sendable {
        var block: (any Sendable)?

        init(block: (any Sendable)? = nil) {
            self.block = block
        }

        func copy() -> Storage {
            Storage(
                block: block
            )
        }
    }

    private var storage: Storage = .init()

    /// The resolved dependency value.
    private var block: (any Sendable)? {
        get { storage.block }
        set {
            ensureUniqueness()
            storage.block = newValue
        }
    }

    /// The key used to identify the dependency.
    let key: DependencyKey

    /// The closure that resolves the dependency.
    private let resolveBlock: ResolveBlock<any Sendable>

    private var parameters: [any Sendable]

    var isSingleton: Bool = false

    /// Initializes a new `DependencyResolver`.
    ///
    /// - Parameters:
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton. Default is `false`.
    ///   - resolveBlock: The closure that resolves the dependency.
    init<T>(
        parameters: [any Sendable] = [],
        resolveBlock: @escaping ResolveBlock<T>
    ) {
        self.init(
            key: DependencyKey(type: T.self),
            parameters: parameters,
            resolveBlock: resolveBlock
        )
    }

    /// Initializes a new `DependencyResolver` with a specific key.
    ///
    /// - Parameters:
    ///   - key: The key used to identify the dependency.
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton.
    ///   - resolveBlock: The closure that resolves the dependency.
    init<T>(
        key: DependencyKey,
        parameters: [any Sendable] = [],
        resolveBlock: @escaping ResolveBlock<T>
    ) {
        self.key = key
        self.resolveBlock = resolveBlock
        self.parameters = parameters
    }

    mutating func setParameters(contentOf sequences: [any Sendable]) {
        parameters = sequences
    }

    /// Resolves the dependency and assigns it to `value`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Throws: An error if the dependency cannot be resolved.
    mutating func resolve(dependencies: Dependency) throws {
        block = try resolveBlock(dependencies, parameters)
    }

    /// Resolves the dependency and returns the updated `DependencyResolver`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Returns: The updated `DependencyResolver`.
    /// - Throws: An error if the dependency cannot be resolved.
    mutating func resolveDependency(dependencies: Dependency) throws -> DependencyResolver {
        block = try resolveBlock(dependencies, parameters)
        return self
    }

    func value() throws -> (any Sendable) {
        block
    }

    private mutating func ensureUniqueness() {
        guard !isKnownUniquelyReferenced(&storage) else { return }
        storage = storage.copy()
    }
}
