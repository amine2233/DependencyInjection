import Foundation

protocol JourneyService {
    func start()
}

class JourneyMock: JourneyService {
    func start() {
        debugPrint("Mock Journey service has been started!")
    }
}
