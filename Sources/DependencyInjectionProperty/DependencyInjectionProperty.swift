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

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (Dependency, Arg1, Arg2, Arg3, Arg4, Arg5) throws -> Service
    )

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (Dependency, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) throws -> Service
    )

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable,
        Arg7: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (
            Dependency,
            Arg1,
            Arg2,
            Arg3,
            Arg4,
            Arg5,
            Arg6,
            Arg7
        ) throws -> Service
    )

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable,
        Arg7: Sendable,
        Arg8: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (
            Dependency,
            Arg1,
            Arg2,
            Arg3,
            Arg4,
            Arg5,
            Arg6,
            Arg7,
            Arg8
        ) throws -> Service
    )

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable,
        Arg7: Sendable,
        Arg8: Sendable,
        Arg9: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (
            Dependency,
            Arg1,
            Arg2,
            Arg3,
            Arg4,
            Arg5,
            Arg6,
            Arg7,
            Arg8,
            Arg9
        ) throws -> Service
    )

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable,
        Arg7: Sendable,
        Arg8: Sendable,
        Arg9: Sendable,
        Arg10: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (
            Dependency,
            Arg1,
            Arg2,
            Arg3,
            Arg4,
            Arg5,
            Arg6,
            Arg7,
            Arg8,
            Arg9,
            Arg10
        ) throws -> Service
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

    mutating func resolver<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable
    >(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5
    ) throws -> Service

    mutating func resolver<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable
    >(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5,
        _ arg6: Arg6
    ) throws -> Service

    mutating func resolver<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable,
        Arg7: Sendable
    >(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5,
        _ arg6: Arg6,
        _ arg7: Arg7
    ) throws -> Service

    mutating func resolver<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable,
        Arg7: Sendable,
        Arg8: Sendable
    >(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5,
        _ arg6: Arg6,
        _ arg7: Arg7,
        _ arg8: Arg8
    ) throws -> Service

    mutating func resolver<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable,
        Arg7: Sendable,
        Arg8: Sendable,
        Arg9: Sendable
    >(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5,
        _ arg6: Arg6,
        _ arg7: Arg7,
        _ arg8: Arg8,
        _ arg9: Arg9
    ) throws -> Service

    mutating func resolver<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable,
        Arg7: Sendable,
        Arg8: Sendable,
        Arg9: Sendable,
        Arg10: Sendable
    >(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5,
        _ arg6: Arg6,
        _ arg7: Arg7,
        _ arg8: Arg8,
        _ arg9: Arg9,
        _ arg10: Arg10
    ) throws -> Service
}
