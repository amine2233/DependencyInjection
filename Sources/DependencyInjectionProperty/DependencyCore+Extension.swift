import Foundation
@_spi(Internal) @_exported @testable import DependencyInjection

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
        try resolver(type, arguments: [arg1, arg2, arg3, arg4])
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
