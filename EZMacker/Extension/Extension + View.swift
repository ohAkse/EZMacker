//
//  Extension + View.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI
extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }

}
