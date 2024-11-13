import Foundation
import DependencyInjection

extension DependencyRegister {
    /// Automatically registers a service with no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service.
    mutating func autoregister<Service>(
        _ service: Service.Type,
        factory: Factory0<Service>
    ) {
        self.register(service, completion: { _ in
            factory()
        })
    }
    
    /// Automatically registers a service with no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service.
    mutating func autoregister<Service, A>(
        _ service: Service.Type,
        factory: Factory1<Service, A>
    ) {
        self.register(service, completion: { dependency in
            try factory(dependency.resolve())
        })
    }
    
    /// Automatically registers a service with no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service.
    mutating func autoregister<Service, A, B>(
        _ service: Service.Type,
        factory: Factory2<Service, A, B>
    ) {
        self.register(service, completion: { dependency in
            try factory(
                dependency.resolve(),
                dependency.resolve()
            )
        })
    }
    
    /// Automatically registers a service with no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service.
    mutating func autoregister<Service, A, B, C>(
        _ service: Service.Type,
        factory: Factory3<Service, A, B, C>
    ) {
        self.register(service, completion: { dependency in
            try factory(
                dependency.resolve(),
                dependency.resolve(),
                dependency.resolve()
            )
        })
    }
    
    /// Automatically registers a service with no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service.
    mutating func autoregister<Service, A, B, C, D>(
        _ service: Service.Type,
        factory: Factory4<Service, A, B, C, D>
    ) {
        self.register(service, completion: { dependency in
            try factory(
                dependency.resolve(),
                dependency.resolve(),
                dependency.resolve(),
                dependency.resolve()
            )
        })
    }
    
    /// Automatically registers a service with no dependencies.
    ///
    /// - Parameters:
    ///   - service: The type of the service to register.
    ///   - initializer: A closure that initializes and returns an instance of the service.
    mutating func autoregister<Service, A, B, C, D, E>(
        _ service: Service.Type,
        factory: Factory5<Service, A, B, C, D, E>
    ) {
        self.register(service, completion: { dependency in
            try factory(
                dependency.resolve(),
                dependency.resolve(),
                dependency.resolve(),
                dependency.resolve(),
                dependency.resolve()
            )
        })
    }
}

public struct Factory0<Service>: Sendable {
    private let builder: @Sendable (()) -> Service

    init(_ builder: @escaping @Sendable (()) -> Service) {
        self.builder = builder
    }

    public func build(
    ) -> Service {
        builder(())
    }

    public func callAsFunction(
    ) -> Service {
        builder(())
    }
}

public struct Factory1<Service, A>: Sendable {
    private let builder: @Sendable (A) -> Service
    
    init(builder: @escaping @Sendable (A) -> Service) {
        self.builder = builder
    }

    public func build(_ arg1: A) -> Service {
        builder(arg1)
    }

    public func callAsFunction(_ arg1: A) -> Service {
        builder(arg1)
    }
}

public struct Factory2<Service, A, B>: Sendable {
    private let builder: @Sendable (A, B) -> Service

    init(_ builder: @escaping @Sendable (A, B) -> Service) {
        self.builder = builder
    }

    public func build(_ arg1: A, _ arg2: B) -> Service {
        builder(arg1, arg2)
    }

    public func callAsFunction(_ arg1: A, _ arg2: B) -> Service {
        builder(arg1, arg2)
    }
}

public struct Factory3<Service, A, B, C>: Sendable {
    private let builder: @Sendable (A, B, C) -> Service

    init(_ builder: @escaping @Sendable (A, B, C) -> Service) {
        self.builder = builder
    }

    public func build(_ arg1: A, _ arg2: B, _ arg3: C) -> Service {
        builder(arg1, arg2, arg3)
    }

    public func callAsFunction(_ arg1: A, _ arg2: B, _ arg3: C) -> Service {
        builder(arg1, arg2, arg3)
    }
}

public struct Factory4<Service, A, B, C, D>: Sendable {
    private let builder: @Sendable (A, B, C, D) -> Service

    init(_ builder: @escaping @Sendable (A, B, C, D) -> Service) {
        self.builder = builder
    }

    public func build(_ arg1: A, _ arg2: B, _ arg3: C, _ arg4: D) -> Service {
        builder(arg1, arg2, arg3, arg4)
    }

    public func callAsFunction(_ arg1: A, _ arg2: B, _ arg3: C, _ arg4: D) -> Service {
        builder(arg1, arg2, arg3, arg4)
    }
}

public struct Factory5<Service, A, B, C, D, E>: Sendable {
    private let builder: @Sendable (A, B, C, D, E) -> Service

    init(_ builder: @escaping @Sendable (A, B, C, D, E) -> Service) {
        self.builder = builder
    }

    public func build(_ arg1: A, _ arg2: B, _ arg3: C, _ arg4: D, _ arg5: E) -> Service {
        builder(arg1, arg2, arg3, arg4, arg5)
    }

    public func callAsFunction(_ arg1: A, _ arg2: B, _ arg3: C, _ arg4: D, _ arg5: E) -> Service {
        builder(arg1, arg2, arg3, arg4, arg5)
    }
}
