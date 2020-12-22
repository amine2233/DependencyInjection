import Foundation

public struct Provider: DependencyProvider {

    public typealias ResolveBlock<T> = (DependencyType) -> T
    public private(set) var value: Any!

    public var description: String
    private let resolveBlock: ResolveBlock<Any>

    public init<T: DependencyProvider>(_ block: @escaping ResolveBlock<T>) {
        resolveBlock = block // Save block for future
        description = String(describing: T.self)
    }

    public mutating func resolve(dependencies: DependencyType) {
        value = resolveBlock(dependencies)
    }


    public func willBoot(_ container: DependencyType) {
        (value as? DependencyProvider)?.willBoot(container)
    }

    public func didBoot(_ container: DependencyType) {
        (value as? DependencyProvider)?.didBoot(container)
    }

    public func didEnterBackground(_ container: DependencyType) {
        (value as? DependencyProvider)?.didEnterBackground(container)
    }

    public func willShutdown(_ container: DependencyType) {
        (value as? DependencyProvider)?.willShutdown(container)
    }
}
