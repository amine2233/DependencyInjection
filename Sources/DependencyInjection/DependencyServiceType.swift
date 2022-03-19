//
//  DependencyServiceType.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

public protocol DependencyServiceType {
    static func makeService(for container: Dependency) -> Self
}
