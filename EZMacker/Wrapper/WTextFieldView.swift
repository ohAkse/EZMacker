import SwiftUI
import AppKit

struct WTextField: NSViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: WTextField

        init(parent: WTextField) {
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
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.layer?.cornerRadius = 8
        textField.alignment = .left
        textField.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        textField.placeholderString = "0과 100 사이에 숫자를 입력하세요."
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
}
