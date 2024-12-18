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

    /// Automatically registers a service with no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service.
    public mutating func autoregisterSingleton<Service>(
        _ service: Service.Type,
        initializer: @escaping @Sendable () -> Service
    ) throws {
        try registerSingleton(service, completion: { _ in
            initializer()
        })
    }

    /// Automatically registers a service with one dependency.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking one dependency as a parameter.
    public mutating func autoregisterSingleton<Service, A>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
            try initializer(dependency.resolve(A.self))
        })
    }

    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking two dependencies as parameters.
    public mutating func autoregisterSingleton<Service, A, B>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
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
    public mutating func autoregisterSingleton<Service, A, B, C>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
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
    public mutating func autoregisterSingleton<Service, A, B, C, D>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
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
    public mutating func autoregisterSingleton<Service, A, B, C, D, E>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
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
    public mutating func autoregisterSingleton<Service, A, B, C, D, E, F>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
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
    public mutating func autoregisterSingleton<Service, A, B, C, D, E, F, G>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
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
    public mutating func autoregisterSingleton<Service, A, B, C, D, E, F, G, H>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G, H) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
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
    public mutating func autoregisterSingleton<Service, A, B, C, D, E, F, G, H, I>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G, H, I) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
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
    public mutating func autoregisterSingleton<Service, A, B, C, D, E, F, G, H, I, J>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G, H, I, J) -> Service
    ) throws {
        try registerSingleton(service, completion: { dependency in
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
