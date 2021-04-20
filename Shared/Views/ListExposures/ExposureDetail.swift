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
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: -25.2744,
                longitude: 133.7751
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 40,
                longitudeDelta: 40
            )
        )
    

    
    var exposure: KenExposure?

    
    
    var body: some View {
        if let exposure = exposure as? KenExposure {
        ScrollView() {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [exposure])
            { place in
                MapMarker(coordinate: place.locationCoordinate!, tint: place.color)
            }
            .frame( height: 300)
            .onAppear {
                region.center = exposure.locationCoordinate!
                region.span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            }
            .frame(maxWidth: UIScreen.main.bounds.width)
            
            CircleImage(image: exposure.image, background: exposure.color)
                .frame(width:280, height:280)
                .offset(y:-140)
                .padding(.trailing, 80)
                .padding(.bottom, -140)
                .padding(.leading, 80)

            
            VStack(spacing: 3) {
                VStack(alignment: .center) {
                    Text(exposure.locationName)
                        .font(.title)
                        .foregroundColor(.primary)

                    Text(exposure.locationAddress)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                Divider()
                VStack(alignment: .leading) {
                    

//                    Text("Advice for worst")
//                        .padding(.top)
//                        .font(.title2)
//                    Text((exposure.worstExposure?.alertDescription ?? "No description available."))
//                        .lineLimit(10)
                                            
                    Divider()
                    
                    Text("Exposures")
                        .font(.title2)

                    ForEach(exposure.exposures) { exp0 in

                        HStack() {
                            Rectangle()
                                .frame(width: 10,  height: 70, alignment: .leading)
                                .foregroundColor(exp0.color)
                            VStack(alignment: .leading) {
                                Text(exp0.dateDescription)
                                Text(exp0.timeDescription)
                                if let msg = exposure.worstExposure?.notes {
                                    Text(msg).font(.caption2)
                                }
                                Text(exp0.alertDescription)
                                    .font(.caption2)
                                Text("Created on: "+exp0.createdString)
                                    .font(.caption2)
                            }



                        }
                    }
                    .padding(.bottom)
                    Divider()



                    
                    Divider()
                    Spacer()
                }




            }
            .lineLimit(10)
            .frame(maxWidth: UIScreen.main.bounds.width)

        }
        .navigationTitle("Exposure Site")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

