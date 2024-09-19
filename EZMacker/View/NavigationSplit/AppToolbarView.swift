//
//  ColorSchemeToolbarView.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

// MARK: 차후 탭에따라 기능 추가시 이름 및 역핧 추가할것
struct AppToolbarView: View {
    @EnvironmentObject var appThemeManager: AppThemeManager
    
    let buttonTitle: String
    let buttonTag: Int
    
    var body: some View {
        Button {
            let scheme = buttonTag == 0 ? ColorSchemeModeType.Light.title : ColorSchemeModeType.Dark.title
            appThemeManager.updateColorScheme(to: scheme)
        } label: {
            Text(buttonTitle)
        }
        .buttonStyle(.plain)
        .padding(5)
    }
}
