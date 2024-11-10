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
    
    func makeNSView(context: Context) -> NSColorWell {
        let colorWell = NSColorWell().then {
            $0.target = context.coordinator
            $0.action = #selector(Coordinator.colorChanged(_:))
        }
        context.coordinator.setColorWell(colorWell)
        return colorWell
    }

    func updateNSView(_ nsView: NSColorWell, context: Context) {
        nsView.color = NSColor(color)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator { newColor in
            self.color = newColor
        }
    }

    class Coordinator: NSObject {
        private weak var colorWell: NSColorWell?
        private var onColorChange: (Color) -> Void
        
        deinit {
            colorWell?.deactivate()
            colorWell = nil
        }
        
        init(onColorChange: @escaping (Color) -> Void) {
            self.onColorChange = onColorChange
            super.init()
        }

        @objc func colorChanged(_ sender: NSColorWell) {
            onColorChange(Color(sender.color))
        }

        func setColorWell(_ colorWell: NSColorWell) {
            self.colorWell = colorWell
        }

        func closeColorPanel() {
            colorWell?.deactivate()
            colorWell = nil
            NSColorPanel.shared.close()
        }
    }
}
