import Foundation

/// An error type representing issues encountered during dependency resolution.
public enum DependencyResolverError: Error {
    /// Indicates that a dependency could not be resolved.
    case notResolved
}

/// A protocol representing a dependency resolver.
///
/// The `DependencyResolver` protocol is used to define resolvers responsible for resolving dependencies in a system. Conforming types must be `Sendable` to ensure they can be safely used in concurrent environments.
public protocol DependencyResolver: Sendable {
    /// The key used to identify the dependency.
    var typeKey: DependencyTypeKey { get }

    /// A flag indicating whether the dependency is a singleton.
    var isSingleton: Bool { get }

    /// Resolves the dependency and assigns it to `value`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Throws: An error if the dependency cannot be resolved.
    mutating func resolve(dependencies: any Dependency) throws

    /// Get the value inside the
    func value() throws -> (any Sendable)
}

extension DependencyResolver {
    /// Resolves the dependency and returns the updated `DependencyResolver`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Returns: The updated `DependencyResolver`.
    /// - Throws: An error if the dependency cannot be resolved.
    mutating func resolveDependency(dependencies: any Dependency) throws -> any DependencyResolver {
        try resolve(dependencies: dependencies)
        return self
    }
}

/// A factory for creating `DependencyResolver` instances, which are responsible for resolving dependencies.
///
/// The `DependencyResolverFactory` provides methods to build `DependencyResolver` objects, which can be used to manage dependency resolution, optionally with singleton behavior.
public enum DependencyResolverFactory: Sendable {
    /// Creates a `DependencyResolver` with the given key and resolution block.
    ///
    /// - Parameters:
    ///   - key: The `DependencyKey` used to identify the dependency.
    ///   - isSingleton: A Boolean indicating whether the resolver should create a singleton instance. Default is `false`.
    ///   - resolveBlock: A closure that defines how to resolve the dependency.
    /// - Returns: An instance of `DependencyResolver`.
    public static func build<T: Sendable>(
        typeKey: DependencyTypeKey,
        isSingleton: Bool = false,
        resolveBlock: @escaping @Sendable (any Dependency) throws -> T
    ) -> any DependencyResolver {
        DependencyResolverDefault(
            typeKey: typeKey,
            isSingleton: isSingleton,
            resolveBlock: resolveBlock
        )
    }

    /// Creates a `DependencyResolver` without a key, using the provided resolution block.
    ///
    /// - Parameters:
    ///   - isSingleton: A Boolean indicating whether the resolver should create a singleton instance. Default is `false`.
    ///   - resolveBlock: A closure that defines how to resolve the dependency.
    /// - Returns: An instance of `DependencyResolver`.
    public static func build<T: Sendable>(
        isSingleton: Bool = false,
        resolveBlock: @escaping @Sendable (any Dependency) throws -> T
    ) -> any DependencyResolver {
        DependencyResolverDefault(
            isSingleton: isSingleton,
            resolveBlock: resolveBlock
        )
    }
}

/// A struct responsible for resolving dependencies.
private struct DependencyResolverDefault: DependencyResolver {
    /// A typealias representing a closure that resolves a dependency.
    /// - Parameter Dependency: The dependency container.
    /// - Returns: The resolved dependency of type `T`.
    typealias ResolveBlock<T: Sendable> = @Sendable (any Dependency) throws -> T

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
    let typeKey: DependencyTypeKey

    /// The closure that resolves the dependency.
    private let resolveBlock: ResolveBlock<any Sendable>

    /// A flag indicating whether the dependency is a singleton.
    let isSingleton: Bool

    /// Initializes a new `DependencyResolver`.
    ///
    /// - Parameters:
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton. Default is `false`.
    ///   - resolveBlock: The closure that resolves the dependency.
    init<T: Sendable>(
        isSingleton: Bool = false,
        resolveBlock: @escaping ResolveBlock<T>
    ) {
        self.init(
            typeKey: DependencyTypeKey(type: T.self),
            isSingleton: isSingleton,
            resolveBlock: resolveBlock
        )
    }

    /// Initializes a new `DependencyResolver` with a specific key.
    ///
    /// - Parameters:
    ///   - typeKey: The key used to identify the dependency.
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton.
    ///   - resolveBlock: The closure that resolves the dependency.
    init<T: Sendable>(
        typeKey: DependencyTypeKey,
        isSingleton: Bool,
        resolveBlock: @escaping ResolveBlock<T>
    ) {
        self.typeKey = typeKey
        self.isSingleton = isSingleton
        self.resolveBlock = resolveBlock
    }

    mutating func resolve(dependencies: any Dependency) throws {
        block = try resolveBlock(dependencies)
    }

    func value() throws -> (any Sendable) {
        guard let block else {
            throw DependencyResolverError.notResolved
        }
        return block
    }

    private mutating func ensureUniqueness() {
        guard !isKnownUniquelyReferenced(&storage) else { return }
        storage = storage.copy()
    }
}
