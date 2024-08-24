//
//  EZTabbarButtonStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZTabbarButtonStyle: ButtonStyle {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(PlainButtonStyle())
            .background(dynamicBackgroundColor())
            .cornerRadius(12)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
    
    private func dynamicBackgroundColor () -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.white.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.darkBlue.color.opacity(0.7)
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.primary
        }
    }
}

extension View {
    func ezTabbarButtonStyle() -> some View {
        self.buttonStyle(EZTabbarButtonStyle())
    }
}
