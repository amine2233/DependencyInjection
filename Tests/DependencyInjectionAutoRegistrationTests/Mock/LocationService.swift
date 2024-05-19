//
//  LocationServiceMock.swift
//
//
//  Created by Amine Bensalah on 22/12/2020.
//

import Foundation
// import Combine

protocol LocationService {
    func start()
}

class LocationServiceMock: LocationService {
    
    private let executableService: ExecutableService
    private let journeyService: JourneyService

    init(executableService: ExecutableService, journeyService: JourneyService) {
        self.executableService = executableService
        self.journeyService = journeyService
    }

    func start() {
    }
}
