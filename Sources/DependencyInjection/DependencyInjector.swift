//
//  DependencyInjector.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

/// The singleton dependency container reference
/// which can be reassigned to another container
public struct DependencyInjector {
    public static var dependencies: CoreDependency = CoreDependency()
}

/// Attach to any type for exposing the dependency container
public protocol HasDependencies {
    var dependencies: CoreDependency { get }
}

extension HasDependencies {
    /// Container for dependency instance factories
    public var dependencies: CoreDependency {
        return DependencyInjector.dependencies
    }
}
