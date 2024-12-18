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
}
