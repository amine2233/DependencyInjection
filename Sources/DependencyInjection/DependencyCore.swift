import Foundation

public struct DependencyCore: DependencyType {
    private var dependencies: [String: Any] = [:]

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

    /// Create a new class, this method not register class
    public func create<T>(completion: (DependencyType) -> T) -> T {
        return completion(self)
    }

    /// Create a new class conform to protocol ```DependencyServiceType```, this method not register class
    public func create<T>(_: T.Type) -> T where T: DependencyServiceType {
        return T.makeService(for: self)
    }

    /// Unregister class
    @discardableResult
    public mutating func unregister<T>(_ type: T.Type) -> T? {
        return dependencies.removeValue(forKey: String(describing: type)) as? T
    }

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

    /// Get a class who was registred or get a singleton
    public func resolve<T>(_ type: T.Type) -> T? {
        return dependencies[String(describing: type)] as? T
    }
}
