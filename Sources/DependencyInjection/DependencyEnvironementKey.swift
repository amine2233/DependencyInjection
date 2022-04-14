//
//  File.swift
//  
//
//  Created by Amine Bensalah on 12/04/2022.
//

import Foundation

public struct DependencyEnvironementKey: RawRepresentable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DependencyEnvironementKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = value
    }
}

protocol DependencyEnvironementValueKey {

    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value

    /// The default value for the dependency injection key.
    static var currentValue: Self.Value { get set }
}

/// Provides access to injected dependencies.
struct DependencyEnvironementValues {

    /// This is only used as an accessor to the computed properties within extensions of `DependencyEnvironementValues`.
    private static var current = DependencyEnvironementValues()

    /// A static subscript for updating the `currentValue` of `DependencyEnvironementValueKey` instances.
    static subscript<K>(key: K.Type) -> K.Value where K : DependencyEnvironementValueKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }

    /// A static subscript accessor for updating and references dependencies directly.
    static subscript<T>(_ keyPath: WritableKeyPath<DependencyEnvironementValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}
