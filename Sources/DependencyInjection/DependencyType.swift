//
//  Dependency.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

public protocol DependencyType {

    func create<T>(completion: (DependencyType) -> T) -> T

    func create<T: DependencyServiceType>(_ type: T.Type) -> T

    @discardableResult
    mutating func register<T>(_ type: T.Type, completion: (DependencyType) -> T) -> T

    @discardableResult
    mutating func register<T: DependencyServiceType>(_ type: T.Type) -> T

    @discardableResult
    mutating func unregister<T>(_ type: T.Type) -> T?

    func resolve<T>(_ type: T.Type) -> T?

    mutating func singleton<T>(completion: (DependencyType) -> T) -> T

    @discardableResult
    mutating func singleton<T: DependencyServiceType>(_ type: T.Type) -> T
}
