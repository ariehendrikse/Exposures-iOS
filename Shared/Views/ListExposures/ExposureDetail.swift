//
//  ExposureDetail.swift
//  Exposures
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI
import MapKit

struct ExposureDetail: View {
    @EnvironmentObject var modelData: ModelData
    var exposure: KenExposure
    var body: some View {
        ScrollView {
            MapContainer(locations: modelData.exposures.filter({ (exposure) -> Bool in
                exposure.locationCoordinate != nil
            })
            .map({ (exposure) -> ClinicAnnotation in
                ClinicAnnotation(exposure: exposure)
                
            }))
                .frame(height: 300)
                //.listRowInsets(EdgeInsets())
            
            CircleImage(image: exposure.image, background: exposure.color)
                .frame(width:280, height:280)
                .offset(y:-140)
                .padding(.trailing, 80)
                .padding(.bottom, -140)
                .padding(.leading, 80)

            
            VStack(alignment: .leading, spacing: nil) {
                HStack {
                    Text(exposure.locationName)
                        .font(.title)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text(exposure.locationAddress)
                    Spacer()
                    Text(exposure.locationSuburb)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                Divider()
                
                Text("Advice for "+exposure.locationName)
                    .font(.title2)
                Text((exposure.exposures[0].alertDescription)) // .html2AttributedString!

            }
            .padding()
        
        }
        .navigationTitle(exposure.locationName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExposureDetail_Previews: PreviewProvider {
    static var previews: some View {
        ExposureDetail(exposure: ModelData().exposures[0])
    }
}
