//
//  TextFieldRepresentableView.swift
//  EZMacker
//
//  Created by 박유경 on 6/11/24.
//

import SwiftUI
import AppKit

struct TextFieldRepresentableView: NSViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: TextFieldRepresentableView

        init(parent: TextFieldRepresentableView) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                let filtered = textField.stringValue.filter { "0123456789".contains($0) }
                
                if let intValue = Int(filtered), intValue <= 100 {
                    parent.text = filtered
                } else {
                    parent.text = String(filtered.prefix(3))
                }
                
                if filtered.isEmpty {
                    parent.text = ""
                } else if let intValue = Int(filtered), intValue > 100 {
                    textField.stringValue = "100"
                    parent.text = "100"
                } else if filtered.count > 3 {
                    textField.stringValue = String(filtered.prefix(3))
                    parent.text = String(filtered.prefix(3))
                } else {
                    textField.stringValue = filtered
                    parent.text = filtered
                }
            }
        }

        func textField(_ textField: NSTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String?) -> Bool {
            guard let string = string else { return false }
            let aSet = CharacterSet(charactersIn: "0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField().then {
            $0.delegate = context.coordinator
            $0.layer?.cornerRadius = 12
            $0.alignment = .left
            $0.font = NSFont.systemFont(ofSize: 18) 
            $0.placeholderString = "0과 100 사이에 숫자를 입력하세요."
            $0.isBezeled = false
            $0.drawsBackground = false
            $0.backgroundColor = .clear
            $0.cell = TextFieldPaddingCell(textCell: "")
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
}

class TextFieldPaddingCell: NSTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let paddingWidth: CGFloat = 8
        return rect.insetBy(dx: paddingWidth, dy: 0)
    }
}
