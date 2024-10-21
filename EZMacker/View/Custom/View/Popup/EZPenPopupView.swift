//
//  DrawToolPopupView.swift
//  EZMacker
//
//  Created by 박유경 on 10/12/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZPenPopupView: View {
    @Binding var isPresented: Bool
    @Binding var penToolSetting: PenToolSetting
    @State private var colorPickerCoordinator: ColorPickerPresentableView.Coordinator?
    let completion: (PenToolSetting) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer(minLength: 5)
            Text("펜")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("굵기: \(Int(penToolSetting.currentStroke.penThickness))")
                Slider(value: $penToolSetting.currentStroke.penThickness, in: 1...20, step: 1)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("색상")
                ColorPickerPresentableView(color: $penToolSetting.currentStroke.penColor)
                    .onAppear {
                        self.colorPickerCoordinator = ColorPickerPresentableView.Coordinator { newColor in
                            self.penToolSetting.currentStroke.penColor = newColor
                        }
                    }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("선 끝 스타일")
                Picker("", selection: $penToolSetting.currentStroke.lineCapStyle) {
                    Text("Round").tag(NSBezierPath.LineCapStyle.round)
                    Text("Butt").tag(NSBezierPath.LineCapStyle.butt)
                    Text("Square").tag(NSBezierPath.LineCapStyle.square)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("선 연결 스타일")
                Picker("", selection: $penToolSetting.currentStroke.lineJoinStyle) {
                    Text("Round").tag(NSBezierPath.LineJoinStyle.round)
                    Text("Miter").tag(NSBezierPath.LineJoinStyle.miter)
                    Text("Bevel").tag(NSBezierPath.LineJoinStyle.bevel)
                }
                .pickerStyle(SegmentedPickerStyle())
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
        .onDisappear {
            colorPickerCoordinator = nil
        }
        .ezPopupStyle(height: 330)
    }
}
