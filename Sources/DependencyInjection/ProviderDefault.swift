import Foundation

public struct ProviderDefault: Provider {

    public typealias ResolveBlock<T> = (DependencyProvider) -> T
    public private(set) var value: Any!

    public var description: String
    private let resolveBlock: ResolveBlock<Any>

    public init<T: Provider>(_ block: @escaping ResolveBlock<T>) {
        resolveBlock = block // Save block for future
        description = String(describing: T.self)
    }

    public mutating func resolve(dependencies: DependencyProvider) {
        value = resolveBlock(dependencies)
    }

    public func willBoot(_ container: DependencyProvider) {
        (value as? Provider)?.willBoot(container)
    }

    public func didBoot(_ container: DependencyProvider) {
        (value as? Provider)?.didBoot(container)
    }

    public func didEnterBackground(_ container: DependencyProvider) {
        (value as? Provider)?.didEnterBackground(container)
    }

    public func willShutdown(_ container: DependencyProvider) {
        (value as? Provider)?.willShutdown(container)
    }
}
