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
                    currentConditionsView
                    
                    temperaturesView
                  
                    forcastView
                }
                
            headerView
         }
        }.onAppear(perform: {
            viewModel.loadSavedData()
        })
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
        .alert("Save Location", isPresented: $viewModel.showConfirmAlert, actions: {
            Button("Yes", role: .none, action: viewModel.saveLocation)
            Button("No", role: .cancel, action: {})
        }, message: {
            Text(viewModel.errorMessage)
        })
        
    }
    
    // MARK: - Views
    private var forcastView: some View {
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
    
    private var temperaturesView: some View {
        VStack {
            HStack {
                CustomTemperatureView(title: "min", temperature: viewModel.minimumTemperature)
                Spacer()
                CustomTemperatureView(title: "Current", temperature: viewModel.currentTemperature)
                Spacer()
                CustomTemperatureView(title: "max", temperature: viewModel.maximumTemperature)
            }
            .padding([.leading, .trailing, .top], 8)
            
            Divider()
                .frame(minHeight: 1)
                .overlay(Color.white)
        }
    }
    
    private var locationDetailsView: some View {
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
            
        }
        .padding([.top], 8)
        .foregroundStyle(.white)
    }
    
    private var currentConditionsView: some View {
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

                    locationDetailsView
            }
            .foregroundStyle(.white)
        }
    }
    
    private var headerView: some View {
        VStack {
            if #available(iOS 17.0, *) {
                Text("Weather Conditions")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .onChange(of: locationService.coordinate) {
                        viewModel.fetchAllDetails(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                    }
            } else {
                // Fallback on earlier versions
                Text("Weather Conditions")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .onChange(of: locationService.coordinate) { _ in
                        viewModel.fetchAllDetails(latitude: locationService.coordinate.coordinate.latitude, longitude: locationService.coordinate.coordinate.longitude)
                    }
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
    
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(apiService: MockAPIService()), locationService: LocationServices())
}
