//
//  FilterPopupView.swift
//  EZMacker
//
//  Created by 박유경 on 10/12/24.
//

import SwiftUI

struct FilterPopupView: View {
    @Binding var isPresented: Bool
    let completion: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("필터")
                .font(.headline)
            Button("흑백") { completion("blackAndWhite") }
            Button("세피아") { completion("sepia") }
            Button("빈티지") { completion("vintage") }
            Button("선명하게") { completion("sharpen") }
            Button("선명하게") { completion("sharpen") }
            Button("선명하게") { completion("sharpen") }
            Button("선명하게") { completion("sharpen") }
        }
        .ezPopupStyle()
    }
}
