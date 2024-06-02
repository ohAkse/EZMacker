//
//  InfoWifiMainView.swift
//  EZMacker
//
//  Created by 박유경 on 6/2/24.
//

import SwiftUI
struct InfoWifiMainInfoView: View {
    var body: some View {
        VStack {
            Text("WiFi Main Info")
                .font(.headline)
                .fontWeight(.bold)
                .padding([.leading, .top], 10)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .customBackgroundColor()
        .clipped()
    }
}
