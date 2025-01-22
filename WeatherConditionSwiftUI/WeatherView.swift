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

                HStack {
                    
                    Button("", systemImage: "plus", action: viewModel.confirmLocation )
                    
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                        .opacity(viewModel.showActivityIndicator ? 1 : 0)
                    Spacer()
                    
                    Button("", systemImage: "arrow.clockwise", action: {
                        
                        Task {
                            await  viewModel.getWeather(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                            
                            await  viewModel.getLocationDetail(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                        }
                    })
                   
                    
                }.padding([.leading,.trailing],16)
                
                
            }
        }.onAppear {
            viewModel.loadSavedData()
            
            locationService.$coordinate
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { value in
                    Task {
                        await  viewModel.getWeather(latitude: value.coordinate.latitude, longitude: value.coordinate.longitude)
                        
                        await  viewModel.getLocationDetail(latitude: value.coordinate.latitude, longitude: value.coordinate.longitude)
                    }
                })
                .store(in: &locationService.subscribers)
        }
        .alert("Error", isPresented: $locationService.showErrorAlert, actions: {
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text(locationService.errorMessage)
        })
        .alert("Alert", isPresented: $viewModel.showAlert, actions: {
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text(viewModel.errorMessage)
        })
        .alert("Alert", isPresented: $viewModel.showConfirmAlert, actions: {
            Button("Yes", role: .none, action: viewModel.saveLocation)
            Button("No", role: .cancel, action: {})
        }, message: {
            Text(viewModel.errorMessage)
        })
        
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(apiService: MockAPIService()), locationService: LocationServices())
}
