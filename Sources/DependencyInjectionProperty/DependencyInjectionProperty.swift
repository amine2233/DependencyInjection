//
//  DependencyInjectionProperty.swift
//
//
//  Created by amine on 10/06/2024.
//

import Foundation
@_spi(Internal) @_exported @testable import DependencyInjection

protocol DependencyRegisterProperty {
    mutating func register<Service, Arg1>(
        _ type: Service.Type,
        completion: @escaping (Dependency, Arg1) throws -> Service
    )
    
    mutating func register<Service, Arg1, Arg2>(
        _ type: Service.Type,
        completion: @escaping (Dependency, Arg1, Arg2) throws -> Service
    )
    
    mutating func register<Service, Arg1, Arg2, Arg3>(
        _ type: Service.Type,
        completion: @escaping (Dependency, Arg1, Arg2, Arg3) throws -> Service
    )
    
    mutating func register<Service, Arg1, Arg2, Arg3, Arg4>(
        _ type: Service.Type,
        completion: @escaping (Dependency, Arg1, Arg2, Arg3, Arg4) throws -> Service
    )
}

extension DependencyCore: DependencyRegisterProperty {
    mutating func register<Service, Arg1>(
        _ type: Service.Type,
        completion: @escaping (any Dependency, Arg1) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverParameters(
            key: key,
            isSingleton: false,
            resolveBlock: { (depdencies, parameters) throws -> Service in
                try completion(depdencies, parameters[0] as! Arg1)
            }
        )
    }
    
    mutating func register<Service, Arg1, Arg2>(
        _ type: Service.Type,
        completion: @escaping (any DependencyInjection.Dependency, Arg1, Arg2) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverParameters(
            key: key,
            isSingleton: false,
            resolveBlock: {
                (depdencies, parameters) throws -> Service in
                try completion(
                    depdencies,
                    parameters[0] as! Arg1,
                    parameters[1] as! Arg2
                )
            }
        )
    }
    
    mutating func register<Service, Arg1, Arg2, Arg3>(
        _ type: Service.Type,
        completion: @escaping (any DependencyInjection.Dependency, Arg1, Arg2, Arg3) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverParameters(
            key: key,
            isSingleton: false,
            resolveBlock: {
                (depdencies, parameters) throws -> Service in
                try completion(
                    depdencies,
                    parameters[0] as! Arg1,
                    parameters[1] as! Arg2,
                    parameters[2] as! Arg3
                )
            }
        )
    }
    
    mutating func register<Service, Arg1, Arg2, Arg3, Arg4>(
        _ type: Service.Type,
        completion: @escaping (any DependencyInjection.Dependency, Arg1, Arg2, Arg3, Arg4) throws -> Service
    ) {
        let key = DependencyKey(type: type)
        dependencies[key] = DependencyResolverParameters(
            key: key,
            isSingleton: false,
            resolveBlock: {
                (depdencies, parameters) throws -> Service in
                try completion(
                    depdencies,
                    parameters[0] as! Arg1,
                    parameters[1] as! Arg2,
                    parameters[2] as! Arg3,
                    parameters[3] as! Arg4
                )
            }
        )
    }
}

protocol DependencyResolverProperty {
    mutating func resolver<Service, Arg1>(
        _ type: Service.Type,
        argument: Arg1
    ) throws -> Service
    
    mutating func resolver<Service, Arg1, Arg2>(
        _ type: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2
    ) throws -> Service
    
    mutating func resolver<Service, Arg1, Arg2, Arg3>(
        _ type: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3
    ) throws -> Service
    
    mutating func resolver<Service, Arg1, Arg2, Arg3, Arg4>(
        _ type: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4
    ) throws -> Service
}

extension DependencyCore: DependencyResolverProperty {
    mutating func resolver<Service, Arg1>(_ type: Service.Type, argument: Arg1) throws -> Service {
        try resolver(type, arguments: [argument])
    }
    
    mutating func resolver<Service, Arg1, Arg2>(_ type: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) throws -> Service {
        try resolver(type, arguments: [arg1, arg2])
    }
    
    mutating func resolver<Service, Arg1, Arg2, Arg3>(_ type: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) throws -> Service {
        try resolver(type, arguments: [arg1, arg2, arg3])
    }
    
    mutating func resolver<Service, Arg1, Arg2, Arg3, Arg4>(_ type: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) throws -> Service {
        try resolver(type, arguments: [arg1, arg2, arg3, arg4])
    }
    
    private mutating func resolver<Service>(_ type: Service.Type, arguments: [Any]) throws -> Service {
        let key = DependencyKey(type: type)

        guard var dependency = dependencies[key] as? DependencyResolverParameters else {
            throw DependencyError.notFound(name: key.rawValue)
        }
        
        dependency.setParameters(arguments)

        if !dependency.isSingleton {
            try dependency.resolve(dependencies: self)
        }

        guard let object = dependency.value as? Service else {
            throw DependencyError.notResolved(name: key.rawValue)
        }

        return object
    }
}
