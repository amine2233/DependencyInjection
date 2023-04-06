import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionPropertyWraper

class EnvironmentParameterTests: XCTestCase {
    var dependencyCore: DependencyCore!

    override func setUpWithError() throws {
        dependencyCore = DependencyCore()
        factory()
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    func factory() {
        dependencyCore.register(JourneyService.self, completion: { _,_ in JourneyMock() })
        dependencyCore.register(LocationService.self, completion: { _,_ in LocationMock() })
    }

    func testGetEnvironmentParameter() throws {
        // given
        dependencyCore.environment = DependencyEnvironment.testing
        let timeInterval = TimeInterval(50.0)
        dependencyCore.environment.setParameter(key: .timeInterval, value: timeInterval)

        // when
        @EnvironmentParameter(key: .timeInterval, dependencies: dependencyCore)
        var parameter: TimeInterval?

        // then
        XCTAssertEqual(parameter, timeInterval)
    }

    func testSetEnvironmentParameter() throws {
        // given
        dependencyCore.environment = DependencyEnvironment.testing
        let initialTimeInterval = TimeInterval(50.0)
        dependencyCore.environment.setParameter(key: .timeInterval, value: initialTimeInterval)
        let updatedTimeInterval = TimeInterval(30)
        @EnvironmentParameter(key: .timeInterval, dependencies: dependencyCore)
        var parameter: TimeInterval?

        // when
        $parameter.wrappedValue = updatedTimeInterval

        // then
        XCTAssertEqual(parameter, updatedTimeInterval)
    }
}

extension DependencyEnvironmentKey {
    static let timeInterval = DependencyEnvironmentKey(stringLiteral: "time_interval")
}
