import Foundation

/// A default implementation of a provider that conforms to the `Provider` protocol.
/// It manages the resolution and lifecycle of dependencies.
public struct ProviderDefault: Provider {
    // MARK: Typealiases

    /// A closure type that resolves a dependency from a `DependencyProvider`.
    public typealias ResolveBlock<T: Sendable> = @Sendable (any DependencyProvider) -> T

    // MARK: Properties

    /// The resolved value of the provider.
    public private(set) var value: (any Sendable)!

    /// A description of the provider.
    public var description: String

    /// A closure used to resolve the dependency.
    private let resolveBlock: ResolveBlock<any Sendable>

    // MARK: Initializer

    /// Initializes a new provider with a resolution block.
    ///
    /// - Parameter block: A closure that resolves the dependency from the `DependencyProvider`.
    public init<T: Provider>(_ block: @escaping @Sendable ResolveBlock<T>) {
        self.resolveBlock = block // Save block for future
        self.description = String(describing: T.self)
    }

    // MARK: Methods

    /// Resolves the dependency using the provided `DependencyProvider`.
    ///
    /// - Parameter dependencies: The `DependencyProvider` used to resolve the dependency.
    public mutating func resolve(dependencies: any DependencyProvider) {
        value = resolveBlock(dependencies)
    }

    /// Called before the provider is booted.
    ///
    /// - Parameter container: The dependency provider container.
    public func willBoot(_ container: any DependencyProvider) {
        (value as? (any Provider))?.willBoot(container)
    }

    /// Called after the provider has booted.
    ///
    /// - Parameter container: The dependency provider container.
    public func didBoot(_ container: any DependencyProvider) {
        (value as? (any Provider))?.didBoot(container)
    }

    /// Called when the provider enters the background.
    ///
    /// - Parameter container: The dependency provider container.
    public func didEnterBackground(_ container: any DependencyProvider) {
        (value as? (any Provider))?.didEnterBackground(container)
    }

    /// Called before the provider is shut down.
    ///
    /// - Parameter container: The dependency provider container.
    public func willShutdown(_ container: any DependencyProvider) {
        (value as? (any Provider))?.willShutdown(container)
    }
}
