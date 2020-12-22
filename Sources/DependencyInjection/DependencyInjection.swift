import Foundation

public struct DependencyInjection: DependencyType {
    private var dependencies: [String: Any]
    private var providers: [DependencyProvider]

    public var dependenciesCount: Int {
        dependencies.count
    }

    public var providersCount: Int {
        providers.count
    }

    public init(dependencies: [String: Any] = [:], providers: [DependencyProvider] = []) {
        self.dependencies = dependencies
        self.providers = providers
    }

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
extension DependencyInjection {
    /// Register class for using with resolve
    public mutating func register<T>(_ type: T.Type, completion: (DependencyType) -> T) -> T {
        let object = completion(self)
        dependencies[String(describing: type)] = object
        return object
    }

    /// Register class conform to protocol ```DependencyServiceType``` and use it with resolve
    @discardableResult
    public mutating func register<T>(_ type: T.Type) -> T where T: DependencyServiceType {
        let object = T.makeService(for: self)
        dependencies[String(describing: type)] = object
        return object
    }

    @discardableResult
    public mutating func register(_ dependency: Dependency) -> Any {
        var dependency = dependency
        dependency.resolve(dependencies: self)
        let object = dependency.value!
        dependencies[dependency.name] = object
        return object
    }
}

// MARK: - Create methods
extension DependencyInjection {
    /// Create a new object, this method not register class
    public func create<T>(completion: (DependencyType) -> T) -> T {
        return completion(self)
    }

    /// Create a new class conform to protocol ```DependencyServiceType```, this method not register class
    public func create<T>(_: T.Type) -> T where T: DependencyServiceType {
        return T.makeService(for: self)
    }

    /// Create a new object, this method not register object
    public mutating func create(_ dependency: Dependency) -> Any {
        var dependency = dependency
        dependency.resolve(dependencies: self)
        return dependency.value!
    }

    /// Unregister class
    @discardableResult
    public mutating func unregister<T>(_ type: T.Type) throws -> T {
        guard let object = dependencies.removeValue(forKey: String(describing: type)) as? T else {
            throw DependencyError.notFound(name: String(describing: type))
        }
        return object
    }
}

// MARK: - Resolve methods
extension DependencyInjection {
    /// Get a class who was registred or get a singleton
    public func resolve<T>(_ type: T.Type) throws -> T {
        guard let object = dependencies[String(describing: type)] as? T else {
            throw DependencyError.notFound(name: String(describing: type))
        }
        return object
    }

    /// Get a class who was registred or get a singleton
    public func resolve<T>() throws -> T {
        guard let object = dependencies[String(describing: T.self)] as? T else {
            throw DependencyError.notFound(name: String(describing: T.self))
        }
        return object
    }
}

// MARK: - Singleton methods
extension DependencyInjection {
    /// Create a singleton
    @discardableResult
    public mutating func singleton<T>(completion: (DependencyType) -> T) -> T {
        if let singleton = dependencies[String(describing: T.self)] as? T {
            return singleton
        }
        return register(T.self, completion: completion)
    }

    /// Create a singleton with class conform to protocol ```DependencyServiceType```,
    @discardableResult
    public mutating func singleton<T: DependencyServiceType>(_ type: T.Type) -> T {
        if let singleton = dependencies[String(describing: type)] as? T {
            return singleton
        }
        return register(type)
    }

    /// Create a singleton with class conform to protocol ```DependencyServiceType```,
    @discardableResult
    public mutating func singleton(_ dependency: Dependency) -> Any {
        if let singleton = dependencies[dependency.name] {
            return singleton
        }
        return register(dependency)
    }
}

extension DependencyInjection {
    public mutating func register(_ provider: Provider) {
        var provider = provider
        provider.resolve(dependencies: self)
        let object = provider.value as! DependencyProvider
        providers.append(object)
    }

    public mutating func unregister<T: DependencyProvider>(_ type: T.Type) {
        providers = providers.filter { $0.description == String(describing: type) }
    }
}
