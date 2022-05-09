import Foundation

protocol JourneyService {
    func start()
}

class JourneyMock: JourneyService {

    var invokedStart = false
    var invokedStartCount = 0

    func start() {
        invokedStart = true
        invokedStartCount += 1
    }
}
