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
        // WHEN
        let dependencies = factory().dependencies

        // THEN
        XCTAssertTrue(dependencies.description.contains("\n- \(String(describing: LocationMock.self))"))
        XCTAssertTrue(dependencies.description.contains("\n- \(String(describing: JourneyMock.self))"))
    }

    func testUnregisterProvider() throws {
        // Given
        var dependencies = factory().dependencies
        dependencies.registerProvider(ProviderMock())

        // WHEN
        dependencies.unregisterProvider(ProviderMock.self)

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

    func testResolveWithName() throws {
        // GIVEN
        // WHEN
        let dependencies = factory().dependencies

        // THEN
        XCTAssertNoThrow(try dependencies.resolve(withName: "JourneyMock") as JourneyMock)
    }

    func testResolveWithNameFailure() throws {
        // GIVEN
        // WHEN
        let dependencies = factory().dependencies

        // THEN
        XCTAssertThrowsError(try dependencies.resolve(withName: "Mock") as JourneyMock)
    }

    func testUnregisterWithName() throws {
        // GIVEN
        // WHEN
        var dependencies = factory().dependencies
        dependencies.unregister(withName: "JourneyMock")

        // THEN
        XCTAssertEqual(dependencies.dependenciesCount, 1)
    }

    func testRegisterWithName() throws {
        // GIVEN
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(withName: "Mock") { _ in
            ExecutableServiceMock()
        }

        // THEN
        XCTAssertEqual(dependencies.dependenciesCount, 3)
    }
}
