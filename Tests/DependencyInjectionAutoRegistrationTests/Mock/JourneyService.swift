import Foundation

protocol JourneyService: Sendable {
    func start()
}

final class JourneyMock: JourneyService, @unchecked Sendable {
    var invokedStart = false
    var invokedStartCount = 0
    
    @Sendable
    init() {}

    func start() {
        invokedStart = true
        invokedStartCount += 1
    }
}
