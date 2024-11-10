//
//  EZRotationPopupView.swift
//  EZMacker
//
//  Created by 박유경 on 11/5/24.
//

import SwiftUI
import EZMackerImageLib

struct EZRotationPopupView: View {
    @Binding var isPresented: Bool
    let completion: (RotateType) -> Void
    
    let rotationItems: [[RotationItem]] = [
        [
            RotationItem(title: "90°시계", systemImage: "arrow.clockwise", effect: .ROTATE_90_CLOCKWISE),
            RotationItem(title: "90°반시계", systemImage: "arrow.counterclockwise", effect: .ROTATE_90_COUNTERCLOCKWISE)
        ]
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer(minLength: 5)
            
            Text("회전")
                .font(.headline)
            
            VStack(spacing: 10) {
                ForEach(rotationItems, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.title) { filter in
                            EZPopupButtonView(
                                title: filter.title,
                                systemImage: filter.systemImage,
                                action: { completion(filter.effect) }
                            )
                        }
                    }
                }
            }
            
            HStack(spacing: 10) {
                Spacer()
                
                Button {
                    isPresented = false
                } label: {
                    Text("닫기")
                    .fixedSize()
                    .frame(width: 10, height: 10)
                    .contentShape(Rectangle())
                }
                .ezButtonStyle()
                Spacer()
            }
            
            Spacer(minLength: 5)
        }
        .ezPopupStyle(height: 150)
    }
}
