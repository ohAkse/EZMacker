//
//  View + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

import SwiftUI

extension View {
    func toastView(toast: Binding<ToastData?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }

}
