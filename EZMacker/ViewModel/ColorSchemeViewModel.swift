//
//  ColorSchemeViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import SwiftUI
class ColorSchemeViewModel: ObservableObject {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    
    @Published var isShowChooseColorScheme: Bool = false
    @Published var rotateDegree: Double = 0
    
    func getColorScheme() -> String {
        return colorScheme
    }
    
    func updateColorScheme(to scheme: String) {
        colorScheme = scheme
        if scheme == ColorSchemeMode.Light.title {
            NSApplication.shared.appearance = NSAppearance(named: .aqua)
        } else {
            NSApplication.shared.appearance = NSAppearance(named: .darkAqua)
        }
    }
    
    func toggleColorScheme() {
        withAnimation(.linear) {
            isShowChooseColorScheme.toggle()
            rotateDegree = rotateDegree == 0 ? -180 : 0
        }
    }
}
