import Foundation

public enum DependencyServiceError: Error {
    case unregistred
}

public enum DependencyError: Error, Equatable {
    case notFoundSingleton(name: String)
    case notFound(name: String)
    case notResolved(name: String)
}

extension DependencyError: LocalizedError {
    public var failureReason: String? {
        switch self {
        case .notFoundSingleton(let name):
            return "not found singleton \(name)"
        case .notFound(let name):
            return "not found \(name)"
        case .notResolved(let name):
            return "not resolved \(name)"
        }
    }
}
