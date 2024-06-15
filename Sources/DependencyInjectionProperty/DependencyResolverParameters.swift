//
//  File.swift
//  
//
//  Created by amine on 15/06/2024.
//

import Foundation
import DependencyInjection

/// A struct responsible for resolving dependencies.
struct DependencyResolverParameters: DependencyResolver  {
    /// A typealias representing a closure that resolves a dependency.
    /// - Parameter Dependency: The dependency container.
    /// - Returns: The resolved dependency of type `T`.
    typealias ResolveBlock<T> = (Dependency, [Any]) throws -> T

    /// The resolved dependency value.
    private(set) var value: Any!

    /// The key used to identify the dependency.
    let key: DependencyKey

    /// The closure that resolves the dependency.
    private let resolveBlock: ResolveBlock<Any>

    /// A flag indicating whether the dependency is a singleton.
    let isSingleton: Bool
    
    private var isSetParameters: Bool = false
    
    private var parameters: [Any]

    /// Initializes a new `DependencyResolver`.
    ///
    /// - Parameters:
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton. Default is `false`.
    ///   - resolveBlock: The closure that resolves the dependency.
    init<T>(
        isSingleton: Bool = false,
        parameters: [Any] = [],
        resolveBlock: @escaping ResolveBlock<T>
    ) {
        self.init(
            key: DependencyKey(type: T.self),
            isSingleton: isSingleton,
            parameters: parameters,
            resolveBlock: resolveBlock
        )
    }

    /// Initializes a new `DependencyResolver` with a specific key.
    ///
    /// - Parameters:
    ///   - key: The key used to identify the dependency.
    ///   - isSingleton: A Boolean value indicating whether the dependency is a singleton.
    ///   - resolveBlock: The closure that resolves the dependency.
    init<T>(key: DependencyKey, isSingleton: Bool, parameters: [Any] = [], resolveBlock: @escaping ResolveBlock<T>) {
        self.key = key
        self.isSingleton = isSingleton
        self.resolveBlock = resolveBlock
        self.parameters = parameters
    }
    
    mutating func setParameters(_ new: [Any]) {
        parameters = new
        isSetParameters = true
    }

    /// Resolves the dependency and assigns it to `value`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Throws: An error if the dependency cannot be resolved.
    mutating func resolve(dependencies: Dependency) throws {
        precondition(isSetParameters)
        value = try resolveBlock(dependencies, parameters)
    }
    
    /// Resolves the dependency and returns the updated `DependencyResolver`.
    ///
    /// - Parameter dependencies: The dependency container.
    /// - Returns: The updated `DependencyResolver`.
    /// - Throws: An error if the dependency cannot be resolved.
    mutating func resolveDependency(dependencies: Dependency) throws -> DependencyResolver {
        value = try resolveBlock(dependencies, parameters)
        return self
    }
}
