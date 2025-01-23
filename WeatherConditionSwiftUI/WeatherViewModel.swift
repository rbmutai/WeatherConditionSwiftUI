//
//  WeatherViewModel.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import Foundation
import Combine

enum ConditionTheme: String {
    case rain
    case cloud
    case clear
    case none
}

class WeatherViewModel: ObservableObject {
    @Published var city = ""
    @Published var showActivityIndicator = false
    @Published var errorMessage = ""
    @Published var showAlert = false
    @Published var showConfirmAlert = false
    @Published var currentTemperature = ""
    @Published var minimumTemperature = ""
    @Published var maximumTemperature = ""
    @Published var conditions = ""
    @Published var province = ""
    @Published var street = ""
    @Published var lastChecked = ""
    @Published var refreshEnabled = true
    @Published var weatherTheme: ConditionTheme = .none
    @Published var backgroundColor = "Cloudy"
    @Published var backgroundImage = "seaCloudy"
    @Published var forcastDetail: [ForcastDetail] = []
    private var subscribers = Set<AnyCancellable>()
    var latitude = 0.0
    var longitude = 0.0
    let persistence = PersistenceController.shared
    let apiService: APIServiceProtocol
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        loadSavedData()
    }
    
    
    func getCurrentWeather(latitude: Double, longitude: Double) {
        
        showActivityIndicator = true
        refreshEnabled = false
        
        apiService.fetchCurrentWeather(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] value in
                showActivityIndicator = false
                refreshEnabled = true
                switch value {
                case .finished:
                    break
                case .failure(let error):
                    processError(error: error)
                }
                
            } receiveValue: { [unowned self] current in
                
                updateCurrentWeatherDetails(current: current)
                
            }.store(in: &subscribers)



        self.latitude = latitude
        self.longitude = longitude
                
    }
    
    func getWeatherForcast(latitude: Double, longitude: Double) {
        
        showActivityIndicator = true
        refreshEnabled = false
        
        apiService.fetchWeatherForcast(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] value in
                showActivityIndicator = false
                refreshEnabled = true
                switch value {
                case .finished:
                    break
                case .failure(let error):
                    processError(error: error)
                }
            } receiveValue: { [unowned self] forcast in
                
                let forcastDetail = forcast.list
                updateWeatherForcastDetails(forcast: forcastDetail)
                
            }.store(in: &subscribers)
    }
    
    func getLocationDetail(latitude: Double, longitude: Double) {
       
        showActivityIndicator = true
        refreshEnabled = false
        
        apiService.fetchLocationDetail(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] value in
                showActivityIndicator = false
                refreshEnabled = true
                switch value {
                case .finished:
                    break
                case .failure(let error):
                    processError(error: error)
                }
            } receiveValue: { [unowned self] location in
                
                let locationDetail = location.results
                updateLocationDetails(results: locationDetail)
                
            }.store(in: &subscribers)
        
    }
    
    func fetchAllDetails(latitude: Double, longitude: Double) {
        getCurrentWeather(latitude: latitude, longitude: longitude)
        getWeatherForcast(latitude: latitude, longitude: longitude)
        getLocationDetail(latitude: latitude, longitude: longitude)
    }
    
    func processError(error: Error){
        switch error {
            case ResultError.network:
                errorMessage = "Network error"
                showAlert = true
            case ResultError.parsing:
                errorMessage = "Parsing error"
                showAlert = true
            case ResultError.data:
                errorMessage = "Data error"
                showAlert = true
            default:
                errorMessage = "Error: \(error.localizedDescription)"
                showAlert = true
        }
    }
    
    func updateLocationDetails(results: [ResultDetail]) {
        street = ""
        province = ""
        for item in results {
            if item.types.contains("street_address") && street == "" {
               street = item.formattedAddress.components(separatedBy: ",")[0]
            }
            
            if item.types.contains("administrative_area_level_1") && province == "" {
                province = item.formattedAddress
            }
            
            if province != "" && street != "" {
                break
            }
        }
        
        
        persistence.saveCurrentLocation(city: city, street: street, province: province)
    }
    
    func updateCurrentWeatherDetails(current: Current){
        
        currentTemperature = "\(current.main.temp)º"
        minimumTemperature = "\(current.main.tempMin)º"
        maximumTemperature = "\(current.main.tempMax)º"
        conditions = current.weather[0].description.uppercased()
        weatherTheme = getWeatherTheme(conditions: conditions.lowercased())
        let backgroundDetail = getWeatherBackground(theme: weatherTheme)
        backgroundColor = backgroundDetail.colorName
        backgroundImage = backgroundDetail.imageName
        city = current.name ?? ""
        lastChecked = Date().formatted(date: .abbreviated, time: .shortened)
        persistence.saveCurrentWeather(currentTemperature: currentTemperature, maximumTemperature: maximumTemperature, minimumTemperature: minimumTemperature, conditions: conditions.lowercased())
    }
    
    func updateWeatherForcastDetails(forcast:[Current]){
        forcastDetail = []
        var previousDay = ""
        
        for item in forcast {
             let dayOfWeek = getDayOfWeek(timeStamp: Double(item.dt))
             let theme = getWeatherTheme(conditions: item.weather[0].description)
             let temperature = "\(item.main.temp)º"
            
             if previousDay != dayOfWeek {
                 let forcastItem = ForcastDetail(day: dayOfWeek, theme: theme, temperature: temperature)
                 forcastDetail.append(forcastItem)
                 previousDay = dayOfWeek
             }
        }
        
        persistence.saveWeatherForcast(forcast: forcastDetail)
    }
    
    func loadSavedData() {
        
        if let currentWeather = persistence.getCurrentWeather() {
            if currentTemperature == "" {
                currentTemperature = currentWeather.currentTemperature
            }
            if maximumTemperature == "" {
                maximumTemperature = currentWeather.maximumTemperature
            }
            if minimumTemperature == "" {
                minimumTemperature = currentWeather.minimumTemperature
            }
            if conditions == "" {
                conditions = currentWeather.conditions.uppercased()
            }
            if lastChecked == "" {
                lastChecked = currentWeather.createdOn.formatted(date: .abbreviated, time: .shortened)
            }
            if weatherTheme == .none {
                weatherTheme = getWeatherTheme(conditions: currentWeather.conditions)
            }
        }
        
        let forcast = persistence.getWeatherForcast()
        
        if forcastDetail.count == 0 && forcast.count > 0 {
            forcastDetail = forcast
        }
        
        if let currentLocation = persistence.getCurrentLocation() {
            if city == "" {
                city = currentLocation.city
            }
            if street == "" {
                street =  currentLocation.street
            }
            if province == "" {
                province = currentLocation.province
            }
        }
        
    }
    func confirmLocation() {
        errorMessage = "Save \(city) to favourites?"
        showConfirmAlert = true
    }
    func saveLocation() {
        if latitude != 0.0 && longitude != 0.0 {
            persistence.saveFavouriteLocation(city: city, street: street, province: province, latitude: latitude, longitude: longitude)
        }
    }
    
    func getDayOfWeek(timeStamp: Double)-> (String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let currentDate = Date(timeIntervalSince1970: timeStamp)
        
        return dateFormatter.string(from: currentDate)
        
    }
    
    func getWeatherTheme(conditions: String) -> ConditionTheme {
        if conditions.contains("cloud") {
            return .cloud
        } else if conditions.contains("rain") || conditions.contains("drizzle") || conditions.contains("snow") {
            return .rain
        } else if conditions.contains("clear") {
            return .clear
        } else {
            return .rain
        }
    }
    
    func getWeatherIcon(theme: ConditionTheme)-> String {
        switch theme {
        case .cloud:
            return "partlySunny"
        case .rain:
            return "rain"
        case .clear:
            return "clear"
        case .none:
            return "clear"
        }
    }
    
    func getWeatherBackground(theme: ConditionTheme)-> (imageName: String, colorName: String) {
        switch theme {
        case .cloud:
            return ("seaCloudy", "Cloudy")
        case .rain:
            return ("seaRainy","Rainy")
        case .clear:
            return ("seaSunny","Sunny")
        case .none:
            return ("clear","None")
        }
    }
    
    
}
