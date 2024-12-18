import Foundation

/// Protocol defining lifecycle methods for a service.
public protocol Provider: CustomStringConvertible, Sendable {
    // MARK: Description

    /// A string description of the service.
    var description: String { get }

    // MARK: Methods

    /// Called before the service is booted.
    ///
    /// - Parameter container: The dependency provider container.
    func willBoot(_ container: any DependencyProvider)

    /// Called after the service has booted.
    ///
    /// - Parameter container: The dependency provider container.
    func didBoot(_ container: any DependencyProvider)

    /// Called when the service enters the background.
    ///
    /// - Parameter container: The dependency provider container.
    func didEnterBackground(_ container: any DependencyProvider)

    /// Called before the service is shut down.
    ///
    /// - Parameter container: The dependency provider container.
    func willShutdown(_ container: any DependencyProvider)
}

extension Provider {
    var description: String {
        String(describing: Self.self)
    }

    func willBoot(_ container: any DependencyProvider) {}

    func didBoot(_ container: any DependencyProvider) {}

    func didEnterBackground(_ container: any DependencyProvider) {}

    func willShutdown(_ container: any DependencyProvider) {}
}
