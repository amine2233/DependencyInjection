//
//  DependencyServiceError.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

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
        case let .notFound(name): return "Not found the dependency with name: \(name) in ."
        case let .notFoundSingleton(name): return "Not found singleton with name: \(name)."
        case let .notResolved(name): return "Not reolved the dependency with name: \(name)."
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case let .notFound(name): return "Verify the dependency with name: \(name), is registred or is configured correctly."
        case let .notFoundSingleton(name): return "Verify the singleton with name: \(name), is registred or is configured correctly."
        case let .notResolved(name): return "Not resolve the dependency with the name: \(name),\nOr can't use the `dependency.value`."
        }
    }

    public var helpAnchor: String? {
        switch self {
        case let .notFound(name): return "* Register the dependency with name: \(name).\n * Verify if setup service is used."
        case let .notFoundSingleton(name): return "* Register the singleton with name: \(name)."
        case let .notResolved(name): return "Register the dependency with name: \(name).\n* Verify if setup service is used.\n* The value inisde `dependency.value` maybe can't casted to rhe right \(name)."
        }

    }
}
