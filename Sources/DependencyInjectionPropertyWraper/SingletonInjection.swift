//
//  Singleton.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 29/09/2021.
//

import Foundation
import DependencyInjection

@propertyWrapper
public struct SingletonInjection<Service> {
    private var service: Service

    public init(dependencies: DependencySingleton) {
        do {
            self.service = try dependencies.singleton()
        } catch {
            fatalError("Can't resolve singleton \(Service.self). Error: \(error.localizedDescription)")
        }
    }

    public var wrappedValue: Service {
        get { service }
        mutating set { service = newValue }
    }
    
    public var projectedValue: SingletonInjection<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper
public struct CreateInjection<Service: DependencyServiceType> {
    private var service: Service

    public init(dependencies: Dependency) {
        self.service = dependencies.create(Service.self)
    }

    public var wrappedValue: Service {
        get { service }
        mutating set { service = newValue }
    }

    public var projectedValue: CreateInjection<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}
