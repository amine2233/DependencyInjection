@testable import DependencyInjection
import XCTest

class DependencyEnvironementTests: XCTestCase {
    func testDevelopmentCreation() {
        let environement = DependencyEnvironment.development
        XCTAssertEqual(environement.name, "development")
        XCTAssertFalse(environement.isRelease)
    }

    func testProductionCreation() {
        let environement = DependencyEnvironment.production
        XCTAssertEqual(environement.name, "production")
        // https://alexplescan.com/posts/2016/05/03/swift-a-nicer-way-to-tell-if-your-app-is-running-in-debug-mode/
        XCTAssertFalse(environement.isRelease)
    }

    func testTestableCreation() {
        let environement = DependencyEnvironment.testing
        XCTAssertEqual(environement.name, "testing")
        XCTAssertFalse(environement.isRelease)
    }

    func testOtherCreation() {
        let environement = DependencyEnvironment.custom(name: "local")
        XCTAssertEqual(environement.name, "local")
        XCTAssertFalse(environement.isRelease)
    }

    func testCustomDependencyEnvironementWithCustomArgument() {
        let environement = DependencyEnvironment(name: "custom", arguments: ["isTest"])
        XCTAssertEqual(environement.name, "custom")
        XCTAssertEqual(environement.arguments, ["isTest"])
    }

    func testProcessString() {
        let environment: DependencyEnvironment = .testing
        environment.process.DATABASE_TYPE = "postgres"
        XCTAssertEqual(environment.process.DATABASE_TYPE, "postgres")
        environment.process.DATABASE_TYPE = nil
        XCTAssertNil(environment.process.DATABASE_TYPE)
    }

    func testProcessGeneric() {
        let environment: DependencyEnvironment = .testing
        environment.process.DATABASE_PORT = 5432
        XCTAssertEqual(environment.process.DATABASE_PORT, 5432)
        environment.process.DATABASE_PORT = nil
        XCTAssertNil(environment.process.DATABASE_PORT)
    }

    func testGetDependencyEnvironementValue() {
        let environment: DependencyEnvironment = .testing
        environment.process.DATABASE_TYPE = "postgres"
        let type = environment.get("DATABASE_TYPE")
        XCTAssertEqual(type, "postgres")
    }

    func testGetRawValueDevelopmentCreation() {
        let environement = DependencyEnvironment.development
        XCTAssertEqual(environement.rawValue, "development")
    }

    func testEquality() {
        let environement = DependencyEnvironment.development
        let custom = DependencyEnvironment.custom(name: "development")
        XCTAssertEqual(environement, custom)
    }

    func testCreateWithRawValue() {
        ["development", "production", "testing", "custom"].forEach {
            XCTAssertEqual(DependencyEnvironment(rawValue: $0)?.name, $0)
        }
    }

    func testOptionsString() {
        let urlPath = "http://myurl.com"
        var environement = DependencyEnvironment.development
        environement.setStringOption(key: "URL", value: urlPath)
        XCTAssertEqual(environement.options.URL, urlPath)
        XCTAssertEqual(environement.getStringOption(key: "URL"), urlPath)

        environement.setStringOption(key: "URL", value: nil)
        XCTAssertNil(environement.options.URL)
        XCTAssertNil(environement.getStringOption(key: "URL"))
    }

    func testOptionGeneric() {
        let urlPort = 8080
        var environement = DependencyEnvironment.development
        environement.setOption(key: "URL_PORT", value: urlPort)
        XCTAssertEqual(environement.options.URL_PORT, urlPort)
        // XCTAssertEqual(environement.getOption(key: "URL_PORT"), urlPort)
        environement.setStringOption(key: "URL_PORT", value: nil)
        XCTAssertNil(environement.options.URL_PORT)
        XCTAssertNil(environement.getStringOption(key: "URL_PORT"))
    }
}
