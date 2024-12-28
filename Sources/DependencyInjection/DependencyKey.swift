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
