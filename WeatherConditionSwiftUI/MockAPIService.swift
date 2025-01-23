//
//  MockAPIService.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import Foundation
import Combine
class MockAPIService: APIServiceProtocol {
    func fetchCurrentWeather(latitude: Double, longitude: Double) -> AnyPublisher<Current, ResultError> {
        
        guard let bundleUrl = Bundle.main.url(forResource: "CurrentWeather", withExtension: "json") else {
            return Fail(error: ResultError.data).eraseToAnyPublisher()
        }
        
        do {
            let data = try Data(contentsOf: bundleUrl)
            
            return fetchData(data: data)
            
        } catch {
            return Fail(error: ResultError.parsing).eraseToAnyPublisher()
        }
    }
    
    func fetchWeatherForcast(latitude: Double, longitude: Double) -> AnyPublisher<Forcast, ResultError> {
        guard let bundleUrl = Bundle.main.url(forResource: "ForcastWeather", withExtension: "json") else {
            return Fail(error: ResultError.data).eraseToAnyPublisher()
        }
        
        do {
            let data = try Data(contentsOf: bundleUrl)
            
            return fetchData(data: data)
            
        } catch {
            return Fail(error: ResultError.parsing).eraseToAnyPublisher()
        }
    }
    
    func fetchLocationDetail(latitude: Double, longitude: Double) -> AnyPublisher<LocationDetail, ResultError> {
        
        guard let bundleUrl = Bundle.main.url(forResource: "LocationDetailData", withExtension: "json") else {
            return Fail(error: ResultError.data).eraseToAnyPublisher()
        }
        
        do {
            let data = try Data(contentsOf: bundleUrl)
            
            return fetchData(data: data)
            
        } catch {
            return Fail(error: ResultError.parsing).eraseToAnyPublisher()
        }
    }
    
    private func fetchData<T>(data: Data)-> AnyPublisher<T, ResultError> where T:Decodable {
        
        return  Just(data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                ResultError.data
            }
            .eraseToAnyPublisher()
    }
    
}
