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
    public var environment: DependencyEnvironement

    /// The number of the dependency
    public var dependenciesCount: Int {
        dependencies.count
    }

    /// The number of the provider
    public var providersCount: Int {
        providers.count
    }

    /// The number of the singleton
    public var singletonCount: Int {
        singletons.count
    }

    /// The dependencise container
    private var dependencies: [DependencyKey: DependencyResolver]

    /// The singletons container
    private var singletons: [DependencyKey: DependencySingletonResolver] = [:]

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

        desc.append("Singletons:")
        if singletons.isEmpty {
            desc.append("<none>")
        } else {
            for (id, _) in singletons {
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
        environment: DependencyEnvironement = .production,
        dependencies: [DependencyKey: DependencyResolver] = [:],
        providers: [Provider] = []
    ) {
        self.environment = environment
        self.dependencies = dependencies
        self.providers = providers
    }

    public func willBoot() -> Self {
        _ = self.providers.map { $0.willBoot(self) }
        return self
    }

    public func didBoot() -> Self  {
        _ = self.providers.map { $0.didBoot(self) }
        return self
    }

    public func willShutdown() -> Self  {
        _ = self.providers.map { $0.willShutdown(self) }
        return self
    }

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
    public mutating func register<T>(_ type: T.Type, completion: @escaping (Dependency) -> T) {
        register(DependencyKey(type: type), completion: completion)
    }

    /// Register class conform to protocol ```DependencyServiceType``` and use it with resolve
    /// - Parameter type: The `DependencyServiceType` type of the object you will register
    public mutating func register<T>(_ type: T.Type) where T: DependencyServiceType {
        let completion = { (container: Dependency) in
            try T.makeService(for: container)
        }
        let identifier = DependencyKey(type: type)
        dependencies[identifier] = DependencyResolver(key: identifier, resolveBlock: completion)
    }

    /// Register the dependency
    /// - Parameter dependency: The dependency
    public mutating func register(_ dependency: DependencyResolver) {
        dependencies[dependency.key] = dependency
    }

    public mutating func register<T>(_ key: DependencyKey, completion: @escaping (Dependency) -> T) {
        dependencies[key] = DependencyResolver(key: key, resolveBlock: completion)
    }
}

// MARK: - Create methods
extension DependencyCore {
    /// Create a unique object, this method not register class
    /// - Parameter completion: the completion to create a new object
    /// - Returns: the new object
    public func create<T>(completion: (Dependency) throws -> T) throws -> T {
        try completion(self)
    }

    /// Create a new object conform to protocol ```DependencyServiceType```, this method not register class
    /// - Parameter _: The object you will create
    /// - Returns: The new object
    public func create<T>(_ type: T.Type) throws -> T where T: DependencyServiceType {
        try type.makeService(for: self)
    }

    /// Create a new object, this method not register object
    /// - Parameter dependency: The dependency object
    /// - Returns: the new object
    public mutating func create(_ dependency: DependencyResolver) throws -> Any {
        var dependency = dependency
        try dependency.resolve(dependencies: self)
        return dependency.value!
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
        return try resolve(identifier)
    }

    /// Get a class who was registred or get a singleton
    /// - Returns: The new object
    public func resolve<T>() throws -> T {
        let identifier = DependencyKey(type: T.self)
        return try resolve(identifier)
    }

    public func resolve<T>(_ key: DependencyKey) throws -> T {
        guard var dependency = dependencies[key] else {
            throw DependencyError.notFound(name: key.rawValue)
        }
        try dependency.resolve(dependencies: self)
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
    public mutating func singleton<T>() throws -> T {
        let identifier = DependencyKey(type: T.self)
        return try singleton(identifier)
    }

    public mutating func singleton<T>(_ key: DependencyKey) throws -> T {
        guard var singleton = singletons[key] else {
            throw DependencyError.notFoundSingleton(name: key.rawValue)
        }

        try singleton.resolve(dependencies: self)

        guard let value = singleton.value as? T else {
            throw DependencyError.notResolved(name: key.rawValue)
        }
        return value
    }

    /// Create a singleton
    /// - Parameter completion: The completion to create a singleton
    /// - Returns: The singleton object
    public mutating func registerSingleton<T>(completion: @escaping (Dependency) throws -> T) {
        let identifier = DependencyKey(type: T.self)
        singletons[identifier] = DependencySingletonResolver(key: identifier, resolveBlock: completion)
    }

    /// Create a singleton with class conform to protocol ```DependencyServiceType```
    /// - Parameter type: The type of the singleton
    /// - Returns: the singleton object
    public mutating func registerSingleton<T: DependencyServiceType>(_ type: T.Type) {
        let completion: (Dependency) throws -> T = { dependency in
            try T.makeService(for: dependency)
        }
        let identifier = DependencyKey(type: T.self)
        singletons[identifier] = DependencySingletonResolver(key: identifier, resolveBlock: completion)
    }

    /// Unregister singleton
    /// - Parameter type: The type of the object you will unregister
    public mutating func unregisterSingleton<T>(_ type: T.Type) {
        unregisterSingleton(DependencyKey(type: T.self))
    }

    public mutating func unregisterSingleton(_ key: DependencyKey) {
        singletons.removeValue(forKey: key)
    }
}

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
