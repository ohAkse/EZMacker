//
//  EZNormalImageStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZNormalImageStyle: ViewModifier {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    let imageScale: Image.Scale
    let width: CGFloat
    let height: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .imageScale(imageScale)
            .foregroundColor(imageColorForTheme())
    }
    
    private func imageColorForTheme() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightBlue.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightGreen.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func ezNormalImageStyle(imageScale: Image.Scale, width: CGFloat, height: CGFloat) -> some View {
        modifier(EZNormalImageStyle(imageScale: imageScale, width: width, height: height))
    }
}
