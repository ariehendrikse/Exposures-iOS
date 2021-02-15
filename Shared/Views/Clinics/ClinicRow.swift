//
//  ClinicRow.swift
//  Clinics
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI

struct ClinicRow: View {
    var clinic: Clinic
    
    var body: some View {
        HStack {
            clinic.image
                .resizable()
                .frame(width:30,height:30)
                .padding(5)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(clinic.color, lineWidth: 2))
                .padding(5)
            

            Text(clinic.Site_Name)
            Spacer()
//            if clinic.isFavorite{
//                Image(systemName: "star.fill")
//                    .foregroundColor(.yellow)
//            }
        }
    }
}

struct ClinicRow_Previews: PreviewProvider {
    static var clinics = ModelData().clinics
    static var previews: some View {
        Group {
            ClinicRow(clinic: clinics[1])
            ClinicRow(clinic: clinics[0])
        }
        .previewLayout(.fixed(width:300,height:70))

    }
}
