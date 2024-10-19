//
//  DrawToolPopupView.swift
//  EZMacker
//
//  Created by 박유경 on 10/12/24.
//

import SwiftUI

struct EZPenPopupView: View {
    @Binding var isPresented: Bool
    @Binding var penToolSetting: PenToolSetting
    @State private (set) var colorPickerCoordinator: ColorPickerPresentableView.Coordinator?
    let completion: (PenToolSetting) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer(minLength: 5)
            Text("펜")
                .font(.headline)

            VStack(alignment: .leading, spacing: 10) {
                Text("굵기: \(Int(penToolSetting.selectedThickness))")
                Slider(value: $penToolSetting.selectedThickness, in: 1...20, step: 1)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("색상")
                ColorPickerPresentableView(color: $penToolSetting.selectedColor, label: "색상")
                    .onPreferenceChange(ColorPickerCoordinatorPreferenceKey.self) { coordinator in
                        self.colorPickerCoordinator = coordinator
                    }
            }

            HStack(alignment: .center, spacing: 0) {
                Spacer(minLength: 0)
                Button(action: {
                    colorPickerCoordinator?.closeColorPanel()
                    completion(penToolSetting)
                    isPresented = false
                }, label: {
                    Text("적용")
                        .fixedSize()
                        .frame(width: 10, height: 10)
                        .contentShape(Rectangle())
                })
                .ezButtonStyle()
                Spacer(minLength: 0)
            }
            Spacer(minLength: 5)
        }
        .ezPopupStyle()
    }
}
