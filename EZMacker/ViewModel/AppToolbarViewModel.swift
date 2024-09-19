//
//  ColorSchemeViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import SwiftUI
class AppToolbarViewModel: ObservableObject {
    @AppStorage(AppStorageKey.colorSchemeType.name) var colorScheme: String = (AppStorageKey.colorSchemeType.byDefault as? String ?? "")
    @Published var isShowChooseColorScheme: Bool = false
    @Published var rotateDegree: Double = 0
    
    func getColorScheme() -> String {
        return colorScheme
    }
    
    func updateColorScheme(to scheme: String) {
        colorScheme = scheme
        if scheme == ColorSchemeModeType.Light.title {
            NSApplication.shared.appearance = NSAppearance(named: .vibrantLight)
        } else {
            NSApplication.shared.appearance = NSAppearance(named: .vibrantDark)
        }
    }
    
    func toggleColorScheme() {
        withAnimation(.linear) {
            isShowChooseColorScheme.toggle()
            rotateDegree = rotateDegree == 0 ? -180 : 0
        }
    }
}
