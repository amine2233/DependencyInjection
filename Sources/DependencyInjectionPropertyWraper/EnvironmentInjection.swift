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
    private var environment: DependencyEnvironment

    public init(environment: DependencyEnvironment) {
        self.environment = environment
    }

    public var wrappedValue: DependencyEnvironment {
        get { return environment }
        mutating set { environment = newValue }
    }

    public var projectedValue: EnvironmentInjection {
        get { return self }
        mutating set { self = newValue }
    }
}


@propertyWrapper
public struct EnvironmentInjectionOption<T: LosslessStringConvertible> {
    private var environment: DependencyEnvironment
    private var key: DependencyEnvironementOptionKey

    public init(key: DependencyEnvironementOptionKey, environment: DependencyEnvironment) {
        self.key = key
        self.environment = environment
    }

    public var wrappedValue: T? {
        get { return environment.getOption(key: key) }
        mutating set { environment.setOption(key: key, value: newValue) }
    }

    public var projectedValue: EnvironmentInjectionOption {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper
public struct EnvironmentInjectionProcess {
    private var environment: DependencyEnvironment
    private var key: DependencyEnvironementProcessKey

    public init(key: DependencyEnvironementProcessKey, environment: DependencyEnvironment) {
        self.key = key
        self.environment = environment
    }

    public var wrappedValue: String? {
        environment.get(key)
    }

    public var projectedValue: EnvironmentInjectionProcess {
        get { return self }
        mutating set { self = newValue }
    }
}
