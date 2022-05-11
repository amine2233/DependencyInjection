//
//  File.swift
//  
//
//  Created by Amine Bensalah on 22/12/2020.
//

import Foundation
// import Combine

protocol LocationService {
    typealias Location = (Double, Double)
    // var location: AnyPublisher<Location, Never> { get }
    func start()
}

class LocationMock: LocationService {

    // private let timer = Timer.publish(every: 1, on: RunLoop.main, in: .default) // 1
    // private let subject = PassthroughSubject<Location, Never>() // 2
    // private var cancellables = Set<AnyCancellable>()

    // var location: AnyPublisher<Location, Never>

    init() {
        // location = subject.eraseToAnyPublisher()
        // timer
        //     .map { _ in
        //         (
        //             Double.random(in: 50..<55),
        //             Double.random(in: 33..<36)
        //         )
        //     }
        //     .subscribe(subject) // 3
        //     .store(in: &cancellables)
    }

    func start() {
        // timer
        //     .connect() // 4
        //     .store(in: &cancellables)
        // debugPrint("Mock Location service has been started")
    }
}
