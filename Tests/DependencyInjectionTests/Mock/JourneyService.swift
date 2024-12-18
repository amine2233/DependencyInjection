import Foundation

protocol JourneyService: Sendable {
    func start()
}

final class JourneyMock: JourneyService {
    func start() {
        debugPrint("Mock Journey service has been started!")
    }
}
