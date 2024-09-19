//
//  CustomContent.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZContent: View {
    @EnvironmentObject var colorScheme: AppToolbarViewModel
    let size: CGFloat = FontSizeType.small.size
    let content: String
    
    var body: some View {
        Text(content)
            .font(.system(size: FontSizeType.large.size))
            .foregroundColor(getContentFontStyles())
            .shadow(radius: 5)
        
    }
    private func getContentFontStyles() -> Color {
        switch colorScheme.getColorScheme() {
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
