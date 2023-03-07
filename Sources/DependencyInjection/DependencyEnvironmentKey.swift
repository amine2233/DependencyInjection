import Foundation

public struct DependencyEnvironmentKey: RawRepresentable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DependencyEnvironmentKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = value
    }
}
