//
//  EZFilterButtonView.swift
//  EZMacker
//
//  Created by 박유경 on 10/27/24.
//

import SwiftUI

struct EZPopupButtonView: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 13))
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
        .ezPopupButtonStyle()
    }
}
