//
//  SmartFileView.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct SmartFileView: View {
    @ObservedObject var smartFileViewModel: SmartFileViewModel
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
            Text(CategoryType.smartFile.title)
                .customText(textColor: textColor, fontSize: FontSizeType.small.size)
        }
        .navigationTitle(CategoryType.smartFile.title)
        .padding()
    }
}

#Preview {
    SmartBatteryView(smartBatteryViewModel: SmartBatteryViewModel(appSmartBatteryService: AppSmartBatteryService()))
}
