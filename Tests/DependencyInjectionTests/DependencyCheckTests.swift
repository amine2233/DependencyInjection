import Testing
@testable import DependencyInjection

@Suite("Cyclic dependency detection")
struct DependencyCheckTests {
    // MARK: - Acyclic graphs pass

    @Test("A linear acyclic graph (A -> B -> C) does not throw")
    func linearGraphSucceeds() throws {
        final class ObjectA: Sendable {
            let objectB: ObjectB
            init(objectB: ObjectB) { self.objectB = objectB }
        }
        final class ObjectB: Sendable {
            let objectC: ObjectC
            init(objectC: ObjectC) { self.objectC = objectC }
        }
        final class ObjectC: Sendable {}

        struct Registering: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(ObjectC.self) { _ in ObjectC() }
                dependencies.register(ObjectB.self) { try ObjectB(objectC: $0.resolve()) }
                dependencies.register(ObjectA.self) { try ObjectA(objectB: $0.resolve()) }
            }
        }

        let injector = DependencyInjector(register: Registering.self)
        #expect(throws: Never.self) { try injector.dependencies.check() }
    }

    // MARK: - Cycles are detected

    @Test("A two-node cycle (A <-> B) throws .cyclicDependency")
    func twoNodeCycleThrows() throws {
        final class ObjectA: Sendable {
            let objectB: ObjectB
            init(objectB: ObjectB) { self.objectB = objectB }
        }
        final class ObjectB: Sendable {
            let objectA: ObjectA
            init(objectA: ObjectA) { self.objectA = objectA }
        }

        struct Registering: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(ObjectB.self) { try ObjectB(objectA: $0.resolve()) }
                dependencies.register(ObjectA.self) { try ObjectA(objectB: $0.resolve()) }
            }
        }

        let injector = DependencyInjector(register: Registering.self)
        #expect(throws: DependencyError.self) { try injector.dependencies.check() }
    }

    @Test("A three-node cycle (A -> B -> C -> A) throws .cyclicDependency")
    func threeNodeCycleThrows() throws {
        final class ObjectA: Sendable {
            let objectB: ObjectB
            init(objectB: ObjectB) { self.objectB = objectB }
        }
        final class ObjectB: Sendable {
            let objectC: ObjectC
            init(objectC: ObjectC) { self.objectC = objectC }
        }
        final class ObjectC: Sendable {
            let objectA: ObjectA
            init(objectA: ObjectA) { self.objectA = objectA }
        }

        struct Registering: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(ObjectC.self) { try ObjectC(objectA: $0.resolve()) }
                dependencies.register(ObjectB.self) { try ObjectB(objectC: $0.resolve()) }
                dependencies.register(ObjectA.self) { try ObjectA(objectB: $0.resolve()) }
            }
        }

        let injector = DependencyInjector(register: Registering.self)
        #expect(throws: DependencyError.self) { try injector.dependencies.check() }
    }

    @Test("A self-cycle (A -> A) throws .cyclicDependency")
    func selfCycleThrows() throws {
        final class ObjectA: Sendable {
            let other: ObjectA?
            init(other: ObjectA?) { self.other = other }
        }

        struct Registering: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(ObjectA.self) { try ObjectA(other: $0.resolve(ObjectA.self)) }
            }
        }

        let injector = DependencyInjector(register: Registering.self)
        #expect(throws: DependencyError.self) { try injector.dependencies.check() }
    }

    // MARK: - Regressions vs the old reflection approach

    @Test("Protocol-typed dependencies in a cycle are detected (reflection missed these)")
    func protocolTypedCycleThrows() throws {
        // Registered and resolved by their existential type. The old reflection-based check derived
        // edges from stored-property type names ("any ServiceB"), which never matched the key
        // ("ServiceB"), so the edge was dropped and the cycle was missed. Recording real resolve()
        // calls captures it correctly.
        let injector = DependencyInjector(register: ProtocolCycleRegistering.self)
        #expect(throws: DependencyError.self) { try injector.dependencies.check() }
    }

    @Test("Optional dependencies in a cycle are detected (reflection missed these)")
    func optionalTypedCycleThrows() throws {
        // A stored `NodeY?` reflects as "Optional<NodeY>", which never matched the key "NodeY".
        final class NodeX: Sendable {
            let y: NodeY?
            init(y: NodeY?) { self.y = y }
        }
        final class NodeY: Sendable {
            let x: NodeX?
            init(x: NodeX?) { self.x = x }
        }

        struct Registering: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(NodeX.self) { NodeX(y: try? $0.resolve(NodeY.self)) }
                dependencies.register(NodeY.self) { NodeY(x: try? $0.resolve(NodeX.self)) }
            }
        }

        let injector = DependencyInjector(register: Registering.self)
        #expect(throws: DependencyError.self) { try injector.dependencies.check() }
    }

    @Test("Scalar stored properties do not create false edges")
    func scalarPropertiesAreNotEdges() throws {
        // A service holding scalar config (String/Int) resolves nothing, so it must not be reported
        // as part of any cycle.
        final class ConfigService: Sendable {
            let name: String
            let count: Int
            init(name: String, count: Int) {
                self.name = name
                self.count = count
            }
        }

        struct Registering: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(ConfigService.self) { _ in ConfigService(name: "service", count: 3) }
            }
        }

        let injector = DependencyInjector(register: Registering.self)
        #expect(throws: Never.self) { try injector.dependencies.check() }
    }

    // MARK: - Reported cycle content

    @Test("The thrown error reports the keys participating in the cycle")
    func cyclicErrorReportsParticipatingKeys() throws {
        final class ObjectA: Sendable {
            let objectB: ObjectB
            init(objectB: ObjectB) { self.objectB = objectB }
        }
        final class ObjectB: Sendable {
            let objectA: ObjectA
            init(objectA: ObjectA) { self.objectA = objectA }
        }

        struct Registering: DependencyRegistering {
            static func registerAllServices(in dependencies: inout any Dependency) {
                dependencies.register(ObjectB.self) { try ObjectB(objectA: $0.resolve()) }
                dependencies.register(ObjectA.self) { try ObjectA(objectB: $0.resolve()) }
            }
        }

        let injector = DependencyInjector(register: Registering.self)

        do {
            try injector.dependencies.check()
            Issue.record("Expected a cyclic dependency error, but check() succeeded")
        } catch let DependencyError.cyclicDependency(paths) {
            let keys = Set(paths.flatMap { $0 })
            #expect(keys.contains(DependencyKey(type: ObjectA.self)))
            #expect(keys.contains(DependencyKey(type: ObjectB.self)))
        }
    }

    // MARK: - The container is not mutated by a check

    @Test("Running check() does not mutate the container or rebuild singletons")
    func checkDoesNotMutateContainer() throws {
        final class Box: Sendable {}

        var container = DependencyCore()
        try container.registerSingleton(Box.self) { _ in Box() }

        let countBefore = container.dependenciesCount
        let instanceBefore: Box = try container.resolve(Box.self)

        try container.check()

        #expect(container.dependenciesCount == countBefore)
        let instanceAfter: Box = try container.resolve(Box.self)
        // The singleton was registered before the check and must be the same instance afterwards.
        #expect(instanceBefore === instanceAfter)
    }
}

// MARK: - Fixtures for the protocol-typed cycle

private protocol ServiceA: Sendable {}
private protocol ServiceB: Sendable {}

private final class ServiceADefault: ServiceA {
    let b: any ServiceB
    init(b: any ServiceB) { self.b = b }
}

private final class ServiceBDefault: ServiceB {
    let a: any ServiceA
    init(a: any ServiceA) { self.a = a }
}

private struct ProtocolCycleRegistering: DependencyRegistering {
    static func registerAllServices(in dependencies: inout any Dependency) {
        dependencies.register((any ServiceA).self) { ServiceADefault(b: try $0.resolve((any ServiceB).self)) }
        dependencies.register((any ServiceB).self) { ServiceBDefault(a: try $0.resolve((any ServiceA).self)) }
    }
}
