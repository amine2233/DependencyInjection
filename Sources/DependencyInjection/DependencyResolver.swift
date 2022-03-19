import Foundation

public struct DependencyResolver {
    public typealias ResolveBlock<T> = (Dependency) -> T

    internal let name: String

    public private(set) var value: Any!

    private let resolveBlock: ResolveBlock<Any>

    public init<T>(_ block: @escaping ResolveBlock<T>) {
        resolveBlock = block // Save block for future
        name = String(describing: T.self)
    }

    public mutating func resolve(dependencies: Dependency) {
        value = resolveBlock(dependencies)
    }
}
