//
//  AusStatePicker.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 16/2/21.
//

import SwiftUI

struct AusStatePicker: View {
    @Binding  var selection: String
    private let items: [String] = ["VIC", "NSW", "QLD", "WA", "SA"]
    
    var body: some View {
        VStack {
            Picker(selection: $selection, label: Text("")) {
                ForEach(items, id: \.self) { text in
                    Text(text).tag(text)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
