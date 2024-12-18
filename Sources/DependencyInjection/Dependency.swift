import Foundation

public protocol DependencyParameters {
    /// The environment parameter
    var environment: DependencyEnvironment { get set }
}

public protocol DependencyRegister: Sendable {
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    mutating func register<T>(_ type: T.Type, completion: @escaping @Sendable (any Dependency) throws -> T)

    /// Register class conform to protocol ```DependencyServiceType``` and use it with resolve
    /// - Parameter type: The `DependencyServiceType` type of the object you will register
    mutating func register<T>(_ type: T.Type) where T: DependencyServiceType

    /// Register the dependency
    /// - Parameter dependency: The dependency
    mutating func register(_ dependency: any DependencyResolver)

    /// Register class for using with resolve
    /// - Parameters:
    ///   - key: The dependency key of the object you will register
    ///   - completion: The completion
    mutating func register<T>(key: DependencyKey, completion: @escaping @Sendable (any Dependency) throws -> T)
}

public protocol DependencyRegisterOperation: Sendable {
    /// Register singleton class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    ///   - operation: The operation after registration
    mutating func registerOperation<T>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) throws
}

public protocol DependencyUnregister: Sendable {
    /// Unregister class
    /// - Parameter type: The type of the object you will unregister
    /// - Returns: the object removed
    mutating func unregister<T>(_ type: T.Type)
}

public protocol DependencyReslove: Sendable {
    /// Get a class who was registred or get a singleton
    /// - Parameter type: The type of the object you will reolve
    /// - Returns: The new object
    func resolve<T>(_ type: T.Type) throws -> T

    /// Get a class who was registred or get a singleton
    /// - Parameter key: The key of the object you will reolve
    /// - Returns: The new object
    func resolve<T>(key: DependencyKey) throws -> T

    /// Get a class who was registred or get a singleton
    /// - Returns: The new object
    func resolve<T>() throws -> T
}

public protocol DependencySingleton: Sendable {
    /// Create a singleton
    /// - Parameter completion: The completion to create a singleton
    mutating func registerSingleton<T>(completion: @escaping @Sendable (any Dependency) throws -> T) throws

    /// Create a singleton
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    mutating func registerSingleton<T>(_ type: T.Type, completion: @escaping @Sendable (any Dependency) throws -> T) throws

    /// Create a singleton with class conform to protocol ```DependencyServiceType```
    /// - Parameter type: The type of the singleton
    mutating func registerSingleton<T: DependencyServiceType>(_ type: T.Type) throws

    /// Unregister singleton
    /// - Parameter type: The type of the object you will unregister
    /// - Returns: the singleton you will remove
    mutating func unregisterSingleton<T>(_ type: T.Type)

    /// Unregister singleton
    /// - Parameter key: The key of the object you will unregister
    /// - Returns: the singleton you will remove
    mutating func unregisterSingleton(key: DependencyKey)
}

public protocol DependencySingletonOperation: Sendable {
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    ///   - operation: The operation after registration
    mutating func registerSingletonOperation<T>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) throws
}

public protocol DependencyProvider: Sendable {
    /// Register provider
    /// - Parameter provider: the provider you will add
    mutating func registerProvider(_ provider: any Provider)

    /// Unregister provider
    /// - Parameter provider: the provider you will unregister
    mutating func unregisterProvider(_ provider: any Provider)

    // MARK: Startup and Endup provider configuration

    func willBoot() -> Self
    func willShutdown() -> Self
    func didEnterBackground() -> Self
    func didBoot() -> Self
}

public protocol DependencyDescription: Sendable, CustomStringConvertible {
    /// The number of the dependency
    var dependenciesCount: Int { get }

    /// The number of the provider
    var providersCount: Int { get }
}

public protocol DependencySubscript: Sendable {
    subscript<T>(_ keyPath: DependencyKey) -> T? { get set }
}

/// The dependency protocol
public typealias Dependency = DependencyDescription & DependencyParameters & DependencyProvider & DependencyRegister & DependencyRegisterOperation & DependencyReslove & DependencySingleton & DependencySingletonOperation & DependencySubscript & DependencyUnregister
