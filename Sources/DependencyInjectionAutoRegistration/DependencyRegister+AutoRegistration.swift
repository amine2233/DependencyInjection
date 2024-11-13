//
//  DependencyAutoRegistration.swift
//  
//
//  Created by amine on 18/05/2024.
//

import Foundation
import DependencyInjection

/// Extension providing utility methods for automatically registering services with initializers.
public extension DependencyRegister {
    
    /// Registers a service with the dependency container.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: The instance of the service to register.
    mutating func autoregister<Service: Sendable>(
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
    mutating func autoregister<Service>(
        _ service: Service.Type,
        initializer: @escaping @Sendable () -> Service
    ) {
        self.register(service, completion: { _ in
            initializer()
        })
    }
    
    /// Automatically registers a service with one dependency.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking one dependency as a parameter.
    mutating func autoregister<Service, A>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A) -> Service
    ) {
        self.register(service, completion: { dependency in
            initializer(try dependency.resolve(A.self))
        })
    }
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking two dependencies as parameters.
    mutating func autoregister<Service, A, B>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B) -> Service
    ) {
        self.register(service, completion: { dependency in
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
    mutating func autoregister<Service, A, B, C>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C) -> Service
    ) {
        self.register(service, completion: { dependency in
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
    mutating func autoregister<Service, A, B, C, D>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D) -> Service
    ) {
        self.register(service, completion: { dependency in
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
    mutating func autoregister<Service, A, B, C, D, E>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E) -> Service
    ) {
        self.register(service, completion: { dependency in
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
    mutating func autoregister<Service, A, B, C, D, E, F>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F) -> Service
    ) {
        self.register(service, completion: { dependency in
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
    mutating func autoregister<Service, A, B, C, D, E, F, G>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G) -> Service
    ) {
        self.register(service, completion: { dependency in
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
    mutating func autoregister<Service, A, B, C, D, E, F, G, H>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G, H) -> Service
    ) {
        self.register(service, completion: { dependency in
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
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking eight dependencies as parameters.
    mutating func autoregister<Service, A, B, C, D, E, F, G, H, I>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G, H, I) -> Service
    ) {
        self.register(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self),
                try dependency.resolve(C.self),
                try dependency.resolve(D.self),
                try dependency.resolve(E.self),
                try dependency.resolve(F.self),
                try dependency.resolve(G.self),
                try dependency.resolve(H.self),
                try dependency.resolve(I.self)
            )
        })
    }
    
    /// Automatically registers a service with two dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service, taking eight dependencies as parameters.
    mutating func autoregister<Service, A, B, C, D, E, F, G, H, I, J>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (A, B, C, D, E, F, G, H, I, J) -> Service
    ) {
        self.register(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self),
                try dependency.resolve(C.self),
                try dependency.resolve(D.self),
                try dependency.resolve(E.self),
                try dependency.resolve(F.self),
                try dependency.resolve(G.self),
                try dependency.resolve(H.self),
                try dependency.resolve(I.self),
                try dependency.resolve(J.self)
            )
        })
    }
}
