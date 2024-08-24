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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSEZTextField(wrappingLabelWithString: "")
            .then {
                $0.delegate = context.coordinator
                $0.font = NSFont.systemFont(ofSize: FontSizeType.extrasmall.size)
                $0.placeholderString = "0-100"
                $0.isBezeled = false
                $0.drawsBackground = false
                $0.backgroundColor = .clear
                $0.isEditable = true
                $0.isSelectable = true
                $0.focusRingType = .none
            }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: TextFieldRepresentableView

        init(parent: TextFieldRepresentableView) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            let filtered = textField.stringValue.filter { "0123456789".contains($0) }
            
            if filtered.isEmpty {
                parent.text = ""
            } else if let intValue = Int(filtered) {
                parent.text = intValue > 100 ? "100" : String(intValue)
            } else {
                parent.text = String(filtered.prefix(3))
            }
            
            textField.stringValue = parent.text
        }
    }
}

class NSEZTextField: NSTextField {
    private let horizontalPadding: CGFloat = 8
    private let verticalPadding: CGFloat = 5
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        self.cell = NSEZTextFieldCell(textCell: "")
    }
    
    override var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        size.width += horizontalPadding * 2
        return size
    }
    
    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        invalidateIntrinsicContentSize()
    }
}

class NSEZTextFieldCell: NSTextFieldCell {
    private let horizontalPadding: CGFloat = 8
    private let verticalPadding: CGFloat = 5
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        let insetRect = cellFrame.insetBy(dx: horizontalPadding, dy: verticalPadding)
        super.drawInterior(withFrame: insetRect, in: controlView)
    }
    
    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        let insetRect = rect.insetBy(dx: horizontalPadding, dy: verticalPadding)
        super.edit(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, event: event)
    }
    
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        let insetRect = rect.insetBy(dx: horizontalPadding, dy: verticalPadding)
        super.select(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        return rect.insetBy(dx: horizontalPadding, dy: verticalPadding)
    }
}
