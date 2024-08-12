//
//  EZInnerBackgroundStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZInnerBackgroundStyle: ViewModifier {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    
    func body(content: Content) -> some View {
        content
            .background(innerBackgroundTheme())
            .cornerRadius(12)
    }
    
    private func innerBackgroundTheme() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.white.color.opacity(0.5)
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightBlue.color.opacity(0.7)
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.primary  
        }
    }
}

extension View {
    func ezInnerBackgroundStyle() -> some View {
        modifier(EZInnerBackgroundStyle())
    }
}

