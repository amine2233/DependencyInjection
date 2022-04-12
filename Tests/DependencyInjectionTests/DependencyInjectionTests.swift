import XCTest
@testable import DependencyInjection

class DependencyInjectionTests: XCTestCase {

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

    func testResolveWithType() throws {
        // GIVEN
        // WHEN
        let dependencies = factory().dependencies

        // THEN
        XCTAssertNoThrow(try dependencies.resolve(LocationMock.self))
        XCTAssertNoThrow(try dependencies.resolve() as JourneyMock)

    }

    func testResolve() throws {
        // GIVEN
        // WHEN
        let dependencies = factory().dependencies

        // THEN
        XCTAssertNoThrow(try dependencies.resolve() as JourneyMock)
    }

    func testResolveFailure() throws {
        // GIVEN
        // WHEN
        let dependencies = factory().dependencies

        // THEN
        XCTAssertThrowsError(try dependencies.resolve() as ExecutableServiceMock)
    }

    func testResolveWithTypeFailure() throws {
        // GIVEN
        // WHEN
        let dependencies = factory().dependencies

        // THEN
        XCTAssertThrowsError(try dependencies.resolve(ExecutableServiceMock.self))
    }

    func testRegisterWithServiceType() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(ExecutableServiceMock.self)

        // THEN
        XCTAssertNoThrow(try dependencies.resolve() as ExecutableServiceMock)
    }

    func testRegisterDependency() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(DependencyResolver { _ in ExecutableServiceMock() })

        // THEN
        XCTAssertNoThrow(try dependencies.resolve() as ExecutableServiceMock)
    }

    func testRegisterWithTypeAndCompletion() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(ExecutableServiceMock.self) { _ in
            ExecutableServiceMock()
        }

        // THEN
        XCTAssertNoThrow(try dependencies.resolve() as ExecutableServiceMock)
    }

    func testUnregister() throws {
        // Given
        var dependencies = factory().dependencies

        // WHEN
        dependencies.unregister(LocationMock.self)

        // THEN
        XCTAssertEqual(dependencies.dependenciesCount, 1)
    }

    func testUnregisterNotFoundService() throws {
        // Given
        var dependencies = factory().dependencies
        dependencies.register(ExecutableServiceMock.self) { _ in
            ExecutableServiceMock()
        }

        // WHEN
        dependencies.unregister(ExecutableServiceMock.self)

        // THEN
        XCTAssertEqual(dependencies.dependenciesCount, 2)
    }

    func testCreateWithServiceType() throws {
        // Given
        // WHEN
        let dependencies = factory().dependencies
        let service = dependencies.create(ExecutableServiceMock.self)

        // THEN
        XCTAssertEqual(String(describing: service.self).components(separatedBy: ".").last, String(describing: ExecutableServiceMock.self))
    }

    func testCreateDependency() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        let service = dependencies.create(DependencyResolver { _ in ExecutableServiceMock() })

        // THEN
        XCTAssertEqual(String(describing: service.self).components(separatedBy: ".").last, String(describing: ExecutableServiceMock.self))
    }

    func testCreateWithTypeAndCompletion() throws {
        // Given
        // WHEN
        let dependencies = factory().dependencies
        let service = dependencies.create { _ in
            ExecutableServiceMock()
        }

        // THEN
        XCTAssertEqual(String(describing: service.self).components(separatedBy: ".").last, String(describing: ExecutableServiceMock.self))
    }

    func testSingletonRegisterWithServiceType() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        dependencies.singleton(ExecutableServiceMock.self)

        // THEN
        XCTAssertNoThrow(try dependencies.singleton() as ExecutableServiceMock)
    }

    func testSingletonRegisterWithTypeAndCompletion() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        let singleton = dependencies.singleton { _ in
            ExecutableServiceMock()
        }

        // THEN
        XCTAssertEqual(String(describing: singleton.self).components(separatedBy: ".").last, String(describing: ExecutableServiceMock.self))
    }

    func testSingletonResolveWithServiceType() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(ExecutableServiceMock.self)
        dependencies.singleton(ExecutableServiceMock.self)

        // THEN
        XCTAssertNoThrow(try dependencies.resolve() as ExecutableServiceMock)
    }

    func testSingletonResolveWithTypeAndCompletion() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        let singleton = dependencies.singleton { _ in
            LocationMock()
        }

        // THEN
        XCTAssertEqual(String(describing: singleton.self).components(separatedBy: ".").last, String(describing: LocationMock.self))
    }

    func testDescriptionWithProvider() throws {
        // Given
        let provider = ProviderMock()
        provider.stubbedDescription = String(describing: ProviderMock.self)
        // WHEN
        let di = DependencyInjector(dependencies: dependencyCore) { () -> [DependencyResolver] in
            return []
        } _: { () -> [Provider] in
            return [ProviderDefault { _ in provider }]
        }

        // THEN
        XCTAssertTrue(di.dependencies.description.contains("\n- \(String(describing: ProviderMock.self))"))
    }

    func testDescription() throws {
        // Given
        let dependencies = factory().dependencies

        // WHEN
        let description = dependencies.description

        // THEN
        XCTAssertTrue(description.contains("\n- \(DependencyKey(type: LocationMock.self))"))
        XCTAssertTrue(description.contains("\n- \(DependencyKey(type: JourneyMock.self))"))
    }

    func test_description_when_add_singleton() throws {
        // Given
        var dependencies = factory().dependencies

        // WHEN
        dependencies.singleton(ExecutableServiceMock.self)

        // THEN
        XCTAssertTrue(dependencies.description.contains("\n- \(DependencyKey(type: ExecutableServiceMock.self))"))
    }

    func testUnregisterProvider() throws {
        // Given
        let provider = ProviderMock()
        var dependencies = factory().dependencies
        dependencies.registerProvider(provider)

        // WHEN
        dependencies.unregisterProvider(provider)

        // THEN
        XCTAssertEqual(dependencies.providersCount, 0)
    }

    func testWillBoot() throws {
        // Given
        let provider = ProviderMock()

        // WHEN
        var dependencies = factory().dependencies
        dependencies.registerProvider(provider)

        _ = dependencies.willBoot()

        // THEN
        XCTAssertEqual(provider.invokedWillBootCount, 1)
    }

    func testDidBoot() throws {
        // Given
        let provider = ProviderMock()

        // WHEN
        var dependencies = factory().dependencies
        dependencies.registerProvider(provider)

        _ = dependencies.didBoot()

        // THEN
        XCTAssertEqual(provider.invokedDidBootCount, 1)
    }

    func testWillShutdown() throws {
        // Given
        let provider = ProviderMock()
        // WHEN
        var dependencies = factory().dependencies
        dependencies.registerProvider(provider)

        _ = dependencies.willShutdown()

        // THEN
        XCTAssertEqual(provider.invokedWillShutdownCount, 1)
    }

    func testDidEnterBackground() throws {
        // Given
        let provider = ProviderMock()
        // WHEN
        var dependencies = factory().dependencies
        dependencies.registerProvider(provider)

        _ = dependencies.didEnterBackground()

        // THEN
        XCTAssertEqual(provider.invokedDidEnterBackgroundCount, 1)
    }

    func testDependencyCount() throws {
        // GIVEN
        // WHEN
        let dependencies = factory().dependencies

        // THEN
        XCTAssertEqual(dependencies.dependenciesCount, 2)
    }

    func test_register_singleton_with_ServiceType() throws {
        // Given
        var dependencies = factory().dependencies

        // WHEN
        dependencies.singleton(ExecutableServiceMock.self)

        // THEN
        XCTAssertEqual(dependencies.singletonCount, 1)
    }

    func test_register_dependency_singleton_with_ServiceType() throws {
        // Given
        var dependencies = factory().dependencies

        // WHEN
        dependencies.singleton { _ in
            ExecutableServiceMock()
        }

        // THEN
        XCTAssertEqual(dependencies.singletonCount, 1)
    }

    func test_rsolve_singleton_with_ServiceType() throws {
        // Given
        var dependencies = factory().dependencies
        dependencies.singleton(ExecutableServiceMock.self)

        // WHEN
        let singleton = try? dependencies.singleton() as ExecutableServiceMock

        // THEN
        XCTAssertNotNil(singleton)
    }

    func test_unregister_singleton_with_ServiceType() throws {
        // Given
        var dependencies = factory().dependencies
        dependencies.singleton(ExecutableServiceMock.self)

        // WHEN
        try dependencies.unregisterSingleton(ExecutableServiceMock.self)

        // THEN
        XCTAssertEqual(dependencies.singletonCount, 0)
    }
}
