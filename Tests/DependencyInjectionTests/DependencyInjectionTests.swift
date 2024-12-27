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
            DependencyResolverFactory.build { _ in LocationMock() }
            DependencyResolverFactory.build { _ in JourneyMock() }
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
        dependencies.register(DependencyResolverFactory.build { _ in ExecutableServiceMock() })

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

    func test_Create_Using_Subscript_DependencyKey() throws {
        // GIVEN
        var dependencies = factory().dependencies

        let key = DependencyKey(rawValue: "executable")
        let typeKey = DependencyTypeKey(type: ExecutableServiceMock.self, key: key)

        // WHEN
        dependencies[typeKey] = ExecutableServiceMock()

        // THEN
        XCTAssertEqual(String(describing: ExecutableServiceMock.self).components(separatedBy: ".").last, String(describing: ExecutableServiceMock.self))
    }

    func test_Create_Using_Subscript_DependencyKey_For_Singleton() throws {
        // GIVEN
        var dependencies = factory().dependencies

        // WHEN
        try dependencies.registerSingleton { _ -> (any ExecutableService) in ExecutableServiceMock() }

        // THEN
        XCTAssertNoThrow(try dependencies.resolve((any ExecutableService).self))
    }

    func test_Create_Using_Subscript_DependencyKey_For_SingletonWithService() throws {
        // GIVEN
        var dependencies = factory().dependencies

        // WHEN
        try dependencies.registerSingleton((any ExecutableService).self) { _ -> (any ExecutableService) in ExecutableServiceMock() }

        // THEN
        XCTAssertNoThrow(try dependencies.resolve((any ExecutableService).self))
    }

    func test_Create_Using_Subscript_DependencyKey_For_UnRegisterSingleton() throws {
        // GIVEN
        var dependencies = factory().dependencies
        try dependencies.registerSingleton((any ExecutableService).self) { _ -> (any ExecutableService) in ExecutableServiceMock() }

        // WHEN
        dependencies.unregisterSingleton((any ExecutableService).self)

        // THEN
        XCTAssertThrowsError(try dependencies.resolve((any ExecutableService).self))
    }

    func test_Create_Using_Subscript_DependencyKey_For_UnRegisterSingleton_with_key() throws {
        // GIVEN
        var dependencies = factory().dependencies
        let typeKey = DependencyTypeKey(type: (any ExecutableService).self)
        try dependencies.registerSingleton((any ExecutableService).self) { _ -> (any ExecutableService) in ExecutableServiceMock() }

        // WHEN
        dependencies.unregisterSingleton(typeKey: typeKey)

        // THEN
        XCTAssertThrowsError(try dependencies.resolve((any ExecutableService).self))
    }

    func test_Remove_Using_Subscript_DependencyKey() throws {
        // GIVEN
        var dependencies = factory().dependencies

        let key = DependencyKey(rawValue: "executable")
        let typeKey = DependencyTypeKey(type: ExecutableServiceMock.self, key: key)

        dependencies[typeKey] = ExecutableServiceMock()

        // WHEN
        dependencies[typeKey] = nil as ExecutableServiceMock?

        // THEN
        XCTAssert(dependencies.dependenciesCount == 2)
    }

    func test_Get_Using_Subscript_DependencyKey() throws {
        // GIVEN
        var dependencies = factory().dependencies

        let key = DependencyKey(rawValue: "executable")
        let typeKey = DependencyTypeKey(type: ExecutableServiceMock.self, key: key)

        dependencies[typeKey] = ExecutableServiceMock()

        // WHEN
        let service = dependencies[typeKey] as ExecutableServiceMock?

        // THEN
        XCTAssertNotNil(service)
    }

    func testDescriptionWithProvider() throws {
        // Given
        let provider = ProviderMock()
        provider.stubbedDescription = String(describing: ProviderMock.self)
        // WHEN
        let di = DependencyInjector(
            dependencies: dependencyCore
        ) { () -> [any DependencyResolver] in
            // swiftformat:disable:next redundantReturn
            return []
        } _: { () -> [any Provider] in
            // swiftformat:disable:next redundantReturn
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
        XCTAssertTrue(description.contains("\n- \(DependencyTypeKey(type: LocationMock.self))"))
        XCTAssertTrue(description.contains("\n- \(DependencyTypeKey(type: JourneyMock.self))"))
    }

    func testDescription_with_key() throws {
        // Given
        let key = DependencyKey(rawValue: "location_mock")
        let keyJourney = DependencyKey(rawValue: "journey_mock")
        func factory() -> DependencyInjector {
            DependencyInjector(dependencies: dependencyCore) {
                DependencyResolverFactory.build(
                    typeKey: DependencyTypeKey(type: (any LocationService).self, key: key)
                ) { _ in LocationMock() }
                DependencyResolverFactory.build(
                    typeKey: DependencyTypeKey(type: (any JourneyService).self, key: keyJourney)
                ) { _ in JourneyMock() }
            }
        }
        let dependencies = factory().dependencies
        
        // WHEN
        let description = dependencies.description
        
        // THEN
        XCTAssertTrue(description.contains("\n- \(DependencyTypeKey(type: (any LocationService).self, key: key))"))
        XCTAssertTrue(description.contains("\n- \(DependencyTypeKey(type: (any JourneyService).self, key: keyJourney))"))
    }
    
    func test_description_when_add_singleton() throws {
        // Given
        var dependencies = factory().dependencies

        // WHEN
        try dependencies.registerSingleton(ExecutableServiceMock.self)

        // THEN
        XCTAssertTrue(dependencies.description.contains("\n- \(DependencyTypeKey(type: ExecutableServiceMock.self))"))
    }

    // MARK: Providers Tests

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
}
