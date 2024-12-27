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
struct DependencyCore: Dependency {
    static let shared: DependencyCore = .init()

    /// The environment parameter
    var environment: DependencyEnvironment

    /// The number of the dependency
    var dependenciesCount: Int {
        dependencies.count
    }

    /// The number of the provider
    var providersCount: Int {
        providers.count
    }

    /// The dependencies container
    var dependencies: [DependencyTypeKey: any DependencyResolver]

    /// The providers container
    private var providers: [any Provider]

    /// The description of the container
    var description: String {
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
    init(
        environment: DependencyEnvironment = .production,
        dependencies: [DependencyTypeKey: any DependencyResolver] = [:],
        providers: [any Provider] = []
    ) {
        self.environment = environment
        self.dependencies = dependencies
        self.providers = providers
    }

    /// Provider will boot
    func willBoot() -> Self {
        _ = providers.map { $0.willBoot(self) }
        return self
    }

    /// Provider did boot
    func didBoot() -> Self {
        _ = providers.map { $0.didBoot(self) }
        return self
    }

    /// Provider will shutdown
    func willShutdown() -> Self {
        _ = providers.map { $0.willShutdown(self) }
        return self
    }

    /// Provider did enter on background
    func didEnterBackground() -> Self {
        _ = providers.map { $0.didEnterBackground(self) }
        return self
    }
}

// MARK: - Register methods

extension DependencyCore {
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    mutating func register<T: Sendable>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) {
        let typeKey = DependencyTypeKey(type: type)
        return register(typeKey: typeKey, completion: completion)
    }

    /// Register class conform to protocol ```DependencyServiceType``` and use it with resolve
    /// - Parameter type: The `DependencyServiceType` type of the object you will register
    mutating func register<T: Sendable>(_ type: T.Type) where T: DependencyServiceType {
        let completion = { @Sendable (container: any Dependency) in
            try T.makeService(for: container)
        }
        let typeKey = DependencyTypeKey(type: type)
        return register(typeKey: typeKey, completion: completion)
    }

    /// Register the dependency
    /// - Parameter dependency: The dependency
    mutating func register(_ dependency: any DependencyResolver) {
        dependencies[dependency.typeKey] = dependency
    }

    mutating func register<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey?,
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) {
        let typeKey = DependencyTypeKey(type: type, key: key)
        return register(typeKey: typeKey, completion: completion)
    }

    mutating func register<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey?
    ) where T: DependencyServiceType {
        let completion = { @Sendable (container: any Dependency) in
            try T.makeService(for: container)
        }
        let typeKey = DependencyTypeKey(type: type, key: key)
        return register(typeKey: typeKey, completion: completion)
    }

    mutating func register<T: Sendable>(
        typeKey: DependencyTypeKey,
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) {
        dependencies[typeKey] = DependencyResolverFactory.build(
            typeKey: typeKey,
            isSingleton: false,
            resolveBlock: completion
        )
    }
}

// MARK: - Register methods with operation

extension DependencyCore {
    /// Register class for using with resolve
    /// - Parameters:
    ///   - type: The type of the object you will register
    ///   - completion: The completion
    ///   - operation: The operation after registration
    mutating func registerOperation<T: Sendable>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) {
        register(type) { dependencies in
            let result = try completion(dependencies)
            return try operation(result, dependencies)
        }
    }

    mutating func registerOperation<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) throws {
        register(type, key: key) { dependencies in
            let result = try completion(dependencies)
            return try operation(result, dependencies)
        }
    }
}

// MARK: - Unregister service

extension DependencyCore {
    mutating func unregister<T: Sendable>(_ type: T.Type) {
        let typeKey = DependencyTypeKey(type: type)
        dependencies.removeValue(forKey: typeKey)
    }

    mutating func unregister<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey
    ) {
        let typeKey = DependencyTypeKey(type: type, key: key)
        dependencies.removeValue(forKey: typeKey)
    }
}

// MARK: - DependencyResolve

extension DependencyCore {
    func resolve<T: Sendable>(_ type: T.Type) throws -> T {
        let typeKey = DependencyTypeKey(type: type)
        return try resolve(typeKey: typeKey)
    }

    func resolve<T: Sendable>() throws -> T {
        let typeKey = DependencyTypeKey(type: T.self)
        return try resolve(typeKey: typeKey)
    }

    func resolve<T: Sendable>(_ type: T.Type, key: DependencyKey) throws -> T {
        let typeKey = DependencyTypeKey(type: key.rawValue, key: key)
        return try resolve(typeKey: typeKey)
    }

    func resolve<T: Sendable>(typeKey: DependencyTypeKey) throws -> T {
        guard var dependency = dependencies[typeKey] else {
            throw DependencyError.notFound(name: typeKey.description)
        }

        if !dependency.isSingleton {
            try dependency.resolve(dependencies: self)
        }

        guard let object = try? dependency.value() as? T else {
            throw DependencyError.notResolved(name: typeKey.description)
        }

        return object
    }
}

