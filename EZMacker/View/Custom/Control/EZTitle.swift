//
//  CustomTitle.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI
import EZMackerUtilLib
struct EZTitle: View {
    @EnvironmentObject var appThemeManager: SystemThemeService
    let size: CGFloat = FontSizeType.small.size
    let title: String
    
    var body: some View {
        Text(title)
            .frame(width: 70, height: 50)
            .font(.system(size: size))
            .fontWeight(.bold)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .foregroundColor(getHeaderFontStyles()[0])
            .background(getHeaderFontStyles()[1])
            .clipShape(.capsule(style: .circular))
            .lineLimit(2)
            .shadow(radius: 5)
    }
    private func getHeaderFontStyles() -> [Color] {
        switch appThemeManager.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return [ThemeColorType.lightBlack.color, ThemeColorType.lightYellow.color]
        case ColorSchemeModeType.Dark.title:
            return [ThemeColorType.lightWhite.color, ThemeColorType.lightBlue.color]
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return [.clear, .clear]
        }
    }
}
