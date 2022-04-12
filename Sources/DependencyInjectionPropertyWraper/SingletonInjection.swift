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

    public init(dependencies: inout DependencySingleton) {
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
public struct SingletonKeyInjection<Service> {
    private var service: Service
    private let key: DependencyKey

    public init(key: DependencyKey, dependencies: inout DependencySingleton) {
        self.key = key
        do {
            self.service = try dependencies.singleton(key)
        } catch {
            fatalError("Can't resolve singleton \(Service.self) using key: \(key.rawValue). Error: \(error.localizedDescription)")
        }
    }

    public var wrappedValue: Service {
        get { service }
        mutating set { service = newValue }
    }

    public var projectedValue: SingletonKeyInjection<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper
public struct CreateInjection<Service: DependencyServiceType> {
    private var service: Service

    public init(dependencies: Dependency) {
        do {
            self.service = try dependencies.create(Service.self)
        } catch {
            fatalError("Can't resolve singleton \(Service.self). Error: \(error.localizedDescription)")
        }
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
