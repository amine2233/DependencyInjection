import Foundation

public protocol DependencyServiceType {
    static func makeService(for container: Dependency) throws -> Self
}
