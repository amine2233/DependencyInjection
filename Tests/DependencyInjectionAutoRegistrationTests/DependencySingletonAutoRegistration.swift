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
}
