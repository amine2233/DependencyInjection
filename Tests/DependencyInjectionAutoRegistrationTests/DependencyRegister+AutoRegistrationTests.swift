import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionAutoRegistration

final class DependencyRegisterAutoRegistrationTests: XCTestCase {
    var dependencyCore: (any Dependency)!

    override func setUpWithError() throws {
        dependencyCore = DependencyCore()
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    // MARK: - Test using @Injection with dependencies

    func test_AutoRegistration() throws {
        // given

        // when
        dependencyCore.autoregister((any JourneyService).self, initializer: JourneyMock.init)

        // then
        XCTAssertNoThrow(try dependencyCore.resolve((any JourneyService).self) as! JourneyMock)
    }

    func test_AutoRegistration_with_two_paramaters() throws {
        // given
        dependencyCore.autoregister((any JourneyService).self, initializer: JourneyMock.init)
        dependencyCore.autoregister((any ExecutableService).self, initializer: ExecutableServiceMock.init)

        // when
        dependencyCore.autoregister((any LocationService).self, initializer: LocationServiceMock.init)

        // then
        XCTAssertNoThrow(try dependencyCore.resolve((any LocationService).self) as! LocationServiceMock)
    }
}
