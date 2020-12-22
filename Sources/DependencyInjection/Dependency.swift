import Foundation

public struct Dependency {
    public typealias ResolveBlock<T> = (DependencyType) -> T

    public private(set) var value: Any!

    let name: String

    private let resolveBlock: ResolveBlock<Any>

    public init<T>(_ block: @escaping ResolveBlock<T>) {
        resolveBlock = block // Save block for future
        name = String(describing: T.self)
    }

    public mutating func resolve(dependencies: DependencyType) {
        value = resolveBlock(dependencies)
    }
}
