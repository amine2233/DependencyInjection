import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionPropertyWraper

class DependencyInjectionPropertyWraperTests: XCTestCase {
    var dependencyCore: Dependency!

    override func setUpWithError() throws {
        dependencyCore = DependencyCore()
        factory(&dependencyCore)
        factory(&DependencyInjector.default.dependencies)
    }

    override func tearDownWithError() throws {
        dependencyCore = nil
    }

    private func factory(_ dependency: inout Dependency) {
        dependency.register(JourneyService.self, completion: { _,_ in JourneyMock() })
        dependency.register(LocationService.self, completion: { _,_ in LocationMock() })
    }

    // MARK: - Test using @Injection with dependencies

    func testGetInjection() throws {
        // given
        @Injection(dependencies: dependencyCore)
        var journeyService: JourneyService

        // when
        journeyService.start()

        // then
        XCTAssertTrue((journeyService as! JourneyMock).invokedStart)
    }

    func testSetInjection() throws {
        // given
        @Injection(dependencies: dependencyCore)
        var journeyService: JourneyService

        // when
        journeyService.start()
        $journeyService.wrappedValue = JourneyMock()

        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testGetOptionalInjection() throws {
        // given
        @OptionalInjection(dependencies: dependencyCore)
        var journeyService: JourneyService?

        // when
        journeyService?.start()

        // then
        XCTAssertTrue((journeyService as! JourneyMock).invokedStart)
    }

    func testSetOptionalInjection() throws {
        // given
        @OptionalInjection(dependencies: dependencyCore)
        var journeyService: JourneyService?

        // when
        journeyService?.start()
        $journeyService.wrappedValue = nil

        // then
        XCTAssertNil($journeyService.wrappedValue)
    }

    func testGetLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService

        // when
        journeyService.start()

        // then
        XCTAssertTrue((journeyService as! JourneyMock).invokedStart)
    }

    func testSetLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService

        // when
        journeyService.start()
        $journeyService.wrappedValue = JourneyMock()

        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService

        // when
        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testReleasetLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService

        // when
        journeyService.start()
        $journeyService.release()

        // then
        XCTAssertFalse($journeyService.isInitialized)
    }

    func testIsEmptyLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService

        // when
        let expectedResult = $journeyService.isEmpty

        // then
        XCTAssertTrue(expectedResult)
    }

    func testIsNotEmptyLazyInjection() throws {
        // given
        @LazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService

        // when
        journeyService.start()
        let expectedResult = $journeyService.isEmpty

        // then
        XCTAssertFalse(expectedResult)
    }

    func testGetWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService?

        // when
        journeyService?.start()

        // then
        XCTAssertTrue((journeyService as! JourneyMock).invokedStart)
    }

    func testSetWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService?

        // when
        journeyService?.start()
        $journeyService.wrappedValue = JourneyMock()

        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService?

        // when
        // then
        XCTAssertFalse((journeyService as! JourneyMock).invokedStart)
    }

    func testReleasetWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService?

        // when
        journeyService?.start()
        $journeyService.release()

        // then
        XCTAssertFalse($journeyService.isInitialized)
    }

    func testIsEmptyWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService?

        // when
        let expectedResult = $journeyService.isEmpty

        // then
        XCTAssertTrue(expectedResult)
    }

    func testIsNotEmptyWeakLazyInjection() throws {
        // given
        @WeakLazyInjection(dependencies: dependencyCore)
        var journeyService: JourneyService?

        // when
        journeyService?.start()
        let expectedResult = $journeyService.isEmpty

        // then
        XCTAssertFalse(expectedResult)
    }
}
