import Foundation

/// A struct representing a key used to access dependencies stored in an environment.
public struct DependencyEnvironmentKey: RawRepresentable, Hashable {
    /// The raw string value of the key.
    public let rawValue: String

    /// Initializes a new `DependencyEnvironmentKey` with the given raw value.
    ///
    /// - Parameter rawValue: The raw string value of the key.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DependencyEnvironmentKey: ExpressibleByStringLiteral {
    /// Initializes a new `DependencyEnvironmentKey` with the given string literal.
    ///
    /// - Parameter value: The string literal value of the key.
    public init(stringLiteral value: String) {
        rawValue = value
    }
}
