import Foundation

extension DependencyCore: DependencyRegisterProperty {
    mutating func register<Service: Sendable, Arg1: Sendable>(
        _ type: Service.Type,
        completion: @escaping @Sendable (any Dependency, Arg1) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: { dependencies, parameters throws -> Service in
                guard let parameter = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                return try completion(dependencies, parameter)
            }
        )
    }

    public mutating func autoregister<Service: Sendable, Arg1: Sendable>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1) throws -> Service
    ) {
        register(service) { _, parameter in
            try initializer(parameter)
        }
    }

    mutating func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable>(
        _ type: Service.Type,
        completion: @escaping @Sendable (any DependencyInjection.Dependency, Arg1, Arg2) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: {
                dependencies, parameters throws -> Service in
                guard let parameter1 = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                guard let parameter2 = parameters[1] as? Arg2 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg2.self)
                    )
                }
                return try completion(
                    dependencies,
                    parameter1,
                    parameter2
                )
            }
        )
    }

    public mutating func autoregister<Service: Sendable, Arg1: Sendable, Arg2: Sendable>(
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1, Arg2) throws -> Service
    ) {
        register(service) { _, parameter1, parameter2 in
            try initializer(parameter1, parameter2)
        }
    }

    mutating func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable>(
        _ type: Service.Type,
        completion: @escaping @Sendable (any DependencyInjection.Dependency, Arg1, Arg2, Arg3) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: {
                dependencies, parameters throws -> Service in
                guard let parameter1 = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                guard let parameter2 = parameters[1] as? Arg2 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg2.self)
                    )
                }
                guard let parameter3 = parameters[2] as? Arg3 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg3.self)
                    )
                }
                return try completion(
                    dependencies,
                    parameter1,
                    parameter2,
                    parameter3
                )
            }
        )
    }

    public mutating func autoregister<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable
    >(
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1, Arg2, Arg3) throws -> Service
    ) {
        register(service) {
            _,
                parameter1,
                parameter2,
                parameter3 in
            try initializer(parameter1, parameter2, parameter3)
        }
    }

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (any DependencyInjection.Dependency, Arg1, Arg2, Arg3, Arg4) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: {
                dependencies, parameters throws -> Service in
                guard let parameter1 = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                guard let parameter2 = parameters[1] as? Arg2 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg2.self)
                    )
                }
                guard let parameter3 = parameters[2] as? Arg3 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg3.self)
                    )
                }
                guard let parameter4 = parameters[3] as? Arg4 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg4.self)
                    )
                }
                return try completion(
                    dependencies,
                    parameter1,
                    parameter2,
                    parameter3,
                    parameter4
                )
            }
        )
    }

    public mutating func autoregister<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable
    >(
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1, Arg2, Arg3, Arg4) throws -> Service
    ) {
        register(service) {
            _,
                parameter1,
                parameter2,
                parameter3,
                parameter4 in
            try initializer(parameter1, parameter2, parameter3, parameter4)
        }
    }

    mutating func register<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable
    >(
        _ type: Service.Type,
        completion: @escaping @Sendable (any DependencyInjection.Dependency, Arg1, Arg2, Arg3, Arg4, Arg5) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: {
                dependencies, parameters throws -> Service in
                guard let parameter1 = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                guard let parameter2 = parameters[1] as? Arg2 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg2.self)
                    )
                }
                guard let parameter3 = parameters[2] as? Arg3 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg3.self)
                    )
                }
                guard let parameter4 = parameters[3] as? Arg4 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg4.self)
                    )
                }
                guard let parameter5 = parameters[4] as? Arg5 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg5.self)
                    )
                }
                return try completion(
                    dependencies,
                    parameter1,
                    parameter2,
                    parameter3,
                    parameter4,
                    parameter5
                )
            }
        )
    }

    public mutating func autoregister<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable
    >(
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1, Arg2, Arg3, Arg4, Arg5) throws -> Service
    ) {
        register(service) {
            _,
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5 in
            try initializer(parameter1, parameter2, parameter3, parameter4, parameter5)
        }
    }

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
        completion: @escaping @Sendable (
            any DependencyInjection.Dependency,
            Arg1,
            Arg2,
            Arg3,
            Arg4,
            Arg5,
            Arg6
        ) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: {
                dependencies, parameters throws -> Service in
                guard let parameter1 = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                guard let parameter2 = parameters[1] as? Arg2 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg2.self)
                    )
                }
                guard let parameter3 = parameters[2] as? Arg3 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg3.self)
                    )
                }
                guard let parameter4 = parameters[3] as? Arg4 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg4.self)
                    )
                }
                guard let parameter5 = parameters[4] as? Arg5 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg5.self)
                    )
                }
                guard let parameter6 = parameters[5] as? Arg6 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg6.self)
                    )
                }
                return try completion(
                    dependencies,
                    parameter1,
                    parameter2,
                    parameter3,
                    parameter4,
                    parameter5,
                    parameter6
                )
            }
        )
    }

    public mutating func autoregister<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable
    >(
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) throws -> Service
    ) {
        register(service) {
            _,
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6 in
            try initializer(
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6
            )
        }
    }

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
            any DependencyInjection.Dependency,
            Arg1,
            Arg2,
            Arg3,
            Arg4,
            Arg5,
            Arg6,
            Arg7
        ) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: {
                dependencies, parameters throws -> Service in
                guard let parameter1 = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                guard let parameter2 = parameters[1] as? Arg2 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg2.self)
                    )
                }
                guard let parameter3 = parameters[2] as? Arg3 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg3.self)
                    )
                }
                guard let parameter4 = parameters[3] as? Arg4 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg4.self)
                    )
                }
                guard let parameter5 = parameters[4] as? Arg5 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg5.self)
                    )
                }
                guard let parameter6 = parameters[5] as? Arg6 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg6.self)
                    )
                }
                guard let parameter7 = parameters[6] as? Arg7 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg7.self)
                    )
                }
                return try completion(
                    dependencies,
                    parameter1,
                    parameter2,
                    parameter3,
                    parameter4,
                    parameter5,
                    parameter6,
                    parameter7
                )
            }
        )
    }

    public mutating func autoregister<
        Service: Sendable,
        Arg1: Sendable,
        Arg2: Sendable,
        Arg3: Sendable,
        Arg4: Sendable,
        Arg5: Sendable,
        Arg6: Sendable,
        Arg7: Sendable
    >(
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7) throws -> Service
    ) {
        register(service) {
            _,
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6,
                parameter7 in
            try initializer(
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6,
                parameter7
            )
        }
    }

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
            any DependencyInjection.Dependency,
            Arg1,
            Arg2,
            Arg3,
            Arg4,
            Arg5,
            Arg6,
            Arg7,
            Arg8
        ) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: {
                dependencies, parameters throws -> Service in
                guard let parameter1 = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                guard let parameter2 = parameters[1] as? Arg2 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg2.self)
                    )
                }
                guard let parameter3 = parameters[2] as? Arg3 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg3.self)
                    )
                }
                guard let parameter4 = parameters[3] as? Arg4 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg4.self)
                    )
                }
                guard let parameter5 = parameters[4] as? Arg5 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg5.self)
                    )
                }
                guard let parameter6 = parameters[5] as? Arg6 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg6.self)
                    )
                }
                guard let parameter7 = parameters[6] as? Arg7 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg7.self)
                    )
                }
                guard let parameter8 = parameters[7] as? Arg8 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg8.self)
                    )
                }
                return try completion(
                    dependencies,
                    parameter1,
                    parameter2,
                    parameter3,
                    parameter4,
                    parameter5,
                    parameter6,
                    parameter7,
                    parameter8
                )
            }
        )
    }

    public mutating func autoregister<
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
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8) throws -> Service
    ) {
        register(service) {
            _,
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6,
                parameter7,
                parameter8 in
            try initializer(
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6,
                parameter7,
                parameter8
            )
        }
    }

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
            any DependencyInjection.Dependency,
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
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: {
                dependencies, parameters throws -> Service in
                guard let parameter1 = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                guard let parameter2 = parameters[1] as? Arg2 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg2.self)
                    )
                }
                guard let parameter3 = parameters[2] as? Arg3 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg3.self)
                    )
                }
                guard let parameter4 = parameters[3] as? Arg4 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg4.self)
                    )
                }
                guard let parameter5 = parameters[4] as? Arg5 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg5.self)
                    )
                }
                guard let parameter6 = parameters[5] as? Arg6 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg6.self)
                    )
                }
                guard let parameter7 = parameters[6] as? Arg7 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg7.self)
                    )
                }
                guard let parameter8 = parameters[7] as? Arg8 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg8.self)
                    )
                }
                guard let parameter9 = parameters[8] as? Arg9 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg9.self)
                    )
                }
                return try completion(
                    dependencies,
                    parameter1,
                    parameter2,
                    parameter3,
                    parameter4,
                    parameter5,
                    parameter6,
                    parameter7,
                    parameter8,
                    parameter9
                )
            }
        )
    }

    public mutating func autoregister<
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
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9) throws -> Service
    ) {
        register(service) {
            _,
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6,
                parameter7,
                parameter8,
                parameter9 in
            try initializer(
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6,
                parameter7,
                parameter8,
                parameter9
            )
        }
    }

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
            any DependencyInjection.Dependency,
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
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverFactory.build(
            key: key,
            resolveBlock: {
                dependencies, parameters throws -> Service in
                guard let parameter1 = parameters[0] as? Arg1 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg1.self)
                    )
                }
                guard let parameter2 = parameters[1] as? Arg2 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg2.self)
                    )
                }
                guard let parameter3 = parameters[2] as? Arg3 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg3.self)
                    )
                }
                guard let parameter4 = parameters[3] as? Arg4 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg4.self)
                    )
                }
                guard let parameter5 = parameters[4] as? Arg5 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg5.self)
                    )
                }
                guard let parameter6 = parameters[5] as? Arg6 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg6.self)
                    )
                }
                guard let parameter7 = parameters[6] as? Arg7 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg7.self)
                    )
                }
                guard let parameter8 = parameters[7] as? Arg8 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg8.self)
                    )
                }
                guard let parameter9 = parameters[8] as? Arg9 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg9.self)
                    )
                }
                guard let parameter10 = parameters[9] as? Arg10 else {
                    throw DependencyResolverError.parameterNotResolved(
                        service: String(describing: Service.self),
                        type: String(describing: Arg10.self)
                    )
                }
                return try completion(
                    dependencies,
                    parameter1,
                    parameter2,
                    parameter3,
                    parameter4,
                    parameter5,
                    parameter6,
                    parameter7,
                    parameter8,
                    parameter9,
                    parameter10
                )
            }
        )
    }

    public mutating func autoregister<
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
        _ service: Service.Type,
        initializer: @escaping @Sendable (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10) throws -> Service
    ) {
        register(service) {
            _,
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6,
                parameter7,
                parameter8,
                parameter9,
                parameter10 in
            try initializer(
                parameter1,
                parameter2,
                parameter3,
                parameter4,
                parameter5,
                parameter6,
                parameter7,
                parameter8,
                parameter9,
                parameter10
            )
        }
    }
}

