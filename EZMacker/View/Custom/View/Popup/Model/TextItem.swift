//
//  TextItem.swift
//  EZMacker
//
//  Created by 박유경 on 11/2/24.
//

import SwiftUI
import EZMackerUtilLib

extension TextItem: Then {}
struct TextItem: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var position: CGPoint
    var fontSize: CGFloat
    var color: Color
    var isEditing: Bool = true
    var size: CGSize
}
