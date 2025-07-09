import Foundation

/// An enumeration representing errors that can occur with a dependency service.
public enum DependencyServiceError: Error {
    /// Error indicating the service is not registered.
    case unregistered
}

/// An enumeration representing errors that can occur during dependency resolution.
public enum DependencyError: Error, Equatable {
    /// Error indicating that a singleton dependency could not be found.
    ///
    /// - Parameter name: The name of the missing singleton dependency.
    case notFoundSingleton(name: String)

    /// Error indicating that a dependency could not be found.
    ///
    /// - Parameter name: The name of the missing dependency.
    case notFound(name: String)

    /// Error indicating that a dependency could not be resolved.
    ///
    /// - Parameter name: The name of the unresolved dependency.
    case notResolved(name: String)

    case cyclicDependency([[DependencyKey]])
}

/// Extension to provide localized error descriptions for DependencyError.
extension DependencyError: LocalizedError {
    /// Provides a localized description of the failure reason.
    ///
    /// - Returns: A string describing the failure reason.
    public var failureReason: String? {
        switch self {
        case let .notFoundSingleton(name):
            "Singleton dependency not found: \(name)"
        case let .notFound(name):
            "Dependency not found: \(name)"
        case let .notResolved(name):
            "Dependency not resolved: \(name)"
        case let .cyclicDependency(keys):
            "Cyclic dependency detected: \(keys)"
        }
    }
}
