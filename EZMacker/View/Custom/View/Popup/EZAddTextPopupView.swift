//
//  EZAddTextPopupView.swift
//  EZMacker
//
//  Created by 박유경 on 10/19/24.
//

import SwiftUI

struct EZAddTextPopupView: View {
    @Binding var isPresented: Bool
    @State private var text: String = ""
    @State private var fontSize: CGFloat = 20
    @State private var selectedColor: Color = .black
    @State private var colorPickerCoordinator: ColorPickerPresentableView.Coordinator?
    let completion: (TextItem) -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("텍스트 추가")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                TextField("텍스트를 입력하세요", text: $text)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("크기: \(Int(fontSize))")
                Slider(value: $fontSize, in: 10...30, step: 1)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("색상")
                ColorPickerPresentableView(color: $selectedColor)
                    .onAppear {
                        self.colorPickerCoordinator = ColorPickerPresentableView.Coordinator { newColor in
                            self.selectedColor = newColor
                        }
                    }
            }
            HStack(spacing: 10) {
                Spacer()
                Button(action: addText) {
                    Text("추가")
                    .fixedSize()
                    .frame(width: 10, height: 10)
                    .contentShape(Rectangle())
                }
                .ezButtonStyle()
                .disabled(text.isEmpty)

                Button(action: dismiss) {
                    Text("취소")
                    .fixedSize()
                    .frame(width: 10, height: 10)
                    .contentShape(Rectangle())
                }
                .ezButtonStyle(type: .type1)
                Spacer()
            }
        }
        .onDisappear {
            colorPickerCoordinator = nil
        }
        .ezPopupStyle(height: 250)
    }

    private func addText() {
        guard !text.isEmpty else { return }
        let newOverlay = TextItem(
            text: text,
            position: CGPoint(x: 200, y: 200),
            fontSize: fontSize,
            color: selectedColor,
            size: CGSize(width: 200, height: 100)
        )
        completion(newOverlay)
        colorPickerCoordinator?.closeColorPanel()
        isPresented = false
    }

    private func dismiss() {
        isPresented = false
    }
}
