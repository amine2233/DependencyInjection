import XCTest
@testable import DependencyInjection

class DependencyInjection_DeprecatedTests: XCTestCase {
    var dependencyCore: DependencyCore!

    override func setUpWithError() throws {
        dependencyCore = DependencyCore()
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    func factory() -> DependencyInjector {
        DependencyInjector(dependencies: dependencyCore) {
            DependencyResolverFactory.build { _ in LocationMock() }
            DependencyResolverFactory.build { _ in JourneyMock() }
        }
    }

    func testSingletonResolveWithServiceType() throws {
        // Given
        var dependencies = factory().dependencies
        dependencies.register(ExecutableServiceMock.self)

        // WHEN
        try dependencies.registerSingleton(ExecutableServiceMock.self)

        // THEN
        XCTAssertNoThrow(try dependencies.resolve() as ExecutableServiceMock)
    }
}
