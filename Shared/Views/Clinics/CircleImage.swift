//
//  CircleImage.swift
//  Landmarks
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI

struct CircleImage: View {
    
    var image: Image
    var background: Color
    
    var body: some View {
        image
            .renderingMode(.none)
            .resizable()
            .scaledToFit()
            .scaleEffect(0.5)
            .background(background.blur(radius: 100,opaque: false))
            
            .clipShape(Circle())
            
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("empty-test-tube"), background: Color.yellow)
    }
}
