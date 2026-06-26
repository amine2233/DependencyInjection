import DependencyInjection
import Foundation

/// Extension providing utility methods for automatically registering singleton services with initializers.
extension DependencySingleton {
    /// Registers a singleton service with the dependency container.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: The instance of the service to register as a singleton.
    /// - Throws: Throws an error if the service cannot be registered.
    public mutating func autoregisterSingleton<Service: Sendable>(
        _ service: Service.Type,
        initializer: Service
    ) throws {
        try registerSingleton(service, completion: { _ in
            initializer
        })
    }

    /// Automatically registers a singleton service, resolving each of its initializer dependencies
    /// from the container.
    ///
    /// A single parameter pack handles any number of dependencies: every type in `each Dependency`
    /// is resolved from the container, in order, and forwarded to `initializer`. An empty pack
    /// registers a singleton that has no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that builds the service from its resolved dependencies.
    /// - Throws: Throws an error if a dependency cannot be resolved or the service cannot be registered.
    public mutating func autoregisterSingleton<Service: Sendable, each Dependency: Sendable>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (repeat each Dependency) -> Service
    ) throws {
        try registerSingleton(service) { container in
            try initializer(repeat container.resolve((each Dependency).self))
        }
    }
}
