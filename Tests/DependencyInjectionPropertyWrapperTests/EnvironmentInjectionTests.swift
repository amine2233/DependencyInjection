import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionPropertyWrapper

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
        dependencyCore.register((any JourneyService).self, completion: { _ in JourneyMock() })
        dependencyCore.register((any LocationService).self, completion: { _ in LocationMock() })
    }

    func testGetDependencyEnvironment() throws {
        // given
        dependencyCore.environment = DependencyEnvironment.testing

        // when
        @EnvironmentInjection(dependencies: dependencyCore)
        var environment: DependencyEnvironment

        // then
        XCTAssertEqual(environment.rawValue, DependencyEnvironment.testing.rawValue)
    }

    func testSetDependencyEnvironment() throws {
        // given
        dependencyCore.environment = DependencyEnvironment.testing

        // when
        @EnvironmentInjection(dependencies: dependencyCore)
        var environment: DependencyEnvironment
        $environment.wrappedValue = DependencyEnvironment.development

        // then
        XCTAssertEqual(environment.rawValue, DependencyEnvironment.development.rawValue)
    }
}
