import Foundation

/// The dependency type
public struct DependencyTypeKey: Hashable, Sendable, CustomStringConvertible {
    let type: String
    let key: DependencyKey?
    
    /// The description
    public var description: String {
        var _name = type
        if let key {
            _name += "-(\(key.rawValue))"
        }
        return _name
    }

    /// The initializer
    /// - Parameters:
    ///   - type: The `T.Type` type
    ///   - key: The `DependencyKey` value
    public init<T>(type: T.Type, key: DependencyKey? = nil) {
        self.type = String(describing: type.self)
        self.key = key
    }
    
    /// The initializer
    /// - Parameters:
    ///   - type: The `String` type
    ///   - key: The `DependencyKey` value
    public init(type: String, key: DependencyKey? = nil) {
        self.type = type
        self.key = key
    }
}

extension DependencyTypeKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(type: value)
    }
}
