//
//  EraserPopupView.swift
//  EZMacker
//
//  Created by 박유경 on 10/19/24.
//

import SwiftUI

struct EZAddTextPopupView: View {
    @Binding var isPresented: Bool
    let completion: (String) -> Void
    @State private var text = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("텍스트 추가")
                .font(.headline)
            TextField("텍스트 입력", text: $text)
            Button("추가") { completion(text) }
        }
        .ezPopupStyle()
    }
}
