//
//  PenToolSetting.swift
//  EZMacker
//
//  Created by 박유경 on 10/19/24.
//
import SwiftUI

struct PenStroke {
    var penPath: NSBezierPath
    var penColor: Color
    var penThickness: CGFloat
}

struct PenToolSetting: Identifiable {
    let id: UUID
    var selectedColor: Color = .accentColor
    var selectedThickness: CGFloat = 2.0
    var penStrokes: [PenStroke] = []

    init(id: UUID = UUID()) {
        self.id = id
    }
}
