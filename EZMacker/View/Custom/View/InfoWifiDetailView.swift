//
//  InfoWifiDetailView.swift
//  EZMacker
//
//  Created by 박유경 on 6/3/24.
//

import SwiftUI

struct InfoWifiDetailView: View {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    @Binding var band: String
    @Binding var hardwareAddress: String
    @Binding var locale: String
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Image(systemName: "externaldrive.fill.badge.wifi")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        Text("Wifi 정보")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding([.leading, .top], 10)
                        
                    Spacer(minLength: 20)
                    HStack(spacing: 10) {
                        Text("밴드:")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                        Spacer()
                        Text("\(band)")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 10)
                    HStack(spacing: 10) {
                        Text("Mac:")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                        Spacer()
                        Text("\(hardwareAddress)")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 10)
                    HStack(spacing: 10) {
                        Text("Locale:")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                        Spacer()
                        Text("\(locale)")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: geo.size.height * 0.8)
                
                Spacer(minLength: 5)
            }
            .customBackgroundColor()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
