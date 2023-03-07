import Foundation

public protocol DependencyRegistering {
    static func registerAllServices(in dependencies: inout Dependency)
}

/// Has dependencies
public protocol HasDependencies {
    var dependencies: Dependency { get }
}

extension HasDependencies {
    var dependencies: Dependency {
        DependencyInjector.default.dependencies
    }
}

/// The singleton dependency container reference
/// which can be reassigned to another container
public struct DependencyInjector {
    /// The dependencies
    public var dependencies: Dependency

    /// The dependencyCore singleton
    public static var `default` = DependencyInjector()

    @resultBuilder struct DependencyBuilder {
        static func buildBlock(_ dependency: DependencyResolver) -> DependencyResolver { dependency }
        static func buildBlock(_ dependencies: DependencyResolver...) -> [DependencyResolver] { dependencies }
    }

    @resultBuilder struct ProviderBuilder {
        static func buildBlock(_ dependency: Provider) -> Provider { dependency }
        static func buildBlock(_ dependencies: Provider...) -> [Provider] { dependencies }
    }

    @resultBuilder struct DependencyRegisteringBuilder {
        static func buildBlock(_ components: DependencyRegistering.Type...) -> [DependencyRegistering.Type] {
            components
        }
        static func buildBlock(_ component: DependencyRegistering.Type) -> DependencyRegistering.Type {
            component
        }
    }

    /// Create a new dependency injection
    /// - Parameter dependencies: The dependencies
    public init(dependencies: Dependency = DependencyCore()) {
        self.dependencies = dependencies
    }

    /// Create a new dependency injector
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - block: to add `DependencyResolver` manually
    ///   - providers: to add `Provider` manually
    public init(dependencies: Dependency = DependencyCore(),
        @DependencyBuilder _ block: () -> [DependencyResolver] = { [] },
        @ProviderBuilder _ providers: () -> [Provider] = { [] }
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
    public init(dependencies: Dependency = DependencyCore(),
        @DependencyBuilder _ dependency:  () -> DependencyResolver,
        @ProviderBuilder _ provider:  () -> Provider
    ) {
        self.init(dependencies: dependencies)
        self.dependencies.register(dependency())
        self.dependencies.registerProvider(provider())
    }

    /// Create a new dependency injector
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - register: The registration
    public init(dependencies: Dependency = DependencyCore(), register: DependencyRegistering.Type) {
        self.init(dependencies: dependencies)
        register.registerAllServices(in: &self.dependencies)
    }

    /// Create a new dependency injection
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - register: register one register type using resultBuilder
    public init(
        dependencies: Dependency = DependencyCore(),
        @DependencyRegisteringBuilder _ register: () -> DependencyRegistering.Type
    ) {
        self.init(dependencies: dependencies)
        register().registerAllServices(in: &self.dependencies)
    }

    /// Create a new dependency injection
    /// - Parameters:
    ///   - dependencies: The dependencies
    ///   - registers: registers many register type using resultBuilder
    public init(
        dependencies: Dependency = DependencyCore(),
        @DependencyRegisteringBuilder _ registers: () -> [DependencyRegistering.Type]
    ) {
        self.init(dependencies: dependencies)
        registers().forEach { $0.registerAllServices(in: &self.dependencies) }
    }

    // MARK: DependencyInjection Mutating

    /// Register dependency
    /// - Parameter register: The register type
    public mutating func register(type register: DependencyRegistering.Type) {
        register.registerAllServices(in: &self.dependencies)
    }

    /// Register dependency using result builder
    /// - Parameter register: The callback contain the registration type
    public mutating func register(
        @DependencyRegisteringBuilder _ register: () -> DependencyRegistering.Type
    ) {
        register().registerAllServices(in: &self.dependencies)
    }

    /// Register dependencies using result builder
    /// - Parameter register: The callback contain the registration types
    public mutating func registers(
        @DependencyRegisteringBuilder _ registers: () -> [DependencyRegistering.Type]
    ) {
        registers().forEach { $0.registerAllServices(in: &self.dependencies) }
    }

    // MARK: DependencyInjection for preview Mutating

    /// Register dependency for preview
    /// - Parameter register: The register type
    public mutating func preview(type register: DependencyRegistering.Type) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            register.registerAllServices(in: &self.dependencies)
        }
    }

    /// Register dependency for preview using result builder
    /// - Parameter register: The callback contain the registration type
    public mutating func preview(@DependencyRegisteringBuilder _ preview: () -> DependencyRegistering.Type) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            preview().registerAllServices(in: &self.dependencies)
        }
    }

    /// Register dependencies  for preview using result builder
    /// - Parameter register: The callback contain the registration types
    public mutating func previews(
        @DependencyRegisteringBuilder _ registers: () -> [DependencyRegistering.Type]
    ) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            registers().forEach { $0.registerAllServices(in: &self.dependencies) }
        }
    }

    // MARK: DependencyInjection registers DependencyResolver

    /// Register dependencies using `DependencyResolver`
    /// - Parameter register: The callback contain an array of `DependencyResolver`
    public mutating func registers(@DependencyBuilder _ block: () -> [DependencyResolver] = { [] }) {
        block().forEach { self.dependencies.register($0) }
    }

    /// Register dependency using `DependencyResolver`
    /// - Parameter register: The callback contain a `DependencyResolver`
    public mutating func register(@DependencyBuilder _ dependency:  () -> DependencyResolver) {
        self.dependencies.register(dependency())
    }

    // MARK: DependencyInjection registers Provider

    /// Register providers using `Provider`
    /// - Parameter register: The callback contain an array of `Provider`
    public mutating func providers(@ProviderBuilder _ providers: () -> [Provider] = { [] }) {
        providers().forEach { self.dependencies.registerProvider($0) }
    }

    /// Register dependency using `Provider`
    /// - Parameter register: The callback contain a `Provider`
    public mutating func provider(@ProviderBuilder _ provider:  () -> Provider) {
        self.dependencies.registerProvider(provider())
    }
}
