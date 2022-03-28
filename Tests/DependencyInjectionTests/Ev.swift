@testable import DependencyInjection
import XCTest

class DependencyEnvironementTests: XCTestCase {
    func testDevelopmentCreation() {
        let environement = DependencyEnvironement.development
        XCTAssertEqual(environement.name, "development")
        XCTAssertFalse(environement.isRelease)
    }

    func testProductionCreation() {
        let environement = DependencyEnvironement.production
        XCTAssertEqual(environement.name, "production")
        // https://alexplescan.com/posts/2016/05/03/swift-a-nicer-way-to-tell-if-your-app-is-running-in-debug-mode/
        XCTAssertFalse(environement.isRelease)
    }

    func testTestableCreation() {
        let environement = DependencyEnvironement.testing
        XCTAssertEqual(environement.name, "testing")
        XCTAssertFalse(environement.isRelease)
    }

    func testOtherCreation() {
        let environement = DependencyEnvironement.custom(name: "local")
        XCTAssertEqual(environement.name, "local")
        XCTAssertFalse(environement.isRelease)
    }

    func testCustomDependencyEnvironementWithCustomArgument() {
        let environement = DependencyEnvironement(name: "custom", arguments: ["isTest"])
        XCTAssertEqual(environement.name, "custom")
        XCTAssertEqual(environement.arguments, ["isTest"])
    }

    func testProcessString() {
        DependencyEnvironement.process.DATABASE_TYPE = "postgres"
        XCTAssertEqual(DependencyEnvironement.process.DATABASE_TYPE, "postgres")
        DependencyEnvironement.process.DATABASE_TYPE = nil
        XCTAssertNil(DependencyEnvironement.process.DATABASE_TYPE)
    }

    func testProcessGeneric() {
        DependencyEnvironement.process.DATABASE_PORT = 5432
        XCTAssertEqual(DependencyEnvironement.process.DATABASE_PORT, 5432)
        DependencyEnvironement.process.DATABASE_PORT = nil
        XCTAssertNil(DependencyEnvironement.process.DATABASE_PORT)
    }

    func testGetDependencyEnvironementValue() {
        DependencyEnvironement.process.DATABASE_TYPE = "postgres"
        let type = DependencyEnvironement.get("DATABASE_TYPE")
        XCTAssertEqual(type, "postgres")
    }

    func testGetRawValueDevelopmentCreation() {
        let environement = DependencyEnvironement.development
        XCTAssertEqual(environement.rawValue, "development")
    }

    func testEquality() {
        let environement = DependencyEnvironement.development
        let custom = DependencyEnvironement.custom(name: "development")
        XCTAssertEqual(environement, custom)
    }

    func testCreateWithRawValue() {
        ["development", "production", "testing", "custom"].forEach {
            XCTAssertEqual(DependencyEnvironement(rawValue: $0)?.name, $0)
        }
    }

    func testOptionsString() {
        let urlPath = "http://myurl.com"
        var environement = DependencyEnvironement.development
        environement.setStringOption(key: "URL", value: urlPath)
        XCTAssertEqual(environement.options.URL, urlPath)
        XCTAssertEqual(environement.getStringOption(key: "URL"), urlPath)

        environement.setStringOption(key: "URL", value: nil)
        XCTAssertNil(environement.options.URL)
        XCTAssertNil(environement.getStringOption(key: "URL"))
    }

    func testOptionGeneric() {
        let urlPort = 8080
        var environement = DependencyEnvironement.development
        environement.setOption(key: "URL_PORT", value: urlPort)
        XCTAssertEqual(environement.options.URL_PORT, urlPort)
        // XCTAssertEqual(environement.getOption(key: "URL_PORT"), urlPort)
        environement.setStringOption(key: "URL_PORT", value: nil)
        XCTAssertNil(environement.options.URL_PORT)
        XCTAssertNil(environement.getStringOption(key: "URL_PORT"))
    }
}
