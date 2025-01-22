//
//  WeatherConditionSwiftUITests.swift
//  WeatherConditionSwiftUITests
//
//  Created by Robert Mutai on 22/01/2025.
//

import XCTest
@testable import WeatherConditionSwiftUI

final class WeatherConditionSwiftUITests: XCTestCase {

    func testGetWeather() async {
        let viewModel = WeatherViewModel(apiService: MockAPIService())
       
        await viewModel.getWeather(latitude: -1.3033, longitude: 36.8264)
       
        XCTAssertEqual(viewModel.city, "Nairobi South")
        XCTAssertEqual(viewModel.conditions, "BROKEN CLOUDS")
        XCTAssertEqual(viewModel.currentTemperature, "27.05º")
        XCTAssertEqual(viewModel.maximumTemperature, "27.05º")
        XCTAssertEqual(viewModel.minimumTemperature, "27.05º")
        XCTAssertEqual(viewModel.weatherTheme, .cloud)
        XCTAssertEqual(viewModel.forcastDetail[0].day, "Monday")
        XCTAssertEqual(viewModel.forcastDetail[0].temperature, "27.05º")
        XCTAssertEqual(viewModel.forcastDetail[0].theme, .cloud)
       
    }
    
    func testGetLocationDetails() async {
        let viewModel = WeatherViewModel(apiService: MockAPIService())
       
        await viewModel.getLocationDetail(latitude: -1.3033, longitude: 36.8264)
        
        XCTAssertEqual(viewModel.street, "35 Baricho Rd")
        XCTAssertEqual(viewModel.province, "Nairobi County, Kenya")
        
    }

}
