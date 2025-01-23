//
//  LocationDetail.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 22/01/2025.
//

import Foundation

struct LocationDetail: Decodable {
    let results: [ResultDetail]
}

struct ResultDetail: Decodable {
    let addressComponents: [AddressDetail]
    let formattedAddress: String
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
         case addressComponents = "address_components"
         case formattedAddress = "formatted_address"
         case types
    }
}

struct AddressDetail: Decodable {
    let longName: String
    
    enum CodingKeys:String, CodingKey {
        case longName = "long_name"
    }
}

struct FavouriteLocationDetail: Hashable {
    let street: String
    let city: String
    let province: String
    let latitude: Double
    let longitude: Double
}
