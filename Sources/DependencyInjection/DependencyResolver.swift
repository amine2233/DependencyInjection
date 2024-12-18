import Foundation

public enum DependencyResolverError: Error {
    case notResolved
}

/// A struct responsible for resolving dependencies.
public final class DependencyResolver: Sendable {
    /// A typealias representing a closure that resolves a dependency.
    /// - Parameter Dependency: The dependency container.
    /// - Returns: The resolved dependency of type `T`.
    public typealias ResolveBlock<T: Sendable> = @Sendable (any Dependency) throws -> T
    
    private final class Storage: @unchecked Sendable {
        var block: (any Sendable)??
        
        init(block: (any Sendable)? = nil) {
            self.block = block
        }
    }
    
    private let storage: Storage = Storage()
    
    /// The resolved dependency value.
    private var block: (any Sendable)? {
        get { storage.block }
        set { storage.block = newValue }
    }

    /// The key used to identify the dependency.
    let key: DependencyKey

    /// The closure that resolves the dependency.
    private let resolveBlock: ResolveBlock<(any Sendable)>

    /// A flag indicating whether the dependency is a singleton.
    let isSingleton: Bool

    /// Initializes a new `DependencyResolver`.
    ///
    /// - Parameters:
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton. Default is `false`.
    ///   - resolveBlock: The closure that resolves the dependency.
    public convenience init<T: Sendable>(
        isSingleton: Bool = false,
        resolveBlock: @escaping @Sendable ResolveBlock<T>
    ) {
        self.init(key: DependencyKey(type: T.self), isSingleton: isSingleton, resolveBlock: resolveBlock)
    }

    /// Initializes a new `DependencyResolver` with a specific key.
    ///
    /// - Parameters:
    ///   - key: The key used to identify the dependency.
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton.
    ///   - resolveBlock: The closure that resolves the dependency.
    init<T: Sendable>(
        key: DependencyKey,
        isSingleton: Bool,
        resolveBlock: @escaping @Sendable ResolveBlock<T>
    ) {
        self.key = key
        self.isSingleton = isSingleton
        self.resolveBlock = resolveBlock
    }

    /// Resolves the dependency and assigns it to `value`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Throws: An error if the dependency cannot be resolved.
    public func resolve(dependencies: any Dependency) throws {
        block = try resolveBlock(dependencies)
    }

    /// Resolves the dependency and returns the updated `DependencyResolver`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Returns: The updated `DependencyResolver`.
    /// - Throws: An error if the dependency cannot be resolved.
    func resolveDependency(dependencies: any Dependency) throws -> DependencyResolver {
        block = try resolveBlock(dependencies)
        return self
    }
    
    public func value() throws -> (any Sendable) {
        guard let block else {
            throw DependencyResolverError.notResolved
        }
        return block
    }
}

@available(*, unavailable)
extension DependencyResolver: Sendable { }

