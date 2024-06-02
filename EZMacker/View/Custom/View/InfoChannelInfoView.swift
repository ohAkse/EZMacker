//
//  InfoChannelInfoView.swift
//  EZMacker
//
//  Created by 박유경 on 6/2/24.
//

import SwiftUI

struct InfoChannelInfoView: View {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    @Binding var channelBandwidth: Int
    @Binding var channelFrequency: Int
    @Binding var channel: Int
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Image(systemName: "wifi.router")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        Text("라우터 정보")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding([.leading, .top], 10)
                        
                    Spacer(minLength: 20)
                    HStack(spacing: 10) {
                        Text("대역폭:")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                        Spacer()
                        Text("\(channelBandwidth) MHz")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 10)
                    HStack(spacing: 10) {
                        Text("주파수:")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                        Spacer()
                        Text("\(channelFrequency) MHz")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 10)
                    HStack(spacing: 10) {
                        Text("채널:")
                            .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: false)
                        Spacer()
                        Text("\(channel)")
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
