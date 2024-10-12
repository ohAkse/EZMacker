//
//  DrawToolPopupView.swift
//  EZMacker
//
//  Created by 박유경 on 10/12/24.
//

import SwiftUI

struct DrawToolPopupView: View {
    @Binding var isPresented: Bool
    let completion: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("그리기 도구")
                .font(.headline)
                .padding(.bottom, 5)

            ForEach(["펜", "브러시", "지우개", "색상 선택"], id: \.self) { tool in
                Button(action: {
                    completion(tool.lowercased())
                    isPresented = false
                }, label: {
                    HStack {
                        Image(systemName: imageName(for: tool))
                        Text(tool)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(.white))
                    .cornerRadius(8)
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .frame(width: 250)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 5)
    }

    private func imageName(for tool: String) -> String {
        switch tool {
        case "펜": return "pencil"
        case "브러시": return "paintbrush"
        case "지우개": return "eraser"
        case "색상 선택": return "eyedropper"
        default: return "questionmark"
        }
    }
}
