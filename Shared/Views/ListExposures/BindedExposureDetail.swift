//
//  BindedExposureDetail.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 19/2/21.
//

import SwiftUI

struct BindedExposureDetail: View {
    @Binding var exposure: KenExposure?
    var body: some View {
        ExposureDetail(exposure: exposure)
    }
}

