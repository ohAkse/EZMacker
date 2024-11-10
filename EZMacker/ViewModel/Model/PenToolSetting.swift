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
    var lineCapStyle: NSBezierPath.LineCapStyle
    var lineJoinStyle: NSBezierPath.LineJoinStyle
    var isEraser: Bool = false
}

struct PenToolSetting {
    var penStrokes: [PenStroke] = []
    var undoStack: [PenStroke] = []
    var redoStack: [PenStroke] = []
    var currentStroke: PenStroke
    
    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
    init(penColor: Color = .black, penThickness: CGFloat = 5.0, lineCapStyle: NSBezierPath.LineCapStyle = .round, lineJoinStyle: NSBezierPath.LineJoinStyle = .round) {
        self.currentStroke = PenStroke(
                             penPath: NSBezierPath(),
                             penColor: penColor,
                             penThickness: penThickness,
                             lineCapStyle: lineCapStyle,
                             lineJoinStyle: lineJoinStyle )
    }
    mutating func addStroke(_ stroke: PenStroke) {
        penStrokes.append(stroke)
        undoStack.append(stroke)
        redoStack.removeAll()
    }
    mutating func undo() {
         guard canUndo else { return }
         let lastStroke = penStrokes.removeLast()
         undoStack.removeLast()
         redoStack.append(lastStroke)
     }
    mutating func redo() {
         guard canRedo else { return }
         let redoStroke = redoStack.removeLast()
         penStrokes.append(redoStroke)
         undoStack.append(redoStroke)
     }
 }
