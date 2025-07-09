import XCTest
@testable import DependencyInjection

class DependencyEnvironmentTests: XCTestCase {
    func testDevelopmentCreation() {
        let environment = DependencyEnvironment.development
        XCTAssertEqual(environment.name, "development")
        XCTAssertFalse(environment.isRelease)
    }

    func testProductionCreation() {
        let environment = DependencyEnvironment.production
        XCTAssertEqual(environment.name, "production")
        // https://alexplescan.com/posts/2016/05/03/swift-a-nicer-way-to-tell-if-your-app-is-running-in-debug-mode/
        XCTAssertFalse(environment.isRelease)
    }

    func testTestableCreation() {
        let environment = DependencyEnvironment.testing
        XCTAssertEqual(environment.name, "testing")
        XCTAssertFalse(environment.isRelease)
    }

    func testOtherCreation() {
        let environment = DependencyEnvironment.custom(name: "local")
        XCTAssertEqual(environment.name, "local")
        XCTAssertFalse(environment.isRelease)
    }

    func testCustomDependencyEnvironmentWithCustomArgument() {
        let environment = DependencyEnvironment(name: "custom", arguments: ["isTest"])
        XCTAssertEqual(environment.name, "custom")
        XCTAssertEqual(environment.arguments, ["isTest"])
    }

    func testProcessString() {
        DependencyEnvironment.process.DATABASE_TYPE = "postgres"
        XCTAssertEqual(DependencyEnvironment.process.DATABASE_TYPE, "postgres")
        DependencyEnvironment.process.DATABASE_TYPE = nil
        XCTAssertNil(DependencyEnvironment.process.DATABASE_TYPE)
    }

    func testProcessGeneric() {
        DependencyEnvironment.process.DATABASE_PORT = 5_432
        XCTAssertEqual(DependencyEnvironment.process.DATABASE_PORT, 5_432)
        DependencyEnvironment.process.DATABASE_PORT = nil
        XCTAssertNil(DependencyEnvironment.process.DATABASE_PORT)
    }

    func testGetDependencyEnvironmentValue() {
        DependencyEnvironment.process.DATABASE_TYPE = "postgres"
        let type = DependencyEnvironment.get("DATABASE_TYPE")
        XCTAssertEqual(type, "postgres")
    }

    func testGetRawValueDevelopmentCreation() {
        let environment = DependencyEnvironment.development
        XCTAssertEqual(environment.rawValue, "development")
    }

    func testEquality() {
        let environment = DependencyEnvironment.development
        let custom = DependencyEnvironment.custom(name: "development")
        XCTAssertEqual(environment, custom)
    }

    func testCreateWithRawValue() {
        ["development", "production", "testing", "custom"].forEach {
            XCTAssertEqual(DependencyEnvironment(rawValue: $0)?.name, $0)
        }
    }

    func testOptionsString() throws {
        let urlPath = "http://myurl.com"
        var environment = DependencyEnvironment.development
        environment.setStringOption(key: "URL", value: urlPath)
        XCTAssertEqual(environment.options.URL, urlPath)
        XCTAssertEqual(try environment.getStringOption(key: "URL"), urlPath)

        environment.setStringOption(key: "URL", value: nil)
        XCTAssertNil(environment.options.URL)
        XCTAssertThrowsError(try environment.getStringOption(key: "URL"))
    }

    func testOptionGeneric() throws {
        let urlPort = 8_080
        var environment = DependencyEnvironment.development
        environment.setOption(key: "URL_PORT", value: urlPort)
        XCTAssertEqual(environment.options.URL_PORT, urlPort)
        // XCTAssertEqual(environment.getOption(key: "URL_PORT"), urlPort)
        environment.setStringOption(key: "URL_PORT", value: nil)
        XCTAssertNil(environment.options.URL_PORT)
        XCTAssertThrowsError(try environment.getStringOption(key: "URL_PORT"))
    }

    func testSetParameter() throws {
        // Given
        var environment = DependencyEnvironment.development
        let timestamp = Double(50)
        let key = DependencyEnvironmentKey(rawValue: "Timestamp")

        // When
        environment.setParameter(key: key, value: timestamp)

        // Then
        let expected: Double = try environment.getParameter(key: key)
        XCTAssertEqual(expected, timestamp)
    }

    func testGetParameter() throws {
        // Given
        var environment = DependencyEnvironment.development
        let key = DependencyEnvironmentKey(rawValue: "Timestamp")
        let timestamp = Double(50)
        environment.setParameter(key: key, value: timestamp)

        // When
        let expectedValue: Double = try environment.getParameter(key: key)
        // Then
        XCTAssertEqual(expectedValue, timestamp)
    }

    func testNotFoundParameter() throws {
        // Given
        let environment = DependencyEnvironment.development
        let key = DependencyEnvironmentKey(rawValue: "Timestamp")

        // When
        let callback: () throws -> Void = {
            try environment.getParameter(key: key)
        }

        // Then
        XCTAssertThrowsError(try callback(), "not found parameter") { error in
            XCTAssertEqual(
                error as? DependencyEnvironmentError,
                DependencyEnvironmentError.notFoundParameter(key)
            )
        }
    }

    func xtestGetOption() throws {
        // given
        let urlPort = 8_080
        var environment = DependencyEnvironment.development
        let key = DependencyEnvironmentKey(rawValue: "URL_PORT")
        environment.setOption(key: key, value: urlPort)

        // when
        let expectedvalue: Int = try environment.getOption(key: key)

        // then
        XCTAssertEqual(expectedvalue, urlPort)
    }
}
