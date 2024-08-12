//
//  EZListViewStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZListViewStyle: ViewModifier {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    
    
    
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
            .background(backgroundColorForTheme())
            .cornerRadius(12)
    }
    
    private func backgroundColorForTheme() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightBlue.color
        default:
            return Color.clear
        }
    }
}

extension View {
    func ezListViewStyle() -> some View {
        self.modifier(EZListViewStyle())
    }
}
