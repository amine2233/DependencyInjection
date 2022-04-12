//
//  File.swift
//  
//
//  Created by Amine Bensalah on 12/04/2022.
//

import Foundation

public struct DependencyEnvironementKey: RawRepresentable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DependencyEnvironementKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = value
    }
}
