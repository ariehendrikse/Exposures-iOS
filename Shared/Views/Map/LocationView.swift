//
//  LocationView.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI

struct LocationView: View {
  
  @ObservedObject var locationViewModel = LocationViewModel()
  
  var body: some View {
    VStack {
      Text("Your location is:")
      HStack {
        Text("Latitude: \(locationViewModel.userLatitude)")
        Text("Longitude: \(locationViewModel.userLongitude)")
      }
    }
  }
}
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
