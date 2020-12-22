import Foundation

public protocol DependencyProvider: CustomStringConvertible {
    // MARK: Description
    var description: String { get }

    // MARK: Methods
    func willBoot(_ container: DependencyType)

    func didBoot(_ container: DependencyType)

    func didEnterBackground(_ container: DependencyType)

    func willShutdown(_ container: DependencyType)
}

extension DependencyProvider {
    var description: String {
        return String(describing: Self.self)
    }

    func willBoot(_ container: DependencyType) {}

    func didBoot(_ container: DependencyType) {}

    func didEnterBackground(_ container: DependencyType) {}

    func willShutdown(_ container: DependencyType) {}
}
