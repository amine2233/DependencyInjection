import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionAutoRegistration

final class DependencySingletonAutoRegistration: XCTestCase {
    var dependencyCore: (any Dependency)!

    override func setUpWithError() throws {
        dependencyCore = DependencyCore()
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    // MARK: - Test using @Injection with dependencies

    func test_AutoRegistration() throws {
        // GIVEN

        // WHEN
        try dependencyCore.autoregisterSingleton(
            (any JourneyService).self,
            initializer: JourneyMock.init
        )

        // THEN
        XCTAssertNoThrow(try dependencyCore.resolve((any JourneyService).self) as! JourneyMock)
    }

    func test_AutoRegistration_with_two_paramaters() throws {
        // GIVEN
        dependencyCore.autoregister((any JourneyService).self, initializer: JourneyMock.init)
        dependencyCore.autoregister((any ExecutableService).self, initializer: ExecutableServiceMock.init)

        // WHEN
        try dependencyCore.autoregisterSingleton(
            (any LocationService).self,
            initializer: LocationServiceMock.init
        )

        // THEN
        XCTAssertNoThrow(try dependencyCore.resolve((any LocationService).self) as! LocationServiceMock)
    }

    func test_AutoRegistration_with_three_parameters() throws {
        // GIVEN — the single parameter-pack overload resolves an arity beyond the old fixed overloads
        dependencyCore.autoregister((any JourneyService).self, initializer: JourneyMock.init)
        dependencyCore.autoregister((any ExecutableService).self, initializer: ExecutableServiceMock.init)
        dependencyCore.autoregister((any LocationService).self, initializer: LocationServiceMock.init)

        // WHEN
        try dependencyCore.autoregisterSingleton(
            (any CompositeService).self,
            initializer: CompositeServiceMock.init
        )

        // THEN
        XCTAssertNoThrow(try dependencyCore.resolve((any CompositeService).self) as! CompositeServiceMock)
    }
}
