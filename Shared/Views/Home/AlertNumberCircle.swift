//
//  AlertNumberCircle.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 14/3/21.
//

import SwiftUI

struct AlertNumberCircle: View {
    var number: Int
    var color: Color
    var body: some View {
        Text(String(number))
            .foregroundColor(.white)

            .bold()
            .scaledToFill()


            .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.black.opacity(0.1))
            .scaledToFit()
            .clipShape(Circle())
            //.overlay(Circle().stroke(Color.gray, lineWidth: 2))
    }
}
