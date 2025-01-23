//
//  FavouritesView.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import SwiftUI
import MapKit
struct FavouritesView: View {
    @ObservedObject var viewModel: FavouritesViewModel
    @ObservedObject var locationService: LocationServices
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -1.3033, longitude: 36.8264),
            span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6)
        )
    )
    var body: some View {
        VStack {
            if #available(iOS 17.0, *) {
                Text("Favourite Locations")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .onChange(of: locationService.coordinate) {
                        updateMapPosition(coordinates: locationService.coordinate.coordinate)
                    }
            } else {
                // Fallback on earlier versions
                Text("Favourite Locations")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .onChange(of: locationService.coordinate) { _ in
                        updateMapPosition(coordinates: locationService.coordinate.coordinate)
                    }
            }
            List {
                ForEach(viewModel.favouriteLocations, id: \.self) { item in
                    HStack {
                        Text(item.city)
                    }
                    .padding([.leading, .trailing],12)
                    .swipeActions(allowsFullSwipe: false) {
                        Button {
                            updateMapPosition(coordinates: CLLocationCoordinate2DMake(item.latitude, item.longitude))
                        } label: {
                            Label("View", systemImage: "eye.fill")
                        }
                        .tint(.indigo)
                        
                        Button(role: .destructive) {
                            viewModel.deleteFavouriteLocation(city: item.city)
                            viewModel.loadFavouriteLocations()
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
               
            }
            .overlay {
                if viewModel.favouriteLocations.isEmpty {
                    Text("No Locations Saved")
                }
            }
            
            Map(position: $position, content: {
                ForEach(viewModel.mapAnnotations, id: \.self) { item in
                    Marker(item.title ?? "", coordinate: item.coordinate)
                }
                UserAnnotation()
            })
            .frame(height: 450)
                
            
        }
        .onAppear {
            viewModel.loadFavouriteLocations()
            updateMapPosition(coordinates: locationService.coordinate.coordinate)
        }
        .alert("Error", isPresented: $locationService.showErrorAlert, actions: {
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text(locationService.errorMessage)
        })
    }
    
    func updateMapPosition(coordinates: CLLocationCoordinate2D){
         position = MapCameraPosition.region(
                     MKCoordinateRegion(
                         center: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude),
                         span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6)
                     )
                 )
    }
}

#Preview {
    FavouritesView(viewModel: FavouritesViewModel(), locationService: LocationServices())
}
