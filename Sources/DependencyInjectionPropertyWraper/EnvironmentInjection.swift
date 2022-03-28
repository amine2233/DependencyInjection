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
    private var environment: DependencyEnvironement

    public init(environment: DependencyEnvironement) {
        self.environment = environment
    }

    public var wrappedValue: DependencyEnvironement {
        get { return environment }
        mutating set { environment = newValue }
    }

    public var projectedValue: EnvironmentInjection {
        get { return self }
        mutating set { self = newValue }
    }
}
