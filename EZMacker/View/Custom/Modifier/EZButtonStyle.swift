//
//  EZButtonStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI
import EZMackerUtilLib
struct EZButtonStyle: ButtonStyle {
    @EnvironmentObject var appThemeManager: AppThemeManager

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColorForTheme())
            .foregroundColor(.black)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
    
    private func backgroundColorForTheme() -> Color {
        switch appThemeManager.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return Color.blue
        case ColorSchemeModeType.Dark.title:
            return Color.orange
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.primary
        }
    }
}

extension View {
    func ezButtonStyle() -> some View {
        self.buttonStyle(EZButtonStyle())
    }
}
