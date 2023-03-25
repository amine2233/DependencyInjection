import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionPropertyWraper

class EnvironmentStringOptionTests: XCTestCase {
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

    func testGetEnvironmentStringOption() throws {
        // given
        dependencyCore.environment = DependencyEnvironment.testing
        let option = "empty_value"
        dependencyCore.environment.setOption(key: .optionValue, value: option)

        // when
        @EnvironmentStringOption(key: .optionValue, dependencies: dependencyCore)
        var expectedOption: String?

        // then
        XCTAssertEqual(expectedOption, option)
    }

    func testSetEnvironmentStringOption() throws {
        dependencyCore.environment = DependencyEnvironment.testing
        let option = "empty_value"
        dependencyCore.environment.setOption(key: .optionValue, value: option)
        let updatedOption = "updated_value"
        @EnvironmentStringOption(key: .optionValue, dependencies: dependencyCore)
        var expectedOption: String?

        // when
        $expectedOption.wrappedValue = updatedOption

        // then
        XCTAssertEqual(expectedOption, updatedOption)

    }

    func testGetEnvironmentStringOptionWithDynamicMemberLookup() throws {
        // given
        dependencyCore.environment = DependencyEnvironment.testing
        let database_port = "3306"
        dependencyCore.environment.options.DATABASE_PORT = database_port

        // when
        @EnvironmentStringOption(key: .database_port, dependencies: dependencyCore)
        var expectedOption: String?

        // then
        XCTAssertEqual(expectedOption, database_port)
    }

    func testSetEnvironmentStringOptionUsingEnv() throws {
        dependencyCore.environment = DependencyEnvironment.testing
        let database_port = "3306"
        dependencyCore.environment.options.DATABASE_PORT = database_port
        let update_database_port = "5432"

        @EnvironmentStringOption(key: .database_port, dependencies: dependencyCore)
        var expectedOption: String?

        // when
        $expectedOption.wrappedValue = update_database_port

        // then
        XCTAssertEqual(expectedOption, update_database_port)

    }
}

extension DependencyEnvironmentKey {
    static let optionValue = DependencyEnvironmentKey(stringLiteral: "option_value")
    static let database_port = DependencyEnvironmentKey(stringLiteral: "DATABASE_PORT")
}
