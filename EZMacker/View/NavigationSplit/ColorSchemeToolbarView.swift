//
//  ColorSchemeToolbarView.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

struct ColorSchemeToolbarView: View {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    
    let buttonTitle: String
    let buttonTag: Int
    
    var body: some View {
        Button {
            let scheme = buttonTag == 0 ? ColorSchemeModeType.Light.title : ColorSchemeModeType.Dark.title
            colorSchemeViewModel.updateColorScheme(to: scheme)
        } label: {
            Text(buttonTitle)
        }
        .buttonStyle(.plain)
        .padding(5)
    }
}
