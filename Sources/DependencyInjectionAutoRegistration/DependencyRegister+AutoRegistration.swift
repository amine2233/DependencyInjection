//
//  DependencyAutoRegistration.swift
//  
//
//  Created by amine on 18/05/2024.
//

import Foundation
import DependencyInjection

public extension DependencyRegister {
    mutating func autoregister<Service>(
        _ service: Service.Type,
        initializer: @escaping () -> Service
    ) {
        self.register(service, completion: { _ in
            initializer()
        })
    }
    
    mutating func autoregister<Service, A>(
        _ service: Service.Type,
        initializer: @escaping (A) -> Service
    ) {
        self.register(service, completion: { dependency in
            initializer(try dependency.resolve(A.self))
        })
    }
    
    mutating func autoregister<Service, A, B>(
        _ service: Service.Type,
        initializer: @escaping (A, B) -> Service
    ) {
        self.register(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self)
            )
        })
    }
    
    mutating func autoregister<Service, A, B, C>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C) -> Service
    ) {
        self.register(service, completion: { dependency in
            initializer(
                try dependency.resolve(A.self),
                try dependency.resolve(B.self),
                try dependency.resolve(C.self)
            )
        })
    }
    
    mutating func autoregister<Service, A, B, C, D>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D) -> Service
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
    
    mutating func autoregister<Service, A, B, C, D, E>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D, E) -> Service
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
    
    mutating func autoregister<Service, A, B, C, D, E, F>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D, E, F) -> Service
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
    
    mutating func autoregister<Service, A, B, C, D, E, F, G>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D, E, F, G) -> Service
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
    
    mutating func autoregister<Service, A, B, C, D, E, F, G, H>(
        _ service: Service.Type,
        initializer: @escaping (A, B, C, D, E, F, G, H) -> Service
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
}
