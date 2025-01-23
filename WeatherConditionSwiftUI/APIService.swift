//
//  APIService.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import Foundation
import Combine
protocol APIServiceProtocol {
    func fetchCurrentWeather(latitude: Double, longitude: Double) -> AnyPublisher<Current, ResultError>
    func fetchWeatherForcast(latitude: Double, longitude: Double) ->  AnyPublisher<Forcast, ResultError>
    func fetchLocationDetail(latitude: Double, longitude: Double) ->  AnyPublisher<LocationDetail, ResultError>
}

enum ResultError: Error {
    case parsing
    case network
    case data
}

class APIService: APIServiceProtocol {
    
    //OpenWeatherAPI
    let apiKey = "77233f733b24946fbf525301e1943a2b"
    let openWeatherAPI = "https://api.openweathermap.org/"
    let currentWeatherPath = "data/2.5/weather?"
    let forcastPath = "data/2.5/forecast?"
    
    //Google API
    let googleAPIKey = "AIzaSyDhFTnk4X-DYmNGGVIryvzA8764DMlcD9Y"
    let googleAPI = "https://maps.googleapis.com/"
    let geoCodePath = "maps/api/geocode/json?"
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) -> AnyPublisher<Current, ResultError> {
        let weatherURL = openWeatherAPI + currentWeatherPath + "lat=\(latitude)&lon=\(longitude)&units=metric&appid=" + apiKey
        
        guard let url = URL(string: weatherURL) else {
            return Fail(error: ResultError.data).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return fetchData(urlRequest: urlRequest)
    }
    
    func fetchWeatherForcast(latitude: Double, longitude: Double) -> AnyPublisher<Forcast, ResultError> {
        let weatherURL = openWeatherAPI + forcastPath + "lat=\(latitude)&lon=\(longitude)&units=metric&appid=" + apiKey
       
        guard let url = URL(string: weatherURL) else {
            return Fail(error: ResultError.data).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return fetchData(urlRequest: urlRequest)
    }
    
    func fetchLocationDetail(latitude: Double, longitude: Double) -> AnyPublisher<LocationDetail, ResultError> {
        let googleURL = googleAPI + geoCodePath + "latlng=\(latitude),\(longitude)&key=" + googleAPIKey
       
        guard let url = URL(string: googleURL) else {
            return Fail(error: ResultError.data).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return fetchData(urlRequest: urlRequest)
    }
    
    private func fetchData<T>(urlRequest: URLRequest)-> AnyPublisher<T, ResultError> where T:Decodable {
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                ResultError.network
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                Just(pair.data)
                  .decode(type: T.self, decoder: JSONDecoder())
                  .mapError { error in
                      ResultError.data
                  }
            }
            .eraseToAnyPublisher()
    }
    
}
