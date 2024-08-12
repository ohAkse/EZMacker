//
//  EZAdaptiveImageView.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZAdaptiveImageView: View {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    let name: String
    let systemName: Bool
    
    @State private var renderingMode: Image.TemplateRenderingMode?
    @State private var isResizable: Bool = false
    @State private var frameSize: CGSize?
    @State private var customForegroundColor: Color?

    var body: some View {
        image
            .renderingMode(renderingMode ?? .template)
            .resizable()
            .foregroundColor(customForegroundColor ?? getDefaultColor())
    }
    
    private var image: Image {
        systemName ? Image(systemName: name) : Image(name)
    }
    
    private func getDefaultColor() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return .blue
        case ColorSchemeModeType.Dark.title:
            return .yellow
        default:
            return .clear
        }
    }
}


extension EZAdaptiveImageView {
    func renderingMode(_ mode: Image.TemplateRenderingMode) -> Self {
        let copy = self
        copy.renderingMode = mode
        return copy
    }
    
    func resizable() -> Self {
        let copy = self
        copy.isResizable = true
        return copy
    }
    
    func frame(width: CGFloat?, height: CGFloat?) -> Self {
        let copy = self
        copy.frameSize = CGSize(width: width ?? 0, height: height ?? 0)
        return copy
    }
    
    func EZAdaptiveImageView(_ color: Color) -> Self {
        let copy = self
        copy.customForegroundColor = color
        return copy
    }
}
