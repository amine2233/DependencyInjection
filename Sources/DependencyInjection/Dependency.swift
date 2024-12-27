import Foundation

public protocol DependencyParameters: Sendable {
    /// The environment parameter
    var environment: DependencyEnvironment { get set }
}

public protocol DependencyRegister: Sendable {
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    mutating func register<T: Sendable>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T
    )
    
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - key The dependency key
    ///   - completion: The completion
    mutating func register<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey?,
        completion: @escaping @Sendable (any Dependency) throws -> T
    )

    /// Register class conform to protocol ```DependencyServiceType``` and use it with resolve
    /// - Parameter type: The `DependencyServiceType` type of the object you will register
    mutating func register<T: Sendable>(
        _ type: T.Type
    ) where T: DependencyServiceType
    
    /// Register class conform to protocol ```DependencyServiceType``` and use it with resolve
    /// - Parameters:
    ///     - type: The `DependencyServiceType` type of the object you will register
    ///     - key: DependencyKey?,
    mutating func register<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey?
    ) where T: DependencyServiceType

    /// Register the dependency
    /// - Parameter dependency: The dependency
    mutating func register(_ dependency: any DependencyResolver)
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
    
    /// Register singleton class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - key: The dependency key.
    ///   - completion: The completion
    ///   - operation: The operation after registration
    mutating func registerOperation<T>(
        _ type: T.Type,
        key: DependencyKey,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) throws
}

public protocol DependencyUnregister: Sendable {
    /// Unregister class
    /// - Parameter type: The type of the object you will unregister
    /// - Returns: the object removed
    mutating func unregister<T>(_ type: T.Type)

    /// Unregister class
    /// - Parameters:
    ///   - type: The type of the object you will unregister
    ///   - key: The dependency key.
    /// - Returns: the object removed
    mutating func unregister<T>(
        _ type: T.Type,
        key: DependencyKey
    )
}

public protocol DependencyResolve: Sendable {
    /// Get a class who was registred or get a singleton
    /// - Parameter type: The type of the object you will reolve
    /// - Returns: The new object
    func resolve<T: Sendable>(_ type: T.Type) throws -> T
    
    /// Get a class who was registred or get a singleton
    /// - Parameters:
    ///    - type: The type of the object you will resolve
    ///    - key: The dependency key.
    /// - Returns: The new object
    func resolve<T: Sendable>(_ type: T.Type, key: DependencyKey) throws -> T

    /// Get a class who was registred or get a singleton
    /// - Returns: The new object
    func resolve<T: Sendable>() throws -> T
}

public protocol DependencySingleton: Sendable {
    /// Create a singleton
    /// - Parameter completion: The completion to create a singleton
    mutating func registerSingleton<T: Sendable>(
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) throws

    /// Create a singleton
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    mutating func registerSingleton<T: Sendable>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) throws
    
    /// Create a singleton
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - key: The dependency key.
    ///   - completion: The completion
    mutating func registerSingleton<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey,
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) throws

    /// Create a singleton with class conform to protocol ```DependencyServiceType```
    /// - Parameter type: The type of the singleton
    mutating func registerSingleton<T: DependencyServiceType & Sendable>(
        _ type: T.Type
    ) throws
    
    /// Create a singleton with class conform to protocol ```DependencyServiceType```
    /// - Parameters:
    ///    - type: The type of the singleton
    ///    - key: The dependency key.
    mutating func registerSingleton<T: DependencyServiceType & Sendable>(
        _ type: T.Type,
        key: DependencyKey
    ) throws

    /// Unregister singleton
    /// - Parameter type: The type of the object you will unregister
    /// - Returns: the singleton you will remove
    mutating func unregisterSingleton<T: Sendable>(
        _ type: T.Type
    )
    
    /// Unregister singleton
    /// - Parameter type: The type of the object you will unregister
    /// - Returns: the singleton you will remove
    mutating func unregisterSingleton<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey
    )
    
    /// Unregister singleton
    /// - Parameter typeKey: The type of the object you will unregister
    /// - Returns: the singleton you will remove
    mutating func unregisterSingleton(
        typeKey: DependencyTypeKey
    )
}

public protocol DependencySingletonOperation: Sendable {
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    ///   - operation: The operation after registration
    mutating func registerSingletonOperation<T: Sendable>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) throws
    
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - key: The dependency key
    ///   - completion: The completion
    ///   - operation: The operation after registration
    mutating func registerSingletonOperation<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey,
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
    subscript<T>(_ keyPath: DependencyTypeKey) -> T? { get set }
}

/// The dependency protocol
public protocol Dependency:
    DependencyDescription,
    DependencyParameters,
    DependencyProvider,
    DependencyRegister,
    DependencyRegisterOperation,
    DependencyResolve,
    DependencySingleton,
    DependencySingletonOperation,
    DependencySubscript,
    DependencyUnregister
{}
