//
//  WeatherView.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @ObservedObject var locationService: LocationServices
    var body: some View {
        ScrollView {
            VStack {
                Text("Weather Conditions")
                    .onChange(of: locationService.coordinate) { _ , _ in
                        Task {
                            await  viewModel.getWeather(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                            
                            await  viewModel.getLocationDetail(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                        }
                    }
                
                
                
            }
        }.onAppear {
            viewModel.loadSavedData()
        }
        .alert("Alert", isPresented: $locationService.showErrorAlert, actions: {
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text(locationService.errorMessage)
        })
        
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(apiService: MockAPIService()), locationService: LocationServices())
}
