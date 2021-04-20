//
//  AlertRow.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI
import CoreLocation
import MapKit

struct AlertRow: View {
    @ObservedObject var locationViewModel = LocationViewModel()
    var items: [KenExposure]
    
    var body: some View {
        VStack(alignment: .leading) {

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { alert in
                        NavigationLink(destination: ExposureDetail(exposure: alert)) {
                            AlertItem(exposure: alert)
                        }
                        .padding()
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct AlertRow_Previews: PreviewProvider {
    static var previews: some View {
        AlertRow( items: ModelData().exposures)
    }
}
