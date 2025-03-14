//
//  EZContentView.swift
//  EZMacker
//
//  Created by 박유경 on 10/6/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZContentView: View {
    @EnvironmentObject var systemThemeService: SystemThemeService
    let size: CGFloat = FontSizeType.small.size
    let content: String
    
    var body: some View {
        Text(content)
            .font(.system(size: FontSizeType.large.size))
            .foregroundColor(getContentFontStyles())
            .shadow(radius: 5)
        
    }
    private func getContentFontStyles() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightBlack.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightWhite.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return .clear
        }
    }
}