extension DependencyCore: DependencyResolverProperty {
    mutating func resolver<Service: Sendable, Arg1: Sendable>(
        _ type: Service.Type,
        argument: Arg1
    ) throws -> Service {
        try resolver(type, arguments: [argument])
    }

    mutating func resolver<Service: Sendable, Arg1: Sendable, Arg2: Sendable>(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2
    ) throws -> Service {
        try resolver(type, arguments: [arg1, arg2])
    }

    mutating func resolver<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable>(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3
    ) throws -> Service {
        try resolver(type, arguments: [arg1, arg2, arg3])
    }

    mutating func resolver<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable, Arg4: Sendable>(
        _ type: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4
    ) throws -> Service {
        try resolver(
            type,
            arguments: [arg1, arg2, arg3, arg4]
        )
    }

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
    ) throws -> Service {
        try resolver(
            type,
            arguments: [arg1, arg2, arg3, arg4, arg5]
        )
    }

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
    ) throws -> Service {
        try resolver(
            type,
            arguments: [arg1, arg2, arg3, arg4, arg5, arg6]
        )
    }

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
    ) throws -> Service {
        try resolver(
            type,
            arguments: [arg1, arg2, arg3, arg4, arg5, arg6, arg7]
        )
    }

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
    ) throws -> Service {
        try resolver(
            type,
            arguments: [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8]
        )
    }

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
    ) throws -> Service {
        try resolver(
            type,
            arguments: [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]
        )
    }

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
    ) throws -> Service {
        try resolver(
            type,
            arguments: [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10]
        )
    }

    private mutating func resolver<Service: Sendable>(
        _ type: Service.Type,
        arguments: [any Sendable]
    ) throws -> Service {
        let key = DependencyKey(type: type)

        guard var dependency = dependencies[key] else {
            throw DependencyError.notFound(name: key.rawValue)
        }

        dependency.setParameters(contentOf: arguments)

        if !dependency.isSingleton {
            try dependency.resolve(dependencies: self)
        }

        guard let object = try? dependency.value() as? Service else {
            throw DependencyError.notResolved(name: key.rawValue)
        }

        return object
    }
}
