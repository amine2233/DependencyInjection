import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionPropertyWraper

class EnvironmentTests: XCTestCase {
    var dependencyCore: DependencyCore!

    override func setUpWithError() throws {
        dependencyCore = DependencyCore()
        factory()
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    func factory() {
        dependencyCore.register(JourneyService.self, completion: { _ in JourneyMock() })
        dependencyCore.register(LocationService.self, completion: { _ in LocationMock() })
    }

    func testGetDependencyEnvironement() throws {
        // given
        dependencyCore.environment = DependencyEnvironement.testing

        // when
        @EnvironmentInjection(dependencies: dependencyCore)
        var environment: DependencyEnvironement

        // then
        XCTAssertEqual(environment.rawValue, DependencyEnvironement.testing.rawValue)
    }

    func testSetDependencyEnvironement() throws {
        // given
        dependencyCore.environment = DependencyEnvironement.testing

        // when
        @EnvironmentInjection(dependencies: dependencyCore)
        var environment: DependencyEnvironement
        $environment.wrappedValue = DependencyEnvironement.development

        // then
        XCTAssertEqual(environment.rawValue, DependencyEnvironement.development.rawValue)
    }
}