// MARK: - DependencySingleton

extension DependencyCore {
    mutating func registerSingleton<T: Sendable>(
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) throws {
        let typeKey = DependencyTypeKey(type: T.self)
        return try registerSingleton(typeKey: typeKey, completion: completion)
    }

    mutating func registerSingleton<T: Sendable>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) throws {
        let typeKey = DependencyTypeKey(type: type)
        var dependency = DependencyResolverFactory.build(
            typeKey: typeKey,
            isSingleton: true,
            resolveBlock: completion
        )
        dependencies[typeKey] = try dependency.resolveDependency(dependencies: self)
    }

    mutating func registerSingleton<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey,
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) throws {
        let typeKey = DependencyTypeKey(type: type, key: key)
        var dependency = DependencyResolverFactory.build(
            typeKey: typeKey,
            isSingleton: true,
            resolveBlock: completion
        )
        dependencies[typeKey] = try dependency.resolveDependency(dependencies: self)
    }

    mutating func registerSingleton<T: Sendable>(
        typeKey: DependencyTypeKey,
        completion: @escaping @Sendable (any Dependency) throws -> T
    ) throws {
        var dependency = DependencyResolverFactory.build(
            typeKey: typeKey,
            isSingleton: true,
            resolveBlock: completion
        )

        try dependency.resolve(dependencies: self)

        dependencies[typeKey] = dependency
    }

    mutating func registerSingleton<T: Sendable>(
        _ type: T.Type
    ) throws where T: DependencyServiceType & Sendable {
        let completion: @Sendable (any Dependency) throws -> T = { @Sendable dependency in
            try T.makeService(for: dependency)
        }
        let typeKey = DependencyTypeKey(type: T.self)
        return try registerSingleton(typeKey: typeKey, completion: completion)
    }

    mutating func registerSingleton<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey
    ) throws where T: DependencyServiceType & Sendable {
        let typeKey = DependencyTypeKey(type: T.self, key: key)
        let completion: @Sendable (any Dependency) throws -> T = { @Sendable dependency in
            try T.makeService(for: dependency)
        }
        return try registerSingleton(typeKey: typeKey, completion: completion)
    }

    mutating func unregisterSingleton<T: Sendable>(
        _ type: T.Type
    ) {
        let typeKey = DependencyTypeKey(type: T.self)
        unregisterSingleton(typeKey: typeKey)
    }

    mutating func unregisterSingleton<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey
    ) {
        let typeKey = DependencyTypeKey(type: T.self, key: key)
        unregisterSingleton(typeKey: typeKey)
    }

    mutating func unregisterSingleton(
        typeKey: DependencyTypeKey
    ) {
        dependencies.removeValue(forKey: typeKey)
    }
}

// MARK: - DependencySingletonOperation

extension DependencyCore {
    mutating func registerSingletonOperation<T: Sendable>(
        _ type: T.Type,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) throws {
        try registerSingleton(type, completion: { dependencies in
            let result = try completion(dependencies)
            return try operation(result, dependencies)
        })
    }

    mutating func registerSingletonOperation<T: Sendable>(
        _ type: T.Type,
        key: DependencyKey,
        completion: @escaping @Sendable (any Dependency) throws -> T,
        operation: @escaping @Sendable (T, any Dependency) throws -> T
    ) throws {
        let typeKey = DependencyTypeKey(type: type, key: key)
        try registerSingleton(
            typeKey: typeKey
        ) { dependencies in
            let result = try completion(dependencies)
            return try operation(result, dependencies)
        }
    }
}

// MARK: - DependencyProvider

extension DependencyCore {
    /// Register provider
    /// - Parameter provider: the provider you will add
    mutating func registerProvider(_ provider: any Provider) {
        providers.append(provider)
    }

    /// Unregister provider
    /// - Parameter provider: the provider you will unregister
    mutating func unregisterProvider(_ provider: any Provider) {
        providers = providers.filter { $0.description != provider.description }
    }
}

// MARK: - DependencySubscript

extension DependencyCore {
    /// Get or set service's value from the dependencies.
    /// - Parameter keyPath: the dependency key
    subscript<T: Sendable>(
        _ keyPath: DependencyTypeKey
    ) -> T? {
        get {
            guard var dependencyResolver = dependencies[keyPath] else { return nil }
            if !dependencyResolver.isSingleton {
                try? dependencyResolver.resolve(dependencies: self)
            }
            return try? dependencyResolver.value() as? T
        }
        mutating set(value) {
            if value != nil {
                let isSingleton = dependencies[keyPath]?.isSingleton ?? false
                var dependencyResolver = DependencyResolverFactory.build(
                    isSingleton: isSingleton,
                    resolveBlock: { _ in value }
                )
                if isSingleton {
                    try? dependencyResolver.resolve(dependencies: self)
                }
                self.dependencies[keyPath] = dependencyResolver
            } else {
                self.dependencies.removeValue(forKey: keyPath)
            }
        }
    }
}
