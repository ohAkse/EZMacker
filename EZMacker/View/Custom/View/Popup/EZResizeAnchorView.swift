//
//  EZResizeAnchorView.swift
//  EZMacker
//
//  Created by 박유경 on 11/3/24.
//

import SwiftUI

struct EZResizeAnchorView: View {
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 10, height: 10)
            .overlay(Circle().stroke(Color.blue, lineWidth: 1))
    }
}
