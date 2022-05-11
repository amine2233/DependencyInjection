import XCTest
@testable import DependencyInjection

class DependencyInjection_DeprecatedTests: XCTestCase {
    var dependencyCore: DependencyCore!

    override func setUpWithError() throws {
        dependencyCore = DependencyCore()
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    func factory() -> DependencyInjector {
        DependencyInjector(dependencies: dependencyCore) {
            DependencyResolver { _ in LocationMock() }
            DependencyResolver { _ in JourneyMock() }
        }
    }

    func testSingletonRegisterWithServiceType() throws {
        // Given
        var dependencies = factory().dependencies

        // WHEN
        try dependencies.registerSingleton(ExecutableServiceMock.self)

        // THEN
        XCTAssertNoThrow(try dependencies.singleton() as ExecutableServiceMock)
    }

    func testSingletonRegisterWithTypeAndCompletion() throws {
        // Given
        var dependencies = factory().dependencies
        try dependencies.registerSingleton { _ in
            ExecutableServiceMock()
        }

        // WHEN
        let singleton: ExecutableServiceMock = try dependencies.singleton()

        // THEN
        XCTAssertEqual(String(describing: singleton.self).components(separatedBy: ".").last, String(describing: ExecutableServiceMock.self))
    }

    func testSingletonResolveWithServiceType() throws {
        // Given
        var dependencies = factory().dependencies
        dependencies.register(ExecutableServiceMock.self)

        // WHEN
        try dependencies.registerSingleton(ExecutableServiceMock.self)

        // THEN
        XCTAssertNoThrow(try dependencies.resolve() as ExecutableServiceMock)
    }

    func testSingletonResolveWithTypeAndCompletion() throws {
        // Given
        var dependencies = factory().dependencies
        try dependencies.registerSingleton { _ in
            LocationMock()
        }

        // WHEN
        let singleton: LocationMock = try dependencies.singleton()

        // THEN
        XCTAssertEqual(String(describing: singleton.self).components(separatedBy: ".").last, String(describing: LocationMock.self))
    }


    func test_rsolve_singleton_with_ServiceType() throws {
        // Given
        var dependencies = factory().dependencies
        try dependencies.registerSingleton(ExecutableServiceMock.self)

        // WHEN
        let singleton = try? dependencies.singleton() as ExecutableServiceMock

        // THEN
        XCTAssertNotNil(singleton)
    }
}
