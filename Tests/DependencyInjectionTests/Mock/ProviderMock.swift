import Foundation
import DependencyInjection

final class ProviderMock: Provider, @unchecked Sendable {
    var invokedDescriptionGetter = false
    var invokedDescriptionGetterCount = 0
    var stubbedDescription: String! = ""

    var description: String {
        invokedDescriptionGetter = true
        invokedDescriptionGetterCount += 1
        return stubbedDescription
    }

    var invokedWillBoot = false
    var invokedWillBootCount = 0
    var invokedWillBootParameters: (container: DependencyProvider, Void)?
    var invokedWillBootParametersList = [(container: DependencyProvider, Void)]()

    func willBoot(_ container: DependencyProvider) {
        invokedWillBoot = true
        invokedWillBootCount += 1
        invokedWillBootParameters = (container, ())
        invokedWillBootParametersList.append((container, ()))
    }

    var invokedDidBoot = false
    var invokedDidBootCount = 0
    var invokedDidBootParameters: (container: DependencyProvider, Void)?
    var invokedDidBootParametersList = [(container: DependencyProvider, Void)]()

    func didBoot(_ container: DependencyProvider) {
        invokedDidBoot = true
        invokedDidBootCount += 1
        invokedDidBootParameters = (container, ())
        invokedDidBootParametersList.append((container, ()))
    }

    var invokedDidEnterBackground = false
    var invokedDidEnterBackgroundCount = 0
    var invokedDidEnterBackgroundParameters: (container: DependencyProvider, Void)?
    var invokedDidEnterBackgroundParametersList = [(container: DependencyProvider, Void)]()

    func didEnterBackground(_ container: DependencyProvider) {
        invokedDidEnterBackground = true
        invokedDidEnterBackgroundCount += 1
        invokedDidEnterBackgroundParameters = (container, ())
        invokedDidEnterBackgroundParametersList.append((container, ()))
    }

    var invokedWillShutdown = false
    var invokedWillShutdownCount = 0
    var invokedWillShutdownParameters: (container: DependencyProvider, Void)?
    var invokedWillShutdownParametersList = [(container: DependencyProvider, Void)]()

    func willShutdown(_ container: DependencyProvider) {
        invokedWillShutdown = true
        invokedWillShutdownCount += 1
        invokedWillShutdownParameters = (container, ())
        invokedWillShutdownParametersList.append((container, ()))
    }
}
