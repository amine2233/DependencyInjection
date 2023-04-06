import Foundation

public struct DependencyResolver {
    public typealias ResolveBlock<T> = (Dependency, Any...) throws -> T

    private var value: Any!

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

    public mutating func resolve(dependencies: Dependency, arguments: Any...) throws -> Any {
        if isSingleton {
            if let value = value {
                return value
            } else {
                value = try resolveBlock(dependencies, arguments)
                return value!
            }
        } else {
            return try resolveBlock(dependencies, arguments)
        }
    }
}
