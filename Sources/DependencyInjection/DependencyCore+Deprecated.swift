//
//  DependencyCore+Deprecated.swift
//  
//
//  Created by amine on 07/03/2023.
//

import Foundation

// MARK: - Create methods

extension DependencyCore {
    /// Create a unique object, this method not register class
    /// - Parameter completion: the completion to create a new object
    /// - Returns: the new object
    @available(*, deprecated, renamed: "factory")
    public func create<T>(completion: (Dependency) throws -> T) throws -> T {
        try completion(self)
    }

    /// Create a new object conform to protocol ```DependencyServiceType```, this method not register class
    /// - Parameter _: The object you will create
    /// - Returns: The new object
    @available(*, deprecated, renamed: "factory")
    public func create<T>(_ type: T.Type) throws -> T where T: DependencyServiceType {
        try type.makeService(for: self)
    }

    /// Create a new object, this method not register object
    /// - Parameter dependency: The dependency object
    /// - Returns: the new object
    @available(*, deprecated, renamed: "factory")
    public mutating func create(_ dependency: DependencyResolver) throws -> Any {
        try dependency.resolve(dependencies: self)

        guard let value = dependency.value else {
            throw DependencyError.notResolved(name: dependency.key.rawValue)
        }
        return value
    }
}
