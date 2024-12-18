import Foundation
import DependencyInjection

class ProviderMock: Provider, @unchecked Sendable {
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
    var invokedWillBootParameters: (container: any DependencyProvider, Void)?
    var invokedWillBootParametersList = [(container: any DependencyProvider, Void)]()

    func willBoot(_ container: any DependencyProvider) {
        invokedWillBoot = true
        invokedWillBootCount += 1
        invokedWillBootParameters = (container, ())
        invokedWillBootParametersList.append((container, ()))
    }

    var invokedDidBoot = false
    var invokedDidBootCount = 0
    var invokedDidBootParameters: (container: any DependencyProvider, Void)?
    var invokedDidBootParametersList = [(container: any DependencyProvider, Void)]()

    func didBoot(_ container: any DependencyProvider) {
        invokedDidBoot = true
        invokedDidBootCount += 1
        invokedDidBootParameters = (container, ())
        invokedDidBootParametersList.append((container, ()))
    }

    var invokedDidEnterBackground = false
    var invokedDidEnterBackgroundCount = 0
    var invokedDidEnterBackgroundParameters: (container: any DependencyProvider, Void)?
    var invokedDidEnterBackgroundParametersList = [(container: any DependencyProvider, Void)]()

    func didEnterBackground(_ container: any DependencyProvider) {
        invokedDidEnterBackground = true
        invokedDidEnterBackgroundCount += 1
        invokedDidEnterBackgroundParameters = (container, ())
        invokedDidEnterBackgroundParametersList.append((container, ()))
    }

    var invokedWillShutdown = false
    var invokedWillShutdownCount = 0
    var invokedWillShutdownParameters: (container: any DependencyProvider, Void)?
    var invokedWillShutdownParametersList = [(container: any DependencyProvider, Void)]()

    func willShutdown(_ container: any DependencyProvider) {
        invokedWillShutdown = true
        invokedWillShutdownCount += 1
        invokedWillShutdownParameters = (container, ())
        invokedWillShutdownParametersList.append((container, ()))
    }
}
