import Foundation

/// A struct responsible for resolving dependencies.
public final class DependencyResolver: @unchecked Sendable  {
    /// A typealias representing a closure that resolves a dependency.
    /// - Parameter Dependency: The dependency container.
    /// - Returns: The resolved dependency of type `T`.
    public typealias ResolveBlock<T> = (Dependency) throws -> T

    /// The resolved dependency value.
    public private(set) var value: Any!

    /// The key used to identify the dependency.
    let key: DependencyKey

    /// The closure that resolves the dependency.
    private let resolveBlock: ResolveBlock<Any>

    /// A flag indicating whether the dependency is a singleton.
    let isSingleton: Bool

    /// Initializes a new `DependencyResolver`.
    ///
    /// - Parameters:
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton. Default is `false`.
    ///   - resolveBlock: The closure that resolves the dependency.
    public convenience init<T>(
        isSingleton: Bool = false,
        resolveBlock: @escaping ResolveBlock<T>
    ) {
        self.init(key: DependencyKey(type: T.self), isSingleton: isSingleton, resolveBlock: resolveBlock)
    }

    /// Initializes a new `DependencyResolver` with a specific key.
    ///
    /// - Parameters:
    ///   - key: The key used to identify the dependency.
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton.
    ///   - resolveBlock: The closure that resolves the dependency.
    init<T>(
        key: DependencyKey,
        isSingleton: Bool,
        resolveBlock: @escaping ResolveBlock<T>
    ) {
        self.key = key
        self.isSingleton = isSingleton
        self.resolveBlock = resolveBlock
    }

    /// Resolves the dependency and assigns it to `value`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Throws: An error if the dependency cannot be resolved.
    public func resolve(dependencies: Dependency) throws {
        value = try resolveBlock(dependencies)
    }
    
    /// Resolves the dependency and returns the updated `DependencyResolver`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Returns: The updated `DependencyResolver`.
    /// - Throws: An error if the dependency cannot be resolved.
    func resolveDependency(dependencies: Dependency) throws -> DependencyResolver {
        value = try resolveBlock(dependencies)
        return self
    }
}
