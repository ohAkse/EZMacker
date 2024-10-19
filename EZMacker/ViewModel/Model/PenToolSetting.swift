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

struct PenToolSetting {
    var penStrokes: [PenStroke]
    var selectedColor: Color
    var selectedThickness: CGFloat
    init(penStrokes: [PenStroke] = [], selectedColor: Color = .black, selectedThickness: CGFloat = 2.0) {
        self.penStrokes = penStrokes
        self.selectedColor = selectedColor
        self.selectedThickness = selectedThickness
    }
}
