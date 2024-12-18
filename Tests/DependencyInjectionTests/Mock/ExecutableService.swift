import DependencyInjection

protocol ExecutableService {
    func exec()
}

final class ExecutableServiceMock: ExecutableService {

    var invokedExec = false
    var invokedExecCount = 0

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
