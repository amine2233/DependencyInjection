import Foundation
@_spi(Internal) @_exported @testable import DependencyInjection

protocol DependencyRegisterProperty {
    mutating func register<
        Service: Sendable,
        Arg1: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (Dependency, Arg1) throws -> Service
    )

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (Dependency, Arg1, Arg2) throws -> Service
    )

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (Dependency, Arg1, Arg2, Arg3) throws -> Service
    )

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (Dependency, Arg1, Arg2, Arg3, Arg4) throws -> Service
    )
}

protocol DependencyResolverProperty {
    mutating func resolver<Service: Sendable, Arg1: Sendable>(
        _ type: Service.Type,
        argument: Arg1
    ) throws -> Service

    mutating func resolver<Service: Sendable, Arg1: Sendable, Arg2: Sendable>(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2
    ) throws -> Service

    mutating func resolver<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable>(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3
    ) throws -> Service

    mutating func resolver<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable, Arg4: Sendable>(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4
    ) throws -> Service
}
