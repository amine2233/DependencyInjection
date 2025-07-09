import XCTest
@testable import DependencyInjection

class DependencyCheckTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the
        // class.
    }

    func testDependencyInjection_check_success() throws {
        // given
        final class ObjectA: Sendable {
            let objectB: ObjectB

            init(objectB: ObjectB) {
                self.objectB = objectB
            }
        }

        final class ObjectB: Sendable {
            let objectC: ObjectC

            init(objectC: ObjectC) {
                self.objectC = objectC
            }
        }

        final class ObjectC: Sendable {}

        struct DependencyRegisteringGraphTest: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(ObjectC.self) { _ in
                    ObjectC()
                }
                dependencies.register(ObjectB.self) { dependencies in
                    try ObjectB(objectC: dependencies.resolve())
                }
                dependencies.register(ObjectA.self) { dependencies in
                    try ObjectA(objectB: dependencies.resolve())
                }
            }
        }

        // when
        let injector = DependencyInjector(register: DependencyRegisteringGraphTest.self)

        // then
        XCTAssertNoThrow(try injector.dependencies.check())
    }

    func testDependencyInjection_check_fail() throws {
        // given
        final class ObjectA2: Sendable {
            let objectB2: ObjectB2

            init(objectB2: ObjectB2) {
                self.objectB2 = objectB2
            }
        }

        final class ObjectB2: Sendable {
            let objectA2: ObjectA2

            init(objectA2: ObjectA2) {
                self.objectA2 = objectA2
            }
        }

        struct DependencyRegisteringGraphFailTest: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(ObjectB2.self) { dependencies in
                    try ObjectB2(objectA2: dependencies.resolve())
                }
                dependencies.register(ObjectA2.self) { dependencies in
                    try ObjectA2(objectB2: dependencies.resolve())
                }
            }
        }

        // when
        let injector = DependencyInjector(register: DependencyRegisteringGraphFailTest.self)

        // then
        XCTAssertThrowsError(try injector.dependencies.check(), "Circular dependency detected")
    }

    func testDependencyInjection_check_fail_2() throws {
        // given
        final class ObjectA3: Sendable {
            let objectB3: ObjectB3

            init(objectB3: ObjectB3) {
                self.objectB3 = objectB3
            }
        }

        final class ObjectB3: Sendable {
            let objectC3: ObjectC3

            init(objectC3: ObjectC3) {
                self.objectC3 = objectC3
            }
        }

        final class ObjectC3: Sendable {
            let objectA3: ObjectA3

            init(objectA3: ObjectA3) {
                self.objectA3 = objectA3
            }
        }

        struct DependencyRegisteringGraphFail2Test: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(ObjectC3.self) { dependencies in
                    try ObjectC3(objectA3: dependencies.resolve())
                }
                dependencies.register(ObjectB3.self) { dependencies in
                    try ObjectB3(objectC3: dependencies.resolve())
                }
                dependencies.register(ObjectA3.self) { dependencies in
                    try ObjectA3(objectB3: dependencies.resolve())
                }
            }
        }

        // when
        let injector = DependencyInjector(register: DependencyRegisteringGraphFail2Test.self)

        // then
        XCTAssertThrowsError(try injector.dependencies.check(), "Circular dependency detected")
    }
}
