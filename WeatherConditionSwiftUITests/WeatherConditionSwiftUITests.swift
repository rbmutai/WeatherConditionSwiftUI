//
//  WeatherConditionSwiftUITests.swift
//  WeatherConditionSwiftUITests
//
//  Created by Robert Mutai on 22/01/2025.
//

import XCTest
import Combine
@testable import WeatherConditionSwiftUI

final class WeatherConditionSwiftUITests: XCTestCase {
    private var subscribers = Set<AnyCancellable>()
    func testGetCurrentWeather()  {
       
        let viewModel = WeatherViewModel(apiService: MockAPIService())
       
        viewModel.getCurrentWeather(latitude: -1.3033, longitude: 36.8264)
        
        let cityExpectation = expectation(description: "city")
        viewModel.$city
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "Nairobi South")
                cityExpectation.fulfill()
               
            })
            .store(in: &subscribers)
       
        let conditionsExpectation = expectation(description: "condition")
        viewModel.$conditions
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "BROKEN CLOUDS")
                conditionsExpectation.fulfill()
               
            })
            .store(in: &subscribers)
        
        
        let currentTemperatureExpectation = expectation(description: "currentTemperature")
        viewModel.$currentTemperature
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "27.05º")
                currentTemperatureExpectation.fulfill()
            })
            .store(in: &subscribers)
        
        let maximumTemperatureExpectation = expectation(description: "maximumTemperature")
        viewModel.$maximumTemperature
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "27.05º")
                maximumTemperatureExpectation.fulfill()
               
            })
            .store(in: &subscribers)
        
        let minimumTemperatureExpectation = expectation(description: "minimumTemperature")
        viewModel.$minimumTemperature
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "27.05º")
                minimumTemperatureExpectation.fulfill()
            })
            .store(in: &subscribers)
        
        let weatherThemeExpectation = expectation(description: "weatherTheme")
        viewModel.$weatherTheme
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, .cloud)
                weatherThemeExpectation.fulfill()
            })
            .store(in: &subscribers)
        
        wait(for: [cityExpectation,
                   conditionsExpectation,
                   currentTemperatureExpectation,
                   maximumTemperatureExpectation,
                   minimumTemperatureExpectation,
                   weatherThemeExpectation],timeout: 10)
       
    }
    func testGetWeatherForcast()  {
        let viewModel = WeatherViewModel(apiService: MockAPIService())
      
        viewModel.getWeatherForcast(latitude: -1.3033, longitude: 36.8264)
        
        let forcastExpectation = expectation(description: "forcast")
        
        viewModel.$forcastDetail
            .drop(while: { value in
                value.count < 6
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value[0].day, "Monday")
                XCTAssertEqual(value[0].temperature, "27.05º")
                XCTAssertEqual(value[0].theme, .cloud)
                forcastExpectation.fulfill()
            })
            .store(in: &subscribers)
        
       wait(for: [forcastExpectation],timeout: 10)
    }
    
    func testGetLocationDetails()  {
        let viewModel = WeatherViewModel(apiService: MockAPIService())
        
        viewModel.getLocationDetail(latitude: -1.3033, longitude: 36.8264)
        
        let streetExpectation = expectation(description: "street")
        viewModel.$street
            .drop(while: { value in
                value.isEmpty
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "35 Baricho Rd")
                streetExpectation.fulfill()
               
            })
            .store(in: &subscribers)
        
        let provinceExpectation = expectation(description: "province")
        viewModel.$province
            .drop(while: { value in
                value.isEmpty
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "Nairobi County, Kenya")
                provinceExpectation.fulfill()
            })
            .store(in: &subscribers)
        
        wait(for: [streetExpectation,provinceExpectation],timeout: 10)
        
    }

}
