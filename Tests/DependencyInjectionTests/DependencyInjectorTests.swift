import XCTest
@testable import DependencyInjection

struct DependencyRegisteringTest: DependencyRegistering {
    static func registerAllServices(in dependencies: inout any Dependency) {
        dependencies.register(ExecutableServiceMock.self)
    }
}

class DependencyInjectorTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the
        // class.
    }

    func testDependencyInjectionUsingResgistration() throws {
        // given

        // when
        let injector = DependencyInjector(register: DependencyRegisteringTest.self)

        // then
        XCTAssertEqual(injector.dependencies.dependenciesCount, 1)
    }
}
