import Foundation

public protocol DependencyParameters {
    /// The environment parameter
    var environment: DependencyEnvironment { get set }
}

public protocol DependencyRegister {
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    mutating func register<T>(_ type: T.Type, completion: @escaping (Dependency, Any...) throws -> T)

    /// Register class conform to protocol ```DependencyServiceType``` and use it with resolve
    /// - Parameter type: The `DependencyServiceType` type of the object you will register
    mutating func register<T>(_ type: T.Type) where T: DependencyServiceType

    /// Register the dependency
    /// - Parameter dependency: The dependency
    mutating func register(_ dependency: DependencyResolver)

    /// Register class for using with resolve
    /// - Parameters:
    ///   - key: The dependency key of the object you will register
    ///   - completion: The completion
    mutating func register<T>(key: DependencyKey, completion: @escaping (Dependency, Any...) throws -> T)
}

public protocol DependencyUnregister {
    /// Unregister class
    /// - Parameter type: The type of the object you will unregister
    /// - Returns: the object removed
    mutating func unregister<T>(_ type: T.Type)
}

public protocol DependencyReslove {
    /// Get a class who was registred or get a singleton
    /// - Parameter type: The type of the object you will reolve
    /// - Parameter arguments: The parameters injected to the resolver
    /// - Returns: The new object
    func resolve<T>(_ type: T.Type, arguments: Any...) throws -> T

    /// Get a class who was registred or get a singleton
    /// - Parameter key: The key of the object you will reolve
    /// - Parameter arguments: The parameters injected to the resolver
    /// - Returns: The new object
    func resolve<T>(key: DependencyKey, arguments: Any...) throws -> T

    /// Get a class who was registred or get a singleton
    /// - Parameter arguments: The parameters injected to the resolver
    /// - Returns: The new object
    func resolve<T>(arguments: Any...) throws -> T
}

public protocol DependencySingleton {
    /// Create a singleton
    /// - Parameter completion: The completion to create a singleton
    mutating func registerSingleton<T>(completion: @escaping (Dependency, Any...) throws -> T) throws


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

public protocol DependencyProvider {
    /// Register provider
    /// - Parameter provider: the provider you will add
    mutating func registerProvider(_ provider: Provider)

    /// Unregister provider
    /// - Parameter provider: the provider you will unregister
    mutating func unregisterProvider(_ provider: Provider)

    // MARK: Startup and Endup provider configuration
    func willBoot() -> Self
    func willShutdown() -> Self
    func didEnterBackground() -> Self
    func didBoot() -> Self
}

public protocol DependencyDescription: CustomStringConvertible {
    /// The number of the dependency
    var dependenciesCount: Int { get }

    /// The number of the provider
    var providersCount: Int { get }
}

/// The dependency protocol
public typealias Dependency = DependencyRegister & DependencyUnregister & DependencyProvider & DependencyDescription & DependencyReslove & DependencySingleton & DependencyParameters
