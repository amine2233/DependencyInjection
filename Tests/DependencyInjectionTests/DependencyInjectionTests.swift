import XCTest
@testable import DependencyInjection

class DependencyInjectionTests: XCTestCase {

    var dependencyCore: DependencyInjection!

    override func setUpWithError() throws {
        dependencyCore = DependencyInjection()
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    func factory() -> DependencyInjector {
        DependencyInjector(dependencies: dependencyCore) {
            Dependency { _ in LocationMock() }
            Dependency { _ in JourneyMock() }
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
        dependencies.register(Dependency { _ in ExecutableServiceMock() })

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
        // WHEN
        var dependencies = factory().dependencies

        // THEN
        XCTAssertNoThrow(try dependencies.unregister(LocationMock.self))
    }

    func testUnregisterNotFoundService() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies

        // THEN
        XCTAssertThrowsError(try dependencies.unregister(ExecutableServiceMock.self))
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
        let service = dependencies.create(Dependency { _ in ExecutableServiceMock() })

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
        XCTAssertNoThrow(try dependencies.resolve() as ExecutableServiceMock)
    }

    func testSingletonRegisterDependency() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        dependencies.singleton(Dependency { _ in ExecutableServiceMock() })

        // THEN
        XCTAssertNoThrow(try dependencies.resolve() as ExecutableServiceMock)
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

    func testSingletonResolveDependency() throws {
        // Given
        // WHEN
        var dependencies = factory().dependencies
        dependencies.singleton(Dependency { _ in LocationMock() })

        // THEN
        XCTAssertNoThrow(try dependencies.resolve() as LocationMock)
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
        let di = DependencyInjector(dependencies: dependencyCore) { () -> [Dependency] in
            return []
        } _: { () -> [Provider] in
            return [Provider { _ in provider }]
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
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(Provider { _ in ProviderMock() })
        dependencies.unregister(ProviderMock.self)
        // THEN
        XCTAssertEqual(dependencies.providersCount, 0)
    }

    func testWillBoot() throws {
        // Given
        let provider = ProviderMock()
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(Provider { _ in provider })

        _ = dependencies.willBoot()

        // THEN
        XCTAssertEqual(provider.invokedWillBootCount, 1)
    }

    func testDidBoot() throws {
        // Given
        let provider = ProviderMock()
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(Provider { _ in provider })

        _ = dependencies.didBoot()

        // THEN
        XCTAssertEqual(provider.invokedDidBootCount, 1)
    }

    func testWillShutdown() throws {
        // Given
        let provider = ProviderMock()
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(Provider { _ in provider })

        _ = dependencies.willShutdown()

        // THEN
        XCTAssertEqual(provider.invokedWillShutdownCount, 1)
    }

    func testDidEnterBackground() throws {
        // Given
        let provider = ProviderMock()
        // WHEN
        var dependencies = factory().dependencies
        dependencies.register(Provider { _ in provider })

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
}
