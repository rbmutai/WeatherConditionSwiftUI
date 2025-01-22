//
//  FavouritesView.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import SwiftUI

struct FavouritesView: View {
    @ObservedObject var viewModel: FavouritesViewModel
    @ObservedObject var locationService: LocationServices
    var body: some View {
        Text("Favourites!")
    }
}

#Preview {
    FavouritesView(viewModel: FavouritesViewModel(), locationService: LocationServices())
}
