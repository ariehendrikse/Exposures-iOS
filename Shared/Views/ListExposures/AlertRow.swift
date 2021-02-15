//
//  AlertRow.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI

struct AlertRow: View {
    var alertName: String
    var items: [KenExposure]
    var body: some View {
        VStack(alignment: .leading) {
            Text(alertName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)

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
        AlertRow(alertName: "Monitor for symptoms.", items: ModelData().exposures)
    }
}
