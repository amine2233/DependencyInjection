import Foundation
import DependencyInjection

class ProviderMock: DependencyProvider {

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
    var invokedWillBootParameters: (container: DependencyType, Void)?
    var invokedWillBootParametersList = [(container: DependencyType, Void)]()

    func willBoot(_ container: DependencyType) {
        invokedWillBoot = true
        invokedWillBootCount += 1
        invokedWillBootParameters = (container, ())
        invokedWillBootParametersList.append((container, ()))
    }

    var invokedDidBoot = false
    var invokedDidBootCount = 0
    var invokedDidBootParameters: (container: DependencyType, Void)?
    var invokedDidBootParametersList = [(container: DependencyType, Void)]()

    func didBoot(_ container: DependencyType) {
        invokedDidBoot = true
        invokedDidBootCount += 1
        invokedDidBootParameters = (container, ())
        invokedDidBootParametersList.append((container, ()))
    }

    var invokedDidEnterBackground = false
    var invokedDidEnterBackgroundCount = 0
    var invokedDidEnterBackgroundParameters: (container: DependencyType, Void)?
    var invokedDidEnterBackgroundParametersList = [(container: DependencyType, Void)]()

    func didEnterBackground(_ container: DependencyType) {
        invokedDidEnterBackground = true
        invokedDidEnterBackgroundCount += 1
        invokedDidEnterBackgroundParameters = (container, ())
        invokedDidEnterBackgroundParametersList.append((container, ()))
    }

    var invokedWillShutdown = false
    var invokedWillShutdownCount = 0
    var invokedWillShutdownParameters: (container: DependencyType, Void)?
    var invokedWillShutdownParametersList = [(container: DependencyType, Void)]()

    func willShutdown(_ container: DependencyType) {
        invokedWillShutdown = true
        invokedWillShutdownCount += 1
        invokedWillShutdownParameters = (container, ())
        invokedWillShutdownParametersList.append((container, ()))
    }
}
