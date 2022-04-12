import Foundation

public struct DependencyResolver {
    public typealias ResolveBlock<T> = (Dependency) throws -> T

    public private(set) var value: Any!

    internal let key: DependencyKey

    private let resolveBlock: ResolveBlock<Any>

    public init<T>(resolveBlock: @escaping ResolveBlock<T>) {
        self.init(key: DependencyKey(type: T.self), resolveBlock: resolveBlock)
    }

    internal init<T>(key: DependencyKey, resolveBlock: @escaping ResolveBlock<T>) {
        self.resolveBlock = resolveBlock // Save block for future
        self.key = key
    }

    public mutating func resolve(dependencies: Dependency) throws {
        value = try resolveBlock(dependencies)
    }
}

public struct DependencySingletonResolver {
    public typealias ResolveBlock<T> = (Dependency) throws -> T

    public private(set) var value: Any!

    internal let key: DependencyKey

    private let resolveBlock: ResolveBlock<Any>

    public init<T>(resolveBlock: @escaping ResolveBlock<T>) {
        self.init(key: DependencyKey(type: T.self), resolveBlock: resolveBlock)
    }

    internal init<T>(key: DependencyKey, resolveBlock: @escaping ResolveBlock<T>) {
        self.resolveBlock = resolveBlock // Save block for future
        self.key = key
    }

    public mutating func resolve(dependencies: Dependency) throws {
        guard value == nil else { return }
        value = try resolveBlock(dependencies)
    }
}
