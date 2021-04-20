//
//  buttonImageRow.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 17/2/21.
//

import SwiftUI

struct ButtonImageRow: View {
    var img: Image
    var body: some View {
        HStack() {
            HStack(){
                Circle()
                    .foregroundColor(Color.white)
                    .overlay(img
                                .resizable()
                                .foregroundColor(Color.red)
                                .scaledToFit()
                    )
                    .frame(width: 30, height: 30)
                    .padding()
                                
                Text("The data here is manually collated by volunteers. There may be errors. Always check official sources.")
                    .padding(.trailing)
                    .font(.custom("FONT_NAME", size: 12))
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
        }
    }
}

struct buttonImageRow_Previews: PreviewProvider {
    static var previews: some View {
        ButtonImageRow(img: Image(systemName: "exclamationmark.octagon.fill"))
    }
}
