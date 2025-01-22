//
//  ContentView.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import SwiftUI


struct ContentView: View {
    @State  var selectedTab : Int = 1
    @ObservedObject var locationService = LocationServices()
    var body: some View {
        TabView (selection: $selectedTab){
            
            WeatherView(viewModel: WeatherViewModel(apiService: APIService()), locationService: locationService)
                .tabItem {
                    VStack{
                        Image(systemName: "cloud.sun.fill")
                        Text("Weather")
                    }
                }.tag(1)
           

            FavouritesView(viewModel: FavouritesViewModel(), locationService: locationService)
                .tabItem {
                    VStack{
                        Image(systemName: "heart.fill")
                        Text("Favourites")
                    }
                }.tag(2)
            
        }
    }
}


#Preview {
    ContentView(selectedTab: 1)
}
