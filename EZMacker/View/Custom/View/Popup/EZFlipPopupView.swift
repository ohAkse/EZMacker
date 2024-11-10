//
//  EZFlipPopupView.swift
//  EZMacker
//
//  Created by 박유경 on 11/5/24.
//

import SwiftUI
import EZMackerImageLib
struct EZFlipPopupView: View {
    @Binding var isPresented: Bool
    let completion: (FlipType) -> Void
    
    let flipItems: [[FlipItem]] = [
        [
            FlipItem(title: "수평반전", systemImage: "arrow.left.and.right", effect: .Horizontal),
            FlipItem(title: "수직반전", systemImage: "arrow.up.and.down", effect: .Vertical)
        ]
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer(minLength: 5)
            
            Text("이미지")
                .font(.headline)
            
            VStack(spacing: 10) {
                ForEach(flipItems, id: \.self) { row in
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
