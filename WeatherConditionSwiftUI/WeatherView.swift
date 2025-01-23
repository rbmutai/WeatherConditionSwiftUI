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
            ZStack(alignment: .top) {
                VStack {
                    
                    ZStack(alignment: .center) {
                        Image(viewModel.backgroundImage)
                            .resizable()
                            .frame(height: 330, alignment: .center)
                       
                        VStack(spacing: 10) {
                            Text(viewModel.currentTemperature)
                                .fontWeight(.bold)
                                .font(.system(size: 25))
                            Text(viewModel.conditions)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
       
                                VStack(spacing: 8){
                                    Group {
                                        Text(viewModel.lastChecked)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 16))
                                        Text(viewModel.street)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 16))
                                        Text(viewModel.city)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 16))
                                        Text(viewModel.province)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 16))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding([.leading], 8)
                                    
                                }.padding([.top], 8)
                               
                        }
                        .foregroundStyle(.white)
                        
                    }
                    
                    HStack {
                        VStack {
                            Text(viewModel.minimumTemperature)
                                .fontWeight(.bold)
                            Text("min")
                        }
                        Spacer()
                        VStack {
                            Text(viewModel.currentTemperature)
                                .fontWeight(.bold)
                            Text("Current")
                        }
                        Spacer()
                        VStack {
                            Text(viewModel.maximumTemperature)
                                .fontWeight(.bold)
                            Text("max")
                        }
                        
                    }
                    .foregroundStyle(.white)
                    .padding([.leading, .trailing, .top], 8)
                    
                    Divider()
                        .frame(minHeight: 1)
                        .overlay(Color.white)
                  
                        ForEach(viewModel.forcastDetail, id: \.self) { item in
                            
                            HStack {
                                Text(item.day)
                                    .frame(width: 95, alignment: .leading)
                                Spacer()
                                Image(viewModel.getWeatherIcon(theme: item.theme))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Spacer()
                                Text(item.temperature)
                                    .frame(width: 80, alignment: .trailing)
                                   
                            }
                            .padding([.leading, .trailing],12)
                            .foregroundStyle(.white)
                            
                        }
                }
            
            VStack {
                if #available(iOS 17.0, *) {
                    Text("Weather Conditions")
                        .onChange(of: locationService.coordinate) {
                            viewModel.fetchAllDetails(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                        }.foregroundStyle(.white)
                } else {
                    // Fallback on earlier versions
                    Text("Weather Conditions")
                        .onChange(of: locationService.coordinate) { _ in
                            viewModel.fetchAllDetails(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                            
                        }.foregroundStyle(.white)
                }
                
                HStack {
                    
                    Button("", systemImage: "plus", action: viewModel.confirmLocation)
                        .tint(.white)
                    
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                        .opacity(viewModel.showActivityIndicator ? 1 : 0)
                    Spacer()
                    
                    Button("", systemImage: "arrow.clockwise", action: {
                        
                        viewModel.fetchAllDetails(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                        
                    })
                    .tint(.white)
                }
                
            }.padding(8)
         }
        }.onAppear {
            viewModel.loadSavedData()
        }
        .background(Color(viewModel.backgroundColor))
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
