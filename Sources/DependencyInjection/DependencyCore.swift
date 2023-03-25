import Foundation

/// The dependency injection
///
///
/// description:
///     How we use this dependency injection
///
///     struct CoreDependency {
///         static var di: DependencyInjector = DependencyInjector()
///     }
///
///     extension HasDependencies {
///         public var dependencies: Dependency {
///             CoreDependency.di.dependencies
///         }
///     }
///
///
public struct DependencyCore: Dependency {

    /// The environment parameter
    public var environment: DependencyEnvironment

    /// The number of the dependency
    public var dependenciesCount: Int {
        dependencies.count
    }

    /// The number of the provider
    public var providersCount: Int {
        providers.count
    }

    /// The dependencies container
    private var dependencies: [DependencyKey: DependencyResolver]

    /// The providers container
    private var providers: [Provider]

    /// The description of the container
    public var description: String {
        var desc: [String] = []

        desc.append("Environment:")
        desc.append(environment.description)

        desc.append("Dependencies:")
        if dependencies.isEmpty {
            desc.append("<none>")
        } else {
            for (id, _) in dependencies {
                desc.append("- \(id)")
            }
        }

        desc.append("Providers:")
        if providers.isEmpty {
            desc.append("<none>")
        } else {
            for provider in providers {
                desc.append("- \(provider.description)")
            }
        }

        return desc.joined(separator: "\n")
    }

    /// The dependency initializer
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - singletons: The singletons
    ///   - providers: The providers
    public init(
        environment: DependencyEnvironment = .production,
        dependencies: [DependencyKey: DependencyResolver] = [:],
        providers: [Provider] = []
    ) {
        self.environment = environment
        self.dependencies = dependencies
        self.providers = providers
    }

    /// Provider will boot
    public func willBoot() -> Self {
        _ = self.providers.map { $0.willBoot(self) }
        return self
    }

    /// Provider did boot
    public func didBoot() -> Self  {
        _ = self.providers.map { $0.didBoot(self) }
        return self
    }

    /// Provider will shutdown
    public func willShutdown() -> Self  {
        _ = self.providers.map { $0.willShutdown(self) }
        return self
    }

    /// Provider did enter on background
    public func didEnterBackground() -> Self  {
        _ = self.providers.map { $0.didEnterBackground(self) }
        return self
    }
}

// MARK: - Register methods

extension DependencyCore {
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    public mutating func register<T>(_ type: T.Type, completion: @escaping (Dependency) throws -> T) {
        register(key: DependencyKey(type: type), completion: completion)
    }

    /// Register class conform to protocol ```DependencyServiceType``` and use it with resolve
    /// - Parameter type: The `DependencyServiceType` type of the object you will register
    public mutating func register<T>(_ type: T.Type) where T: DependencyServiceType {
        let completion = { (container: Dependency) in
            try T.makeService(for: container)
        }
        let identifier = DependencyKey(type: type)
        dependencies[identifier] = DependencyResolver(key: identifier, isSingleton: false, resolveBlock: completion)
    }

    /// Register the dependency
    /// - Parameter dependency: The dependency
    public mutating func register(_ dependency: DependencyResolver) {
        dependencies[dependency.key] = dependency
    }

    public mutating func register<T>(key: DependencyKey, completion: @escaping (Dependency) throws -> T) {
        dependencies[key] = DependencyResolver(key: key, isSingleton: false, resolveBlock: completion)
    }
}

// MARK: - Factory methods

extension DependencyCore {
    /// Create a unique object, this method not register class
    /// - Parameter completion: the completion to create a new object
    /// - Returns: the new object
    public func factory<T>(completion: (Dependency) throws -> T) throws -> T {
        try completion(self)
    }

    /// Create a new object conform to protocol ```DependencyServiceType```, this method not register class
    /// - Parameter _: The object you will create
    /// - Returns: The new object
    public func factory<T>(_ type: T.Type) throws -> T where T: DependencyServiceType {
        try type.makeService(for: self)
    }

