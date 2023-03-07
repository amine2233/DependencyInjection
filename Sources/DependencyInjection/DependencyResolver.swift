import Foundation

public struct DependencyResolver {
    public typealias ResolveBlock<T> = (Dependency) throws -> T

    public private(set) var value: Any!

    internal let key: DependencyKey

    private let resolveBlock: ResolveBlock<Any>

    let isSingleton: Bool

    public init<T>(isSingleton: Bool = false, resolveBlock: @escaping ResolveBlock<T>) {
        self.init(key: DependencyKey(type: T.self), isSingleton: isSingleton, resolveBlock: resolveBlock)
    }

    internal init<T>(key: DependencyKey, isSingleton: Bool, resolveBlock: @escaping ResolveBlock<T>) {
        self.key = key
        self.isSingleton = isSingleton
        self.resolveBlock = resolveBlock // Save block for future
    }

    public mutating func resolve(dependencies: Dependency) throws {
        value = try resolveBlock(dependencies)
    }
}
