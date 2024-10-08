//
//  SizePreferenceKey.swift
//  EZMacker
//
//  Created by 박유경 on 10/9/24.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
