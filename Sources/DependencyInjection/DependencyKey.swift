import Foundation

/// A struct representing a key used to identify a dependency.
public struct DependencyKey: RawRepresentable, Hashable, Sendable {
    /// The raw string value of the key.
    public let rawValue: String

    /// Initializes a new `DependencyKey` with the given raw value.
    ///
    /// - Parameter rawValue: The raw string value of the key.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DependencyKey: ExpressibleByStringLiteral {
    /// Initializes a new `DependencyKey` with the given string literal.
    ///
    /// - Parameter value: The string literal value of the key.
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension DependencyKey: CustomStringConvertible {
    /// A textual representation of the `DependencyKey`.
    public var description: String { rawValue }
}

extension DependencyKey {
    /// Initializes a new `DependencyKey` based on the type of a dependency.
    ///
    /// - Parameter type: The type of the dependency.
    public init<T>(type: T.Type) {
        self.rawValue = String(describing: type.self)
    }
}

public struct DependencyTypeKey: Hashable, Sendable, CustomStringConvertible {
    let type: String
    let key: DependencyKey?
    
    public var description: String {
        var _name = type
        if let key {
            _name += "-(\(key.rawValue))"
        }
        return _name
    }
    
    public init<T>(type: T.Type, key: DependencyKey? = nil) {
        self.type = String(describing: type.self)
        self.key = key
    }
    
    public init(type: String, key: DependencyKey? = nil) {
        self.type = type
        self.key = key
    }
    
    public init(key: DependencyKey) {
        self.type = key.rawValue
        self.key = nil
    }
}

extension DependencyTypeKey {
    public func asDependencyKey() -> DependencyKey {
        DependencyKey(rawValue: type)
    }
}
