import Foundation

public struct DependencyResolver {
    public typealias ResolveBlock<T> = (Dependency) -> T

    internal let key: DependencyKey

    public private(set) var value: Any!

    private let resolveBlock: ResolveBlock<Any>

    public init<T>(_ block: @escaping ResolveBlock<T>) {
        self.init(key: DependencyKey(describing: T.self), block: block)
    }

    internal init<T>(key: DependencyKey, block: @escaping ResolveBlock<T>) {
        self.key = key
        resolveBlock = block // Save block for future
    }

    public mutating func resolve(dependencies: Dependency) {
        value = resolveBlock(dependencies)
    }
}
