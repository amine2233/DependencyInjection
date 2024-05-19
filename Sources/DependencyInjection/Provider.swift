import Foundation

/// Protocol defining lifecycle methods for a service.
public protocol Provider: CustomStringConvertible {
    // MARK: Description
    
    /// A string description of the service.
    var description: String { get }
    
    // MARK: Methods
    
    /// Called before the service is booted.
    ///
    /// - Parameter container: The dependency provider container.
    func willBoot(_ container: DependencyProvider)
    
    /// Called after the service has booted.
    ///
    /// - Parameter container: The dependency provider container.
    func didBoot(_ container: DependencyProvider)
    
    /// Called when the service enters the background.
    ///
    /// - Parameter container: The dependency provider container.
    func didEnterBackground(_ container: DependencyProvider)
    
    /// Called before the service is shut down.
    ///
    /// - Parameter container: The dependency provider container.
    func willShutdown(_ container: DependencyProvider)
}

extension Provider {
    var description: String {
        return String(describing: Self.self)
    }

    func willBoot(_ container: DependencyProvider) {}

    func didBoot(_ container: DependencyProvider) {}

    func didEnterBackground(_ container: DependencyProvider) {}

    func willShutdown(_ container: DependencyProvider) {}
}
