//
//  ColorSchemeToolbarView.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI
struct ColorSchemeToolbarView: View {
    @AppStorage(AppStorageKey.colorSchme.name) var selectedColorScheme = AppStorageKey.colorSchme.byDefault
    
    let buttonTitle: String
    let buttonTag: Int
    
    var body: some View {
        Button {
            NSApplication.shared.appearance = buttonTag == ColorSchemeMode.Light.tag ? NSAppearance(named: .aqua) : NSAppearance(named: .darkAqua)
            selectedColorScheme = buttonTag == 0 ? ColorSchemeMode.Light.title : ColorSchemeMode.Dark.title
        } label: {
            Text(buttonTitle)
        }
        .buttonStyle(.plain)
        .padding(5)
    }
}
