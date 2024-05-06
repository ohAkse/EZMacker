//
//  ColorSchemeToolbarView.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI

struct ColorSchemeToolbarView: CustomizableToolbarContent {
    @State private var isShowChooseColorScheme = false
    @State private var rotateDegree = 0
    
    var body: some CustomizableToolbarContent {
        if isShowChooseColorScheme {
            ToolbarItem(id: ToolbarKey.ColorSchemePicker.name, placement: .primaryAction) {
                HStack(spacing: 0) {
                    ColorSchemeButtonView(buttonTitle: ColorSchemeMode.Light.title, buttonTag: ColorSchemeMode.Light.tag)
                    ColorSchemeButtonView(buttonTitle: ColorSchemeMode.Dark.title, buttonTag: ColorSchemeMode.Dark.tag )
                    
                }
                .padding(3)
                .overlay {
                    Capsule()
                        .stroke(.blue, lineWidth: 1)
                }
                .transition(.move(edge: .trailing))
            }
        }
        
        ToolbarItem(id: ToolbarKey.ColorSchemeButton.name, placement: .primaryAction) {
            Button {
                withAnimation(.linear) {
                    isShowChooseColorScheme.toggle()
                    rotateDegree = rotateDegree == 0 ? -180 : 0
                }
            } label: {
                Image(systemName: ToolbarImage.colorSchemeButton.systemName)
                    .rotationEffect(.degrees(Double(rotateDegree)))
                    .animation(.linear(duration: 0.2), value: rotateDegree)
            }
        }
    }
}
struct ColorSchemeButtonView: View {
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
