import Foundation
import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionProperty

final class DependencyInjectionPropertyTests: XCTestCase {
    var dependencyCore: DependencyCore!

    override func setUpWithError() throws {
        dependencyCore = DependencyCore()
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    func factory() -> DependencyInjector {
        DependencyInjector(dependencies: dependencyCore) {}
    }

    func testResolveWithTypeParameters() throws {
        // GIVEN
        dependencyCore.register(LocationMock.self) { (_, value: String) in
            LocationMock(stubbedValue: value)
        }
        let argument = "test_pass_value"

        // WHEN
        let dependencies = try dependencyCore.resolver(LocationMock.self, argument: argument)

        // THEN
        XCTAssert(dependencies.value == argument)
    }

    func testResolveWithTypeParameters_autoregister() throws {
        // GIVEN
        dependencyCore.autoregister(LocationMock.self, initializer: LocationMock.init)

        let argument = "test_pass_value"

        // WHEN
        let dependencies = try dependencyCore.resolver(LocationMock.self, argument: argument)

        // THEN
        XCTAssert(dependencies.value == argument)
    }

    func testResolveWithTypeParameters_failed_arg1() throws {
        // GIVEN
        dependencyCore.register(LocationMock.self) { (_, value: String) in
            LocationMock(stubbedValue: value)
        }
        let argument = 2

        // WHEN
        let dependencies: (() throws -> LocationMock) = { [unowned self] in
            try dependencyCore.resolver(LocationMock.self, argument: argument)
        }

        // THEN
        XCTAssertThrowsError(try dependencies()) { error in
            guard let error = error as? DependencyResolverError
            else { return XCTFail("Not good error we need to expect DependencyResolverError") }
            XCTAssertEqual(error, DependencyResolverError.parameterNotResolved(service: "LocationMock", type: "String"))
        }
    }
}
