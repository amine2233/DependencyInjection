//
//  File.swift
//  
//
//  Created by Amine Bensalah on 29/03/2022.
//

import Foundation

public struct DependencyKey: RawRepresentable, Hashable, Equatable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DependencyKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = value
    }
}

extension DependencyKey: CustomStringConvertible {
    public var description: String { rawValue }
}

extension DependencyKey {
    public init<T>(describing type: T.Type) {
        rawValue = String(describing: type)
    }
}
