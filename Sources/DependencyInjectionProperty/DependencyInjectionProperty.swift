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
