//
//  ClinicDetail.swift
//  Clinics
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI
import MapKit

struct ClinicDetail: View {
    @EnvironmentObject var modelData: ModelData
    var clinic: Clinic
    var clinicIndex: Int {
        modelData.clinics.firstIndex(where: { $0.id == clinic.id})!
        }

    var body: some View {
        ScrollView {
            ClinicMap()
            CircleImage(image: clinic.image, background: clinic.color)
                .offset(y:-80)
                .padding(.bottom, -80)
                .padding(.trailing, 80)
                .padding(.leading, 80)
                .frame( maxWidth: 400,  maxHeight: 400)
            
            VStack(alignment: .leading, spacing: nil) {
                HStack {
                    Text(clinic.Site_Name)
                        .font(.title)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text(clinic.Address)
                    Spacer()
                    Text(clinic.Suburb)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                Divider()
                

                if clinic.Service_Availability != nil {
                    Text("Service Availability")
                        .font(.title2)
                    Text(clinic.Service_Availability!)
                }


            }
            .padding()
        
        }
        .navigationTitle(clinic.Site_Name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ClinicDetail_Previews: PreviewProvider {
    static var previews: some View {
        ClinicDetail(clinic: ModelData().clinics[0])
    }
}
