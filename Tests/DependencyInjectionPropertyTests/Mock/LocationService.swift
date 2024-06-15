//
//  File.swift
//  
//
//  Created by Amine Bensalah on 22/12/2020.
//

import Foundation
// import Combine

protocol LocationService {
    var value: String { get }
    typealias Location = (Double, Double)
    // var location: AnyPublisher<Location, Never> { get }
    func start()
}

final class LocationMock: LocationService {

    init(stubbedValue: String) {
        self.stubbedValue = stubbedValue
    }
    
    var invokedValueGetter = false
    var invokedValueGetterCount = 0
    var stubbedValue: String! = ""

    var value: String {
        invokedValueGetter = true
        invokedValueGetterCount += 1
        return stubbedValue
    }

    var invokedStart = false
    var invokedStartCount = 0

    func start() {
        invokedStart = true
        invokedStartCount += 1
    }
}
