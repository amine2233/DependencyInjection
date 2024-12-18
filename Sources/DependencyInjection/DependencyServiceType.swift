import Foundation

/// A protocol defining a type that can create a service instance from a dependency container.
public protocol DependencyServiceType {
    /// Creates an instance of the service for the given dependency container.
    ///
    /// - Parameter container: The dependency container from which to resolve dependencies.
    /// - Returns: An instance of the service type.
    /// - Throws: An error if the service could not be created.
    static func makeService(for container: any Dependency) throws -> Self
}
