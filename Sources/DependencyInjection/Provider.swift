import Foundation

public protocol Provider: CustomStringConvertible {
    // MARK: Description
    var description: String { get }

    // MARK: Methods
    func willBoot(_ container: DependencyProvider)

    func didBoot(_ container: DependencyProvider)

    func didEnterBackground(_ container: DependencyProvider)

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
