//
//  ColorPickerCoordinatorPreferenceKey.swift
//  EZMacker
//
//  Created by 박유경 on 10/19/24.
//

import SwiftUI

struct ColorPickerCoordinatorPreferenceKey: PreferenceKey {
    static var defaultValue: ColorPickerPresentableView.Coordinator?
    
    static func reduce(value: inout ColorPickerPresentableView.Coordinator?, nextValue: () -> ColorPickerPresentableView.Coordinator?) {
        value = nextValue()
    }
}
