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
        
        viewModel.$city
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "Nairobi South")
               
            })
            .store(in: &subscribers)
        
        viewModel.$conditions
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "BROKEN CLOUDS")
               
            })
            .store(in: &subscribers)
        
        viewModel.$currentTemperature
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "27.05º")
               
            })
            .store(in: &subscribers)
        
        viewModel.$maximumTemperature
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "27.05º")
               
            })
            .store(in: &subscribers)
        
        viewModel.$minimumTemperature
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "27.05º")
               
            })
            .store(in: &subscribers)
        
        viewModel.$weatherTheme
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, .cloud)
               
            })
            .store(in: &subscribers)
       
    }
    func testGetWeatherForcast()  {
        let viewModel = WeatherViewModel(apiService: MockAPIService())
      
        viewModel.getWeatherForcast(latitude: -1.3033, longitude: 36.8264)
        
        viewModel.$forcastDetail
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value[0].day, "Monday")
                XCTAssertEqual(value[0].temperature, "27.05º")
                XCTAssertEqual(value[0].theme, .cloud)
            })
            .store(in: &subscribers)
       
    }
    
    func testGetLocationDetails()  {
        let viewModel = WeatherViewModel(apiService: MockAPIService())
        
        viewModel.getLocationDetail(latitude: -1.3033, longitude: 36.8264)
        
        viewModel.$street
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "35 Baricho Rd")
               
            })
            .store(in: &subscribers)
        
        viewModel.$province
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                XCTAssertEqual(value, "Nairobi County, Kenya")
               
            })
            .store(in: &subscribers)
        
    }

}
