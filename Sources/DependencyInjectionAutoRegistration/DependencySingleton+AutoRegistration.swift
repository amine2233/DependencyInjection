import Foundation
import DependencyInjection

extension DependencySingleton {
    mutating func autoregisterSingleton<Service>(
        _ service: Service.Type,
        initializer: @escaping () -> Service
    ) throws {
        try self.registerSingleton(service, completion: { _ in
            initializer()
        })
    }
    
    mutating func autoregisterSingleton<Service, A>(
        _ service: Service.Type,
        initializer: @escaping (A) -> Service
    ) throws {
        try self.registerSingleton(service, completion: { dependency in
            initializer(try dependency.resolve(A.self))
        })
    }
    
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
