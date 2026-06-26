import Foundation

protocol CompositeService: Sendable {
    func start()
}

final class CompositeServiceMock: CompositeService, @unchecked Sendable {
    private let journeyService: any JourneyService
    private let executableService: any ExecutableService
    private let locationService: any LocationService

    @Sendable
    init(
        journeyService: any JourneyService,
        executableService: any ExecutableService,
        locationService: any LocationService
    ) {
        self.journeyService = journeyService
        self.executableService = executableService
        self.locationService = locationService
    }

    func start() {}
}
