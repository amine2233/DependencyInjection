import Foundation

// import Combine

protocol LocationService {
    func start()
}

class LocationServiceMock: LocationService {
    private let executableService: any ExecutableService
    private let journeyService: any JourneyService

    init(executableService: any ExecutableService, journeyService: any JourneyService) {
        self.executableService = executableService
        self.journeyService = journeyService
    }

    func start() {}
}
