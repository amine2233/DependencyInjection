import Foundation

public protocol DependencyRegistering {
    static func registerAllServices(in dependencies: inout Dependency)
}

public protocol HasDependencies {
    var dependencies: Dependency { get }
}

/// The singleton dependency container reference
/// which can be reassigned to another container
public struct DependencyInjector: HasDependencies {
    public var dependencies: Dependency

    @resultBuilder struct DependencyBuilder {
        static func buildBlock(_ dependency: DependencyResolver) -> DependencyResolver { dependency }
        static func buildBlock(_ dependencies: DependencyResolver...) -> [DependencyResolver] { dependencies }
    }

    @resultBuilder struct ProviderBuilder {
        static func buildBlock(_ dependency: Provider) -> Provider { dependency }
        static func buildBlock(_ dependencies: Provider...) -> [Provider] { dependencies }
    }

    public init(dependencies: Dependency = DependencyCore()) {
        self.dependencies = dependencies
    }

    public init(dependencies: Dependency = DependencyCore(),
        @DependencyBuilder _ block: () -> [DependencyResolver] = { [] },
        @ProviderBuilder _ providers: () -> [Provider] = { [] }) {
        self.init(dependencies: dependencies)
        block().forEach { self.dependencies.register($0) }
        providers().forEach { self.dependencies.registerProvider($0) }
    }

    init(dependencies: Dependency = DependencyCore(),
        @DependencyBuilder _ dependency:  () -> DependencyResolver,
        @ProviderBuilder _ provider:  () -> Provider) {
        self.init(dependencies: dependencies)
        self.dependencies.register(dependency())
        self.dependencies.registerProvider(provider())
    }

    public init(dependencies: Dependency = DependencyCore(), register: DependencyRegistering.Type) {
        self.init(dependencies: dependencies)
        register.registerAllServices(in: &self.dependencies)
    }
}
