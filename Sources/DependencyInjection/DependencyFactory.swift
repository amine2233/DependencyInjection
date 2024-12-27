import Foundation

/// Create the dependency factory
public enum DependencyFactory: Sendable {
    /// Make a new dependency
    ///
    /// - Parameters:
    ///   - environment: The environment type
    ///   - dependencies: The dependencies
    ///   - providers: The providers
    /// - Returns: A new Dependency
    public static func make(
        environment: DependencyEnvironment = .production,
        dependencies: [DependencyTypeKey: any DependencyResolver] = [:],
        providers: [any Provider] = []
    ) -> any Dependency {
        return DependencyCore(
            environment: environment,
            dependencies: dependencies,
            providers: providers
        )
    }
    
    /// The default dependency
    public static func `default`() -> any Dependency {
        DependencyCore.shared
    }
}
