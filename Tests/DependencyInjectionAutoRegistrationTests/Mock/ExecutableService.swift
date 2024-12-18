import DependencyInjection

protocol ExecutableService: Sendable {
    func exec()
}

final class ExecutableServiceMock: ExecutableService, @unchecked Sendable {
    var invokedExec = false
    var invokedExecCount = 0
    
    @Sendable
    init() {}

    func exec() {
        invokedExec = true
        invokedExecCount += 1
    }
}

extension ExecutableServiceMock: DependencyServiceType {
    static func makeService(for container: any Dependency) throws -> ExecutableServiceMock {
        ExecutableServiceMock()
    }
}
