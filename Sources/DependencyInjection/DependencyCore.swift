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
    private var dependencies: [String: DependencyResolver]

    /// The singletons container
    private var singletons: [DependencyID: Any] = [:]

    /// The providers container
    private var providers: [Provider]

    /// The description of the container
    public var description: String {
        var desc: [String] = []

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
        dependencies: [String: DependencyResolver] = [:],
        providers: [Provider] = []
    ) {
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
        dependencies[String(describing: type)] = DependencyResolver(completion)
    }

    /// Register class conform to protocol ```DependencyServiceType``` and use it with resolve
    /// - Parameter type: The `DependencyServiceType` type of the object you will register
    public mutating func register<T>(_ type: T.Type) where T: DependencyServiceType {
        let completion = { (container: Dependency) in
            T.makeService(for: container)
        }
        dependencies[String(describing: type)] = DependencyResolver(completion)
    }

    /// Register the dependency
    /// - Parameter dependency: The dependency
    public mutating func register(_ dependency: DependencyResolver) {
        dependencies[dependency.name] = dependency
    }
}

// MARK: - Create methods
extension DependencyCore {
    /// Create a unique object, this method not register class
    /// - Parameter completion: the completion to create a new object
    /// - Returns: the new object
    public func create<T>(completion: (Dependency) -> T) -> T {
        return completion(self)
    }

    /// Create a new object conform to protocol ```DependencyServiceType```, this method not register class
    /// - Parameter _: The object you will create
    /// - Returns: The new object
    public func create<T>(_: T.Type) -> T where T: DependencyServiceType {
        return T.makeService(for: self)
    }

    /// Create a new object, this method not register object
    /// - Parameter dependency: The dependency object
    /// - Returns: the new object
    public mutating func create(_ dependency: DependencyResolver) -> Any {
        var dependency = dependency
        dependency.resolve(dependencies: self)
        return dependency.value!
    }
}

// MARK: - Unregister service
extension DependencyCore {
    /// Unregister class
    /// - Parameter type: The type of the object you will unregister
    public mutating func unregister<T>(_ type: T.Type) {
        dependencies.removeValue(forKey: String(describing: type))
    }
}

// MARK: - Resolve methods
extension DependencyCore {
    /// Get a class who was registred or get a singleton
    /// - Parameter type: The type of the object you will reolve
    /// - Returns: The new object
    public func resolve<T>(_ type: T.Type) throws -> T {
        let identifier = String(describing: type)
        guard var dependency = dependencies[identifier] else {
            throw DependencyError.notFound(name: identifier)
        }
        dependency.resolve(dependencies: self)
        guard let object = dependency.value as? T else {
            throw DependencyError.notResolved(name: identifier)
        }
        return object
    }

    /// Get a class who was registred or get a singleton
    /// - Returns: The new object
    public func resolve<T>() throws -> T {
        let identifier = String(describing: T.self)
        guard var dependency = dependencies[identifier] else {
            throw DependencyError.notFound(name: identifier)
        }
        dependency.resolve(dependencies: self)
        guard let object = dependency.value as? T else {
            throw DependencyError.notResolved(name: identifier)
        }
        return object
    }
}

// MARK: - Singleton methods
extension DependencyCore {
    /// Resolve singleton
    /// - Returns: singleton object
    public func singleton<T>() throws -> T {
        let identifier = DependencyID(T.self)
        guard let singleton = singletons[identifier] as? T else {
            throw DependencyError.notFound(name: identifier.description)
        }
        return singleton
    }

    /// Create a singleton
    /// - Parameter completion: The completion to create a singleton
    /// - Returns: The singleton object
    @discardableResult
    public mutating func singleton<T>(completion: (Dependency) -> T) -> T {
        let identifier = DependencyID(T.self)
        if let singleton = singletons[identifier] as? T {
            return singleton
        }
        let object = completion(self)
        singletons[identifier] = object
        return object
    }


    /// Create a singleton with class conform to protocol ```DependencyServiceType```
    /// - Parameter type: The type of the singleton
    /// - Returns: the singleton object
    @discardableResult
    public mutating func singleton<T: DependencyServiceType>(_ type: T.Type) -> T {
        let identifier = DependencyID(T.self)
        if let singleton = singletons[identifier] as? T {
            return singleton
        }
        let object = T.makeService(for: self)
        singletons[identifier] = object
        return object
    }

    /// Unregister singleton
    /// - Parameter type: The type of the object you will unregister
    /// - Returns: the singleton you will remove
    @discardableResult
    public  mutating func unregisterSingleton<T>(_ type: T.Type) throws -> T {
        guard let object = singletons.removeValue(forKey: DependencyID(T.self)) as? T else {
            throw DependencyError.notFound(name: String(describing: type))
        }
        return object
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

extension DependencyCore {
    /// Register a new dependencies
    /// - Parameters:
    ///   - name: The `String` name
    ///   - completion: The completion
    public mutating func register<T>(
        withName name: String,
        completion: @escaping (Dependency) -> T
    ) {
        dependencies[name] = DependencyResolver(completion)
    }

    /// Unregister the dependency
    /// - Parameter name: The name of dependency you will unregister
    public mutating func unregister(withName name: String) {
        dependencies.removeValue(forKey: name)
    }

    /// Resolve the dependency
    /// - Parameter name: The name of the dependency
    /// - Returns: `T` object
    public func resolve<T>(withName name: String) throws -> T {
        guard var dependency = dependencies[name] else {
            throw DependencyError.notFound(name: String(describing: T.self))
        }
        dependency.resolve(dependencies: self)
        guard let object = dependency.value as? T else {
            throw DependencyError.notResolved(name: name)
        }
        return object
    }
}
