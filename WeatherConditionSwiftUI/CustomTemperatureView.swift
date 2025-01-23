//
//  CustomTemperatureView.swift
//  WeatherConditionSwiftUI
//
//  Created by Robert Mutai on 23/01/2025.
//

import SwiftUI

struct CustomTemperatureView: View {
    var title: String
    var temperature: String
    var foreGroundColor: any ShapeStyle = .white
    var body: some View {
        VStack {
            Text(temperature)
                .fontWeight(.bold)
                .foregroundStyle(foreGroundColor)
            Text(title)
                .foregroundStyle(foreGroundColor)
        }
    }
}

#Preview {
    CustomTemperatureView(title: "Current", temperature: "22")
}
