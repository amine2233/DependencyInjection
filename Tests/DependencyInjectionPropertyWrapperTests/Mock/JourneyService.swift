import Foundation

protocol JourneyService: Sendable {
    func start()
}

class JourneyMock: JourneyService, @unchecked Sendable {
    var invokedStart = false
    var invokedStartCount = 0

    func start() {
        invokedStart = true
        invokedStartCount += 1
    }
}
