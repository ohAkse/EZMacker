//
//  EZButtonActionView.swift
//  EZMacker
//
//  Created by 박유경 on 10/6/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZButtonActionView: View {
    @EnvironmentObject var systemThemeService: SystemThemeService
    let action: () -> Void
    let imageName: String
    let isDisabled: Bool
    
    var body: some View {
        Button(action: action) {
            // 빈 클로저를 유지합니다.
        }
        .ezButtonImageStyle(
            imageName: imageName,
            lightModeForegroundColor: ThemeColorType.black.color,
            darkModeForegroundColor: ThemeColorType.white.color,
            lightModeBackgroundColor: ThemeColorType.lightWhite.color,
            darkModeBackgroundColor: ThemeColorType.lightDark.color,
            frameSize: CGSize(width: 30, height: 30)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(borderColorForTheme(), lineWidth: 1)
        )
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
    
    private func borderColorForTheme() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.black.color.opacity(0.5)
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightWhite.color
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return .clear
        }
    }

}
