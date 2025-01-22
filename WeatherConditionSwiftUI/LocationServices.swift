//
//  LocationServices.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import Foundation
import Combine
import CoreLocation
class LocationServices: NSObject, CLLocationManagerDelegate, ObservableObject {
    let locationManager = CLLocationManager()
    @Published var coordinate: CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                return
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let geoLocation = locations.first {
            coordinate = geoLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                 errorMessage = " Failed to get location: \(error.localizedDescription)"
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
                errorMessage = " Location Services Disabled. Please enable Location Services in Settings in order to get location based weather information"
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                return
        }
    }
    
}
