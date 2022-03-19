//
//  InjectObject.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 29/09/2021.
//

import Foundation

#if canImport(SwifUI)

@propertyWrapper
public struct ObjectInjection<Service>: DynamicProperty where Service: ObservableObject {
    @ObservedObject private var service: Service
    
    public init(dependencies: DependencyResolver = DependencyInjector.dependencies) {
        self.service = dependencies.resolve(Value.self)
    }
    
    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    
    public var projectedValue: ObjectInjection<Service>.Wrapper {
        return self.$service
    }
}

#endif
