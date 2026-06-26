import DependencyInjection
import Foundation

/// Extension providing utility methods for automatically registering services with initializers.
extension DependencyRegister {
    /// Registers a service with the dependency container.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: The instance of the service to register.
    public mutating func autoregister<Service: Sendable>(
        _ service: Service.Type,
        initializer: Service
    ) {
        register(service, completion: { @Sendable _ in
            initializer
        })
    }

    /// Automatically registers a service, resolving each of its initializer dependencies from the
    /// container.
    ///
    /// A single parameter pack handles any number of dependencies: every type in `each Dependency`
    /// is resolved from the container, in order, and forwarded to `initializer`. An empty pack
    /// registers a service that has no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that builds the service from its resolved dependencies.
    public mutating func autoregister<Service: Sendable, each Dependency: Sendable>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (repeat each Dependency) -> Service
    ) {
        register(service) { container in
            try initializer(repeat container.resolve((each Dependency).self))
        }
    }
}
