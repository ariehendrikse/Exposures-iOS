//
//  CurrentLocationButton.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 15/2/21.
//

import SwiftUI
import MapKit

struct CurrentLocationButton: View {
    @Binding var findLocation: Bool

    var body: some View {
        ZStack {
            Color.white
            Image(systemName: "location")
                .foregroundColor(Color.blue)
        }
        .cornerRadius(5)
        .onTapGesture {
                findLocation = true
        }
            
    }
}