    /// Create a new object, this method not register object
    /// - Parameter dependency: The dependency object
    /// - Returns: the new object
    public mutating func factory(_ dependency: DependencyResolver) throws -> Any {
        var dependency = dependency
        try dependency.resolve(dependencies: self)

        guard let value = dependency.value else {
            throw DependencyError.notResolved(name: dependency.key.rawValue)
        }
        return value
    }
}

// MARK: - Unregister service

extension DependencyCore {
    /// Unregister class
    /// - Parameter type: The type of the object you will unregister
    public mutating func unregister<T>(_ type: T.Type) {
        dependencies.removeValue(forKey: DependencyKey(type: type))
    }
}

// MARK: - Resolve methods

extension DependencyCore {
    /// Get a class who was registred or get a singleton
    /// - Parameter type: The type of the object you will reolve
    /// - Returns: The new object
    public func resolve<T>(_ type: T.Type) throws -> T {
        let identifier = DependencyKey(type: type)
        return try resolve(key: identifier)
    }

    /// Get a class who was registred or get a singleton
    /// - Returns: The new object
    public func resolve<T>() throws -> T {
        let identifier = DependencyKey(type: T.self)
        return try resolve(key: identifier)
    }

    public func resolve<T>(key: DependencyKey) throws -> T {
        guard var dependency = dependencies[key] else {
            throw DependencyError.notFound(name: key.rawValue)
        }

        if !dependency.isSingleton {
            try dependency.resolve(dependencies: self)
        }

        guard let object = dependency.value as? T else {
            throw DependencyError.notResolved(name: key.rawValue)
        }

        return object
    }
}

// MARK: - Singleton methods

extension DependencyCore {
    /// Resolve singleton
    /// - Returns: singleton object
    public func singleton<T>() throws -> T {
        let identifier = DependencyKey(type: T.self)
        return try singleton(key: identifier)
    }

    public func singleton<T>(key: DependencyKey) throws -> T {
        try resolve(key: key)
    }

    /// Create a singleton
    /// - Parameter completion: The completion to create a singleton
    /// - Returns: The singleton object
    public mutating func registerSingleton<T>(completion: @escaping (Dependency) throws -> T) throws {
        let identifier = DependencyKey(type: T.self)
        var dependency = DependencyResolver(key: identifier, isSingleton: true, resolveBlock: completion)

        try dependency.resolve(dependencies: self)

        dependencies[identifier] = dependency
    }

    /// Create a singleton with class conform to protocol ```DependencyServiceType```
    /// - Parameter type: The type of the singleton
    /// - Returns: the singleton object
    public mutating func registerSingleton<T: DependencyServiceType>(_ type: T.Type) throws {
        let completion: (Dependency) throws -> T = { dependency in
            try T.makeService(for: dependency)
        }
        let identifier = DependencyKey(type: T.self)
        var dependency = DependencyResolver(key: identifier, isSingleton: true, resolveBlock: completion)

        try dependency.resolve(dependencies: self)

        dependencies[identifier] = dependency
    }

    /// Unregister singleton
    /// - Parameter type: The type of the object you will unregister
    public mutating func unregisterSingleton<T>(_ type: T.Type) {
        unregisterSingleton(key: DependencyKey(type: T.self))
    }

    public mutating func unregisterSingleton(key: DependencyKey) {
        dependencies.removeValue(forKey: key)
    }
}

// MARK: - Register & Unregister Provider

extension DependencyCore {
    /// Register provider
    /// - Parameter provider: the provider you will add
    public mutating func registerProvider(_ provider: Provider) {
        providers.append(provider)
    }

    /// Unregister provider
    /// - Parameter provider: the provider you will unregister
    public mutating func unregisterProvider(_ provider: Provider) {
        providers = providers.filter { $0.description != provider.description }
    }
}
