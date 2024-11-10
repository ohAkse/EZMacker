//
//  EZButtonStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI
import EZMackerUtilLib

enum ButtonStyleType {
    case basic
    case type1
}

struct EZButtonStyle: ButtonStyle {
    @EnvironmentObject var systemThemeService: SystemThemeService
    let type: ButtonStyleType
    
    init(type: ButtonStyleType = .basic) {
        self.type = type
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColorForTheme())
            .foregroundColor(.black)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
    
    private func backgroundColorForTheme() -> Color {
        switch type {
         case .basic:
             switch systemThemeService.getColorScheme() {
             case ColorSchemeModeType.Light.title:
                 return ThemeColorType.cyan.color
             case ColorSchemeModeType.Dark.title:
                 return ThemeColorType.lightBlue.color
             default:
                 Logger.fatalErrorMessage("colorScheme is Empty")
                 return Color.primary
             }
             
         case .type1:
             switch systemThemeService.getColorScheme() {
             case ColorSchemeModeType.Light.title:
                 return ThemeColorType.lightYellow.color
             case ColorSchemeModeType.Dark.title:
                 return ThemeColorType.orange.color
             default:
                 Logger.fatalErrorMessage("colorScheme is Empty")
                 return Color.primary
             }
         }
    }
}
extension View {
    func ezButtonStyle(type: ButtonStyleType = .basic) -> some View {
        self.buttonStyle(EZButtonStyle(type: type))
    }
}
