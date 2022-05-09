//
//  File.swift
//  
//
//  Created by Amine Bensalah on 28/03/2022.
//

import Foundation
import DependencyInjection

@propertyWrapper
public struct EnvironmentInjection {
    private var dependencies: Dependency

    public init(dependencies: Dependency) {
        self.dependencies = dependencies
    }

    public var wrappedValue: DependencyEnvironement {
        get { return dependencies.environment }
        mutating set { dependencies.environment = newValue }
    }

    public var projectedValue: EnvironmentInjection {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper
public struct EnvironmentParameter<T> {
    private let key: DependencyEnvironementKey
    private var environment: DependencyEnvironement

    public init(key: DependencyEnvironementKey, dependencies: Dependency) {
        self.key = key
        self.environment = dependencies.environment
    }

    public init(key: DependencyEnvironementKey, environment: DependencyEnvironement) {
        self.key = key
        self.environment = environment
    }

    public var wrappedValue: T? {
        get { return try? environment.getParameter(key: key) }
        mutating set { environment.setParameter(key: key, value: newValue) }
    }

    public var projectedValue: EnvironmentParameter {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper
public struct EnvironmentStringOption {
    private let key: DependencyEnvironementKey
    private var environment: DependencyEnvironement

    public init(key: DependencyEnvironementKey, dependencies: Dependency) {
        self.key = key
        self.environment = dependencies.environment
    }

    public init(key: DependencyEnvironementKey, environment: DependencyEnvironement) {
        self.key = key
        self.environment = environment
    }

    public var wrappedValue: String? {
        get { return try? environment.getStringOption(key: key) }
        mutating set { environment.setStringOption(key: key, value: newValue) }
    }

    public var projectedValue: EnvironmentStringOption {
        get { return self }
        mutating set { self = newValue }
    }
}
