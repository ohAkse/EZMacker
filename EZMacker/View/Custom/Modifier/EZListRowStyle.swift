//
//  EZListRowStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZListRowStyle: ViewModifier {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    
    func body(content: Content) -> some View {
        content
            .listRowBackground(backgroundColorForTheme())
    }
    
    private func backgroundColorForTheme() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color.opacity(0.3)
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightBlue.color.opacity(0.7)
        default:
            return Color.clear
        }
    }
}

extension View {
    func ezListRowStyle() -> some View {
        self.modifier(EZListRowStyle())
    }
}
