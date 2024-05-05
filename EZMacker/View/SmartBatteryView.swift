//
//  SmartBatteryView.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct SmartBatteryView: View {
    @ObservedObject var smartBatteryViewModel: SmartBatteryViewModel
    @Environment(\.colorScheme) var colorScheme
    private var textColor: Color {
        return colorScheme == .light ? ThemeColor.lightBlack.color : ThemeColor.lightWhite.color
    }
    private var imageForegroundColor: Color {
        return colorScheme == .light ? ThemeColor.lightGreen.color : ThemeColor.lightBlue.color
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(imageForegroundColor)
            Text(CategoryType.smartBattery.title)
                .customText(textColor: textColor, fontSize: FontSizeType.small.size)
        }
        .navigationTitle(CategoryType.smartBattery.title)
        .padding()
    }
}
