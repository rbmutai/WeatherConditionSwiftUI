//
//  APIService.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> Current
    func fetchWeatherForcast(latitude: Double, longitude: Double) async throws -> [Current]
    func fetchLocationDetail(latitude: Double, longitude: Double) async throws -> [ResultDetail]
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
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> Current {
        let weatherURL = openWeatherAPI + currentWeatherPath + "lat=\(latitude)&lon=\(longitude)&units=metric&appid=" + apiKey
        
        guard let url = URL(string: weatherURL) else {
            throw ResultError.data
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) =  try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        let weather = try decoder.decode(Current.self, from: data)
        
        return weather
    }
    
    func fetchWeatherForcast(latitude: Double, longitude: Double) async throws -> [Current] {
        let weatherURL = openWeatherAPI + forcastPath + "lat=\(latitude)&lon=\(longitude)&units=metric&appid=" + apiKey
       
        guard let url = URL(string: weatherURL) else {
            throw ResultError.data
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) =  try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        let weather = try decoder.decode(Forcast.self, from: data)
        let forcast = weather.list
        
        return forcast
    }
    
    func fetchLocationDetail(latitude: Double, longitude: Double) async throws -> [ResultDetail] {
        let googleURL = googleAPI + geoCodePath + "latlng=\(latitude),\(longitude)&key=" + googleAPIKey
       
        guard let url = URL(string: googleURL) else {
            throw ResultError.data
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) =  try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        let locationDetail = try decoder.decode(LocationDetail.self, from: data)
        
        return locationDetail.results
    }
    
    
}
