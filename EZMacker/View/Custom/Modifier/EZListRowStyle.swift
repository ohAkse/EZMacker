//
//  EZListRowStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZListRowStyle: ViewModifier {
    @EnvironmentObject var colorSchemeViewModel: AppToolbarViewModel
    
    func body(content: Content) -> some View {
        content
            .listRowBackground(backgroundColorForTheme())
    }
    
    private func backgroundColorForTheme() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.white.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.softGray.color
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
