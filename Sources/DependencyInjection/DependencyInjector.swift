import Foundation

/// A protocol that defines a method for registering all services in a dependency container.
public protocol DependencyRegistering {
    /// Registers all services in the given dependency container.
    ///
    /// - Parameter dependencies: The dependency container in which to register the services.
    static func registerAllServices(in dependencies: inout any Dependency)
}

/// A protocol that indicates that a type has dependencies.
public protocol HasDependencies {
    /// The dependency container.
    var dependencies: any Dependency { get }
}

/// Default implementation for types conforming to `HasDependencies`.
extension HasDependencies {
    /// Provides access to the default dependency container.
    var dependencies: any Dependency {
        DependencyInjector.default.dependencies
    }
}

/// The singleton dependency container reference which can be reassigned to another container
public struct DependencyInjector: Sendable {
    /// The dependencies
    public var dependencies: any Dependency

    /// The dependencyCore singleton
    public static let `default` = DependencyInjector()

    @resultBuilder
    struct DependencyBuilder {
        static func buildBlock(_ dependency: any DependencyResolver) -> any DependencyResolver { dependency }
        static func buildBlock(_ dependencies: any DependencyResolver...) -> [any DependencyResolver] { dependencies }
    }

    @resultBuilder
    struct ProviderBuilder {
        static func buildBlock(_ dependency: any Provider) -> any Provider { dependency }
        static func buildBlock(_ dependencies: any Provider...) -> [any Provider] { dependencies }
    }

    @resultBuilder
    struct DependencyRegisteringBuilder {
        static func buildBlock(_ components: any DependencyRegistering.Type...) -> [any DependencyRegistering.Type] {
            components
        }

        static func buildBlock(_ component: any DependencyRegistering.Type) -> any DependencyRegistering.Type {
            component
        }
    }

    /// Create a new dependency injection
    /// - Parameter dependencies: The dependencies
    public init(dependencies: any Dependency = DependencyCore()) {
        self.dependencies = dependencies
    }

    /// Create a new dependency injector
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - block: to add `DependencyResolver` manually
    ///   - providers: to add `Provider` manually
    public init(
        dependencies: any Dependency = DependencyCore(),
        @DependencyBuilder _ block: () -> [any DependencyResolver] = { [] },
        @ProviderBuilder _ providers: () -> [any Provider] = { [] }
    ) {
        self.init(dependencies: dependencies)
        block().forEach { self.dependencies.register($0) }
        providers().forEach { self.dependencies.registerProvider($0) }
    }

    /// Create a new dependency injector
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - block: to add one `DependencyResolver` manually
    ///   - providers: to add  one `Provider` manually
    public init(
        dependencies: any Dependency = DependencyCore(),
        @DependencyBuilder _ dependency: () -> any DependencyResolver,
        @ProviderBuilder _ provider: () -> any Provider
    ) {
        self.init(dependencies: dependencies)
        self.dependencies.register(dependency())
        self.dependencies.registerProvider(provider())
    }

    /// Create a new dependency injector
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - register: The registration
    public init(dependencies: any Dependency = DependencyCore(), register: any DependencyRegistering.Type) {
        self.init(dependencies: dependencies)
        register.registerAllServices(in: &self.dependencies)
    }

    /// Create a new dependency injection
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - register: register one register type using resultBuilder
    public init(
        dependencies: any Dependency = DependencyCore(),
        @DependencyRegisteringBuilder _ register: () -> any DependencyRegistering.Type
    ) {
        self.init(dependencies: dependencies)
        register().registerAllServices(in: &self.dependencies)
    }

    /// Create a new dependency injection
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - registers: registers many register type using resultBuilder
    public init(
        dependencies: any Dependency = DependencyCore(),
        @DependencyRegisteringBuilder _ registers: () -> [any DependencyRegistering.Type]
    ) {
        self.init(dependencies: dependencies)
        registers().forEach { $0.registerAllServices(in: &self.dependencies) }
    }

    // MARK: DependencyInjection Mutating

    /// Register dependency
    /// - Parameter register: The register type
    public mutating func register(type register: any DependencyRegistering.Type) {
        register.registerAllServices(in: &dependencies)
    }

    /// Register dependency using result builder
    /// - Parameter register: The callback contain the registration type
    public mutating func register(
        @DependencyRegisteringBuilder _ register: () -> any DependencyRegistering.Type
    ) {
        register().registerAllServices(in: &dependencies)
    }

    /// Register dependencies using result builder
    /// - Parameter register: The callback contain the registration types
    public mutating func registers(
        @DependencyRegisteringBuilder _ registers: () -> [any DependencyRegistering.Type]
    ) {
        registers().forEach { $0.registerAllServices(in: &dependencies) }
    }

    // MARK: DependencyInjection for preview Mutating

    /// Register dependency for preview
    /// - Parameter register: The register type
    public mutating func preview(type register: any DependencyRegistering.Type) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            register.registerAllServices(in: &dependencies)
        }
    }

    /// Register dependency for preview using result builder
    /// - Parameter register: The callback contain the registration type
    public mutating func preview(@DependencyRegisteringBuilder _ preview: () -> any DependencyRegistering.Type) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            preview().registerAllServices(in: &dependencies)
        }
    }

    /// Register dependencies  for preview using result builder
    /// - Parameter register: The callback contain the registration types
    public mutating func previews(
        @DependencyRegisteringBuilder _ registers: () -> [any DependencyRegistering.Type]
    ) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            registers().forEach { $0.registerAllServices(in: &dependencies) }
        }
    }

    // MARK: DependencyInjection registers DependencyResolver

    /// Register dependencies using `DependencyResolver`
    /// - Parameter register: The callback contain an array of `DependencyResolver`
    public mutating func registers(@DependencyBuilder _ block: () -> [any DependencyResolver] = { [] }) {
        block().forEach { dependencies.register($0) }
    }

    /// Register dependency using `DependencyResolver`
    /// - Parameter register: The callback contain a `DependencyResolver`
    public mutating func register(@DependencyBuilder _ dependency: () -> any DependencyResolver) {
        dependencies.register(dependency())
    }

    // MARK: DependencyInjection registers Provider

    /// Register providers using `Provider`
    /// - Parameter register: The callback contain an array of `Provider`
    public mutating func providers(@ProviderBuilder _ providers: () -> [any Provider] = { [] }) {
        providers().forEach { dependencies.registerProvider($0) }
    }

    /// Register dependency using `Provider`
    /// - Parameter register: The callback contain a `Provider`
    public mutating func provider(@ProviderBuilder _ provider: () -> any Provider) {
        dependencies.registerProvider(provider())
    }
}
