//
//  CardView.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 14/3/21.
//
import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    var alignment: Alignment = .center
    var bg: Color = Color.primary

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    init(alignment: Alignment, @ViewBuilder content: @escaping () -> Content) {
        self.init(content: content)
        self.alignment = alignment
    }
    init(alignment: Alignment, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.init(alignment: alignment, content: content)
        self.bg = color
    }
    
    var body: some View {
        VStack(){
            content.padding()
                .background(LinearGradient(gradient: Gradient(colors: [bg.opacity(0.7), bg.opacity(0.5)]), startPoint: .top, endPoint: .bottom).background(Color.black))
                .foregroundColor(.white)
        }
        .cornerRadius(20)
    }
}
