import Foundation

// import Combine

protocol LocationService: Sendable {
    typealias Location = (Double, Double)
    // var location: AnyPublisher<Location, Never> { get }
    func start()
}

final class LocationMock: LocationService {
    init() {}

    func start() {}
}

final class LocationAppleAPI: LocationService {
    init() {}

    func start() {}
}

final class LocationDefault: LocationService {
    init() {}

    func start() {}
}
