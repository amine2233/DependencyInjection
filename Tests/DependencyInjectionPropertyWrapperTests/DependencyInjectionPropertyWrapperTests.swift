import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionPropertyWrapper

class DependencyInjectionPropertyWrapperTests: XCTestCase {
    var dependencyCore: (any Dependency)!

    override func setUpWithError() throws {
        dependencyCore = DependencyCore()
        factory(&dependencyCore)
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    private func factory(_ dependency: inout any Dependency) {
        dependency.register((any JourneyService).self, completion: { _ in JourneyMock() })
        dependency.register((any LocationService).self, completion: { _ in LocationMock() })
    }

    // MARK: - Test using @Injection with dependencies

    func testGetInjection() throws {
        // given
        @Injection(dependencies: dependencyCore)
        var journeyService: any JourneyService

        // when
        journeyService.start()

        // then
        XCTAssertTrue((journeyService as! JourneyMock).invokedStart)
    }

    func testSetInjection() throws {
        // given
        @Injection(dependencies: dependencyCore)
        var journeyService: any JourneyService

        // when
        journeyService.start()
        $journeyService.wrappedValue = JourneyMock()

        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testGetOptionalInjection() throws {
        // given
        @OptionalInjection(dependencies: dependencyCore)
        var journeyService: (any JourneyService)?

        // when
        journeyService?.start()

        // then
        XCTAssertTrue((journeyService as! JourneyMock).invokedStart)
    }

    func testSetOptionalInjection() throws {
        // given
        @OptionalInjection(dependencies: dependencyCore)
        var journeyService: (any JourneyService)?

        // when
        journeyService?.start()
        $journeyService.wrappedValue = nil

        // then
        XCTAssertNil($journeyService.wrappedValue)
    }

    func testGetLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: any JourneyService

        // when
        journeyService.start()

        // then
        XCTAssertTrue((journeyService as! JourneyMock).invokedStart)
    }

    func testSetLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: any JourneyService

        // when
        journeyService.start()
        $journeyService.wrappedValue = JourneyMock()

        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: any JourneyService

        // when
        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testReleasetLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: any JourneyService

        // when
        journeyService.start()
        $journeyService.release()

        // then
        XCTAssertFalse($journeyService.isInitialized)
    }

    func testIsEmptyLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: any JourneyService

        // when
        let expectedResult = $journeyService.isEmpty

        // then
        XCTAssertTrue(expectedResult)
    }

    func testIsNotEmptyLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: any JourneyService

        // when
        journeyService.start()
        let expectedResult = $journeyService.isEmpty

        // then
        XCTAssertFalse(expectedResult)
    }

    func testGetWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: (any JourneyService)?

        // when
        journeyService?.start()

        // then
        XCTAssertTrue((journeyService as! JourneyMock).invokedStart)
    }

    func testSetWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: (any JourneyService)?

        // when
        journeyService?.start()
        $journeyService.wrappedValue = JourneyMock()

        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: (any JourneyService)?

        // when
        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testReleasetWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: (any JourneyService)?

        // when
        journeyService?.start()
        $journeyService.release()

        // then
        XCTAssertFalse($journeyService.isInitialized)
    }

    func testIsEmptyWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: (any JourneyService)?

        // when
        let expectedResult = $journeyService.isEmpty

        // then
        XCTAssertTrue(expectedResult)
    }

    func testIsNotEmptyWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: (any JourneyService)?

        // when
        journeyService?.start()
        let expectedResult = $journeyService.isEmpty

        // then
        XCTAssertFalse(expectedResult)
    }

    // MARK: PropertyWrapper using key

    func testGetInjectionUsingKey() throws {
        // given
        let key = DependencyKey(rawValue: "execution")
        let typeKey = DependencyTypeKey(type: ExecutableServiceMock.self, key: key)

        dependencyCore[typeKey] = ExecutableServiceMock()

        @InjectionKey(key, dependencies: dependencyCore)
        var executionService: ExecutableServiceMock

        // when
        executionService.exec()

        // then
        XCTAssertTrue(executionService.invokedExec)
    }

    func testSetInjectionUsingKey() throws {
        // given
        let key = DependencyKey(rawValue: "execution")
        @InjectionKey(key, dependencies: dependencyCore)
        var executionService: ExecutableServiceMock

        // when
        $executionService.wrappedValue = ExecutableServiceMock()
        executionService.exec()

        // then
        XCTAssertTrue(executionService.invokedExec)
    }

    func testGetOptionalInjectionUsingKey() throws {
        // given
        let key = DependencyKey(rawValue: "execution")
        let typeKey = DependencyTypeKey(type: ExecutableServiceMock.self, key: key)

        dependencyCore[typeKey] = ExecutableServiceMock()

        @OptionalInjectionKey(key, dependencies: dependencyCore)
        var executionService: ExecutableServiceMock?

        // when
        executionService?.exec()

        // then
        XCTAssertNotNil(executionService)
    }

    func testGetOptionalInjectionUsingKey_NilValue() throws {
        // given
        let key = DependencyKey(rawValue: "execution")

        @OptionalInjectionKey(key, dependencies: dependencyCore)
        var executionService: ExecutableServiceMock?

        // when
        executionService?.exec()

        // then
        XCTAssertNil(executionService)
    }

    func testSetOptionalInjectionUsingKey() throws {
        // given
        let key = DependencyKey(rawValue: "execution")
        @OptionalInjectionKey(key, dependencies: dependencyCore)
        var executionService: ExecutableServiceMock?

        // when
        $executionService.wrappedValue = ExecutableServiceMock()
        executionService?.exec()

        // then
        XCTAssertNotNil(executionService)
    }
}
