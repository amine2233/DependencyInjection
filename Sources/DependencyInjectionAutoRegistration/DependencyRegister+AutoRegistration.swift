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

    /// Automatically registers a service with no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service.
    public mutating func autoregister<Service>(
        _ service: Service.Type,
        initializer: @escaping @Sendable () -> Service
    ) {
        register(service, completion: { _ in
            initializer()
        })
    }

    /// Automatically registers a service with one dependency.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking one dependency as a parameter.
    public mutating func autoregister<Service, A>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(dependency.resolve(A.self))
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking two dependencies as parameters.
    public mutating func autoregister<Service, A, B>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(
                dependency.resolve(A.self),
                dependency.resolve(B.self)
            )
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking three dependencies as parameters.
    public mutating func autoregister<Service, A, B, C>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(
                dependency.resolve(A.self),
                dependency.resolve(B.self),
                dependency.resolve(C.self)
            )
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking four dependencies as parameters.
    public mutating func autoregister<Service, A, B, C, D>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(
                dependency.resolve(A.self),
                dependency.resolve(B.self),
                dependency.resolve(C.self),
                dependency.resolve(D.self)
            )
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking five dependencies as parameters.
    public mutating func autoregister<Service, A, B, C, D, E>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(
                dependency.resolve(A.self),
                dependency.resolve(B.self),
                dependency.resolve(C.self),
                dependency.resolve(D.self),
                dependency.resolve(E.self)
            )
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking six dependencies as parameters.
    public mutating func autoregister<Service, A, B, C, D, E, F>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(
                dependency.resolve(A.self),
                dependency.resolve(B.self),
                dependency.resolve(C.self),
                dependency.resolve(D.self),
                dependency.resolve(E.self),
                dependency.resolve(F.self)
            )
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking seven dependencies as parameters.
    public mutating func autoregister<Service, A, B, C, D, E, F, G>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(
                dependency.resolve(A.self),
                dependency.resolve(B.self),
                dependency.resolve(C.self),
                dependency.resolve(D.self),
                dependency.resolve(E.self),
                dependency.resolve(F.self),
                dependency.resolve(G.self)
            )
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking eight dependencies as parameters.
    public mutating func autoregister<Service, A, B, C, D, E, F, G, H>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G, H) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(
                dependency.resolve(A.self),
                dependency.resolve(B.self),
                dependency.resolve(C.self),
                dependency.resolve(D.self),
                dependency.resolve(E.self),
                dependency.resolve(F.self),
                dependency.resolve(G.self),
                dependency.resolve(H.self)
            )
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking eight dependencies as parameters.
    public mutating func autoregister<Service, A, B, C, D, E, F, G, H, I>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G, H, I) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(
                dependency.resolve(A.self),
                dependency.resolve(B.self),
                dependency.resolve(C.self),
                dependency.resolve(D.self),
                dependency.resolve(E.self),
                dependency.resolve(F.self),
                dependency.resolve(G.self),
                dependency.resolve(H.self),
                dependency.resolve(I.self)
            )
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking eight dependencies as parameters.
    public mutating func autoregister<Service, A, B, C, D, E, F, G, H, I, J>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G, H, I, J) -> Service
    ) {
        register(service, completion: { dependency in
            try initializer(
                dependency.resolve(A.self),
                dependency.resolve(B.self),
                dependency.resolve(C.self),
                dependency.resolve(D.self),
                dependency.resolve(E.self),
                dependency.resolve(F.self),
                dependency.resolve(G.self),
                dependency.resolve(H.self),
                dependency.resolve(I.self),
                dependency.resolve(J.self)
            )
        })
    }
}
