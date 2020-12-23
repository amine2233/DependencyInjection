//
//  Dependency.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

public enum DependencyError: Error, Equatable {
    case notFound(name: String)
}

public protocol DependencyType: CustomStringConvertible {
    // MARK: Description
    var description: String { get }
    var dependenciesCount: Int { get }
    var providersCount: Int { get }

    // MARK: Creation
    func create<T>(completion: (DependencyType) -> T) -> T

    func create<T: DependencyServiceType>(_ type: T.Type) -> T

    mutating func create(_ dependency: Dependency) -> Any

    // MARK: Registration
    @discardableResult
    mutating func register<T>(_ type: T.Type, completion: (DependencyType) -> T) -> T

    @discardableResult
    mutating func register<T: DependencyServiceType>(_ type: T.Type) -> T

    @discardableResult
    mutating func register(_ dependency: Dependency) -> Any

    // MARK: Registration with name
    @discardableResult
    mutating func register<T>(withName name: String, completion: (DependencyType) -> T) -> T

    // MARK: Unregister
    @discardableResult
    mutating func unregister<T>(_ type: T.Type) throws -> T

    mutating func unregister(withName name: String)

    // MARK: Resolver
    func resolve<T>(_ type: T.Type) throws -> T

    func resolve<T>() throws -> T

    func resolve<T>(withName name: String) throws -> T

    func resolve<T>(withName name: String, type: T.Type) throws -> T

    // MARK: Singleton
    mutating func singleton<T>(completion: (DependencyType) -> T) -> T

    @discardableResult
    mutating func singleton<T: DependencyServiceType>(_ type: T.Type) -> T

    @discardableResult
    mutating func singleton(_ dependency: Dependency) -> Any

    // MARK: Provider
    mutating func register(_ provider: Provider)

    mutating func unregister<T: DependencyProvider>(_ type: T.Type)

    // MARK: Startup and Endup provider configuration
    func willBoot() -> Self
    func willShutdown() -> Self
    func didEnterBackground() -> Self
    func didBoot() -> Self
}
