import Foundation
import DependencyInjection

/// Extension providing utility methods for automatically registering singleton services with initializers.
public extension DependencySingleton {
    
    /// Registers a singleton service with the dependency container.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: The instance of the service to register as a singleton.
    /// - Throws: Throws an error if the service cannot be registered.
    mutating func autoregisterSingleton<Service>(
        _ service: Service.Type,
        initializer: Service
    ) throws {
        try self.registerSingleton(service, completion: { _ in
            initializer
        })
    }

    /// Automatically registers a service with no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service.
    mutating func autoregisterSingleton<Service>(
        _ service: Service.Type,
        initializer: @escaping () -> Service
    ) throws {
        try self.registerSingleton(service, completion: { _ in
            initializer()
        })
    }
    
    /// Automatically registers a service with one dependency.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking one dependency as a parameter.
    mutating func autoregisterSingleton<Service, A>(
        _ service: Service.Type,
        initializer: @escaping (A) -> Service
    ) throws {
        try self.registerSingleton(service, completion: { dependency in
            initializer(try dependency.resolve(A.self))
        })
    }
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking two dependencies as parameters.
    mutating func autoregisterSingleton<Service, A, B>(
        _ service: Service.Type,
        initializer: @escaping (A, B) -> Service
    ) throws {
        try self.registerSingleton(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self)
            )
        })
    }
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking three dependencies as parameters.
    mutating func autoregisterSingleton<Service, A, B, C>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C) -> Service
    ) throws {
        try self.registerSingleton(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self),
                try dependency.resolve(C.self)
            )
        })
    }
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking four dependencies as parameters.
    mutating func autoregisterSingleton<Service, A, B, C, D>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D) -> Service
    ) throws {
        try self.registerSingleton(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self),
                try dependency.resolve(C.self),
                try dependency.resolve(D.self)
            )
        })
    }
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking five dependencies as parameters.
    mutating func autoregisterSingleton<Service, A, B, C, D, E>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D, E) -> Service
    ) throws {
        try self.registerSingleton(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self),
                try dependency.resolve(C.self),
                try dependency.resolve(D.self),
                try dependency.resolve(E.self)
            )
        })
    }
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking six dependencies as parameters.
    mutating func autoregisterSingleton<Service, A, B, C, D, E, F>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D, E, F) -> Service
    ) throws {
        try self.registerSingleton(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self),
                try dependency.resolve(C.self),
                try dependency.resolve(D.self),
                try dependency.resolve(E.self),
                try dependency.resolve(F.self)
            )
        })
    }
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking seven dependencies as parameters.
    mutating func autoregisterSingleton<Service, A, B, C, D, E, F, G>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D, E, F, G) -> Service
    ) throws {
        try self.registerSingleton(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self),
                try dependency.resolve(C.self),
                try dependency.resolve(D.self),
                try dependency.resolve(E.self),
                try dependency.resolve(F.self),
                try dependency.resolve(G.self)
            )
        })
    }
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking eight dependencies as parameters.
    mutating func autoregisterSingleton<Service, A, B, C, D, E, F, G, H>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D, E, F, G, H) -> Service
    ) throws {
        try self.registerSingleton(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self),
                try dependency.resolve(C.self),
                try dependency.resolve(D.self),
                try dependency.resolve(E.self),
                try dependency.resolve(F.self),
                try dependency.resolve(G.self),
                try dependency.resolve(H.self)
            )
        })
    }
}
