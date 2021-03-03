//
//  NewWeatherAppTests.swift
//  NewWeatherAppTests
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import XCTest
@testable import NewWeatherApp

class NewWeatherAppTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    
    }

    func testPerformanceExample() {
       self.measure {
           
        }
    }

    
    func testFetchWeatherDataFromServer() {
        let service = WeatherService()
        let promise = expectation(description: "Get Request")
        service.fetchWeatherDataFromServer(city: "London") { (response, error) in
            XCTAssertTrue(response?.name == "London")
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
