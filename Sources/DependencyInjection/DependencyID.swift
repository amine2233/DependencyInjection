//
//  File.swift
//  
//
//  Created by Amine Bensalah on 19/03/2022.
//

import Foundation

protocol DependencyIdentifier {
    static var dependencyIdentifier: String { get }
}

extension DependencyIdentifier {
    public static var dependencyIdentifier: String {
        return String(describing: self)
    }
}

struct DependencyID: Hashable, Equatable, CustomStringConvertible, DependencyIdentifier {

    static func == (lhs: DependencyID, rhs: DependencyID) -> Bool {
        return lhs.type == rhs.type
    }

    /// See `Hashable`.
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

    var description: String {
        return "\(type)"
    }

    let type: Any.Type

    init(_ type: Any.Type) {
        self.type = type
    }
}
