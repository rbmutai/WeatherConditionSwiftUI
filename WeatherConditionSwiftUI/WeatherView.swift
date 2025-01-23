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
                if #available(iOS 17.0, *) {
                    Text("Weather Conditions")
                        .onChange(of: locationService.coordinate) { oldValue, newValue in
                            
                            viewModel.fetchAllDetails(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                    }
                } else {
                    // Fallback on earlier versions
                    Text("Weather Conditions")
                        .onChange(of: locationService.coordinate) { _ in
                            viewModel.fetchAllDetails(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                        
                        }
                }

                HStack {
                    
                    Button("", systemImage: "plus", action: viewModel.confirmLocation )
                    
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                        .opacity(viewModel.showActivityIndicator ? 1 : 0)
                    Spacer()
                    
                    Button("", systemImage: "arrow.clockwise", action: {
                        
                        viewModel.fetchAllDetails(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                        
                    })
                   
                    
                }.padding([.leading,.trailing],16)
                
                
            }
        }.onAppear {
            viewModel.loadSavedData()
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
