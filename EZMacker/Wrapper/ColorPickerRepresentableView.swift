//
//  ColorPickerRepresentableView.swift
//  EZMacker
//
//  Created by 박유경 on 10/19/24.
//

import AppKit
import SwiftUI

struct ColorPickerPresentableView: NSViewRepresentable {
    @Binding var color: Color
    let label: String

    func makeNSView(context: Context) -> NSColorWell {
        let colorWell = NSColorWell()
        colorWell.target = context.coordinator
        colorWell.action = #selector(Coordinator.colorChanged(_:))
        return colorWell
    }

    func updateNSView(_ nsView: NSColorWell, context: Context) {
        nsView.color = NSColor(color)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: ColorPickerPresentableView

        init(_ parent: ColorPickerPresentableView) {
            self.parent = parent
        }

        @objc func colorChanged(_ sender: NSColorWell) {
            parent.color = Color(sender.color)
        }

        func closeColorPanel() {
            NSColorPanel.shared.close()
        }
    }
}
