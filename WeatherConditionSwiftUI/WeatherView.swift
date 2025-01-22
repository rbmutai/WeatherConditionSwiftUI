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
        Text("Weather!")
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(apiService: MockAPIService()), locationService: LocationServices())
}
