import Foundation

// import Combine

protocol LocationService: Sendable {
    func start()
}

class LocationServiceMock: LocationService, @unchecked Sendable {
    private let executableService: any ExecutableService
    private let journeyService: any JourneyService

    @Sendable
    init(executableService: any ExecutableService, journeyService: any JourneyService) {
        self.executableService = executableService
        self.journeyService = journeyService
    }

    func start() {}
}
