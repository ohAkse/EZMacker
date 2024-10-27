//
//  FilterPopupView.swift
//  EZMacker
//
//  Created by 박유경 on 10/12/24.
//

import SwiftUI

struct EZFilterPopupView: View {
    @Binding var isPresented: Bool
    let completion: (String) -> Void
    
    let filters: [[FilterItem]] = [
        [
            FilterItem(title: "흑백", systemImage: "circle.lefthalf.filled", effect: "blackAndWhite"),
            FilterItem(title: "세피아", systemImage: "camera.filters", effect: "sepia")
        ],
        [
            FilterItem(title: "빈티지", systemImage: "photo.artframe", effect: "vintage"),
            FilterItem(title: "선명하게", systemImage: "wand.and.stars", effect: "sharpen")
        ],
        [
            FilterItem(title: "블러", systemImage: "circle.circle", effect: "blur"),
            FilterItem(title: "엠보싱", systemImage: "square.3.layers.3d", effect: "emboss")
        ],
        [
            FilterItem(title: "스케치", systemImage: "pencil.and.outline", effect: "sketch"),
            FilterItem(title: "네거티브", systemImage: "pencil.and.outline", effect: "negative")
        ]
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer(minLength: 5)
            
            Text("이미지")
                .font(.headline)
            
            VStack(spacing: 10) {
                ForEach(filters, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.title) { filter in
                            EZFilterButtonView(
                                title: filter.title,
                                systemImage: filter.systemImage,
                                action: { completion(filter.effect) }
                            )
                        }
                    }
                }
            }
            VStack(spacing: 10) {
                HStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0)
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Text("닫기")
                            .fixedSize()
                            .frame(width: 10, height: 10)
                            .contentShape(Rectangle())
                    })
                    .ezButtonStyle()
                    Spacer(minLength: 0)
                }
            }
            
            Spacer(minLength: 5)
        }
        .ezPopupStyle(height: 350)
    }
}
