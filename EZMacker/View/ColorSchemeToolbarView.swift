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
            ToolbarItem(id: "ColorSchemePicker", placement: .primaryAction) {
                HStack(spacing: 0) {
                    ColorSchemeButtonView(buttonTitle: "Light", newColorSchemeValueToOnTap: "light")
                    
                    ColorSchemeButtonView(buttonTitle: "Dark", newColorSchemeValueToOnTap: "dark")
                    
                }
                .padding(1)
                .overlay {
                    Capsule()
                        .stroke(.blue, lineWidth: 1)
                }
                .transition(.move(edge: .trailing))
            }
        }
        
        ToolbarItem(id: "ColorSchemeButton", placement: .primaryAction) {
            Button {
                withAnimation(.linear) {
                    isShowChooseColorScheme.toggle()
                    if rotateDegree == 0 {
                        rotateDegree = -180
                    } else {
                        rotateDegree = 0
                    }
                }
            } label: {
                Image(systemName: "circle.righthalf.filled")
                    .rotationEffect(.degrees(Double(rotateDegree)))
                    .animation(.linear(duration: 0.2), value: rotateDegree)
            }
        }
    }
}
struct ColorSchemeButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("preferredColorScheme") var preferredColorScheme = ""
    
    let buttonTitle: String
    let newColorSchemeValueToOnTap: String
    
    var body: some View {
        Button {
            if newColorSchemeValueToOnTap == "light" {
                NSApplication.shared.appearance = NSAppearance(named: .aqua)
            } else if newColorSchemeValueToOnTap == "dark" {
                NSApplication.shared.appearance = NSAppearance(named: .darkAqua)
            }
            preferredColorScheme = newColorSchemeValueToOnTap
        } label: {
            Text(buttonTitle)
        }
        .buttonStyle(.plain)
        .padding(5)
    }
}
