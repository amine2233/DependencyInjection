//
//  DependencyInjector.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

/// The singleton dependency container reference
/// which can be reassigned to another container
public struct DependencyInjector: HasDependencies {
    public var dependencies: DependencyType

    @_functionBuilder struct DependencyBuilder {
        static func buildBlock(_ dependency: Dependency) -> Dependency { dependency }
        static func buildBlock(_ dependencies: Dependency...) -> [Dependency] { dependencies }
    }

    @_functionBuilder struct ProviderBuilder {
        static func buildBlock(_ dependency: Provider) -> Provider { dependency }
        static func buildBlock(_ dependencies: Provider...) -> [Provider] { dependencies }
    }

    public init(dependencies: DependencyType = DependencyInjection()) {
        self.dependencies = dependencies
    }

    public init(dependencies: DependencyType = DependencyInjection(),
        @DependencyBuilder _ block: () -> [Dependency] = { [] },
        @ProviderBuilder _ providers: () -> [Provider] = { [] }) {
        self.init(dependencies: dependencies)
        block().forEach { self.dependencies.register($0) }
        providers().forEach { self.dependencies.register($0) }
    }

    init(dependencies: DependencyType = DependencyInjection(),
        @DependencyBuilder _ dependency:  () -> Dependency,
        @ProviderBuilder _ provider:  () -> Provider) {
        self.init(dependencies: dependencies)
        self.dependencies.register(dependency())
        self.dependencies.register(provider())
    }
}

/// Attach to any type for exposing the dependency container
public protocol HasDependencies {
    var dependencies: DependencyType { get }
}

//extension HasDependencies {
//    /// Container for dependency instance factories
//    public var dependencies: DependencyType {
//        return DependencyInjector.di
//    }
//}
