//
//  CanvasRepresentableView.swift
//  EZMacker
//
//  Created by 박유경 on 10/5/24.
//

import AppKit
import SwiftUI

struct CanvasRepresentableView: NSViewRepresentable {
    @Binding var penToolSetting: PenToolSetting
    
    func makeNSView(context: Context) -> NSCanvasView {
        let nsCanvasView = NSCanvasView().then {
            $0.delegate = context.coordinator
            $0.penToolSetting = penToolSetting
        }
        return nsCanvasView
    }
    
    func updateNSView(_ nsView: NSCanvasView, context: Context) {
        nsView.penToolSetting = penToolSetting
        nsView.setNeedsDisplay(nsView.bounds)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CanvasRepresentableView
        
        init(_ parent: CanvasRepresentableView) {
            self.parent = parent
        }
  
        @objc func addLine(_ gestureRecognizer: NSPanGestureRecognizer) {
            let point = gestureRecognizer.location(in: gestureRecognizer.view)
            
            if gestureRecognizer.state == .began {
                beginNewStroke(at: point)
                
            } else if gestureRecognizer.state == .changed {
                continueStroke(at: point)
            }

            gestureRecognizer.view?.needsDisplay = true
        }

        private func beginNewStroke(at point: CGPoint) {
            let newPath = NSBezierPath()
            newPath.move(to: point)
            
            parent.penToolSetting.penStrokes.append(
                PenStroke(penPath: newPath, penColor: parent.penToolSetting.selectedColor, penThickness: parent.penToolSetting.selectedThickness)
            )
        }

        private func continueStroke(at point: CGPoint) {
            guard let currentStroke = parent.penToolSetting.penStrokes.last else { return }
            currentStroke.penPath.line(to: point)
        }
    }
}

class NSCanvasView: NSView {
    weak var delegate: CanvasRepresentableView.Coordinator?
    var penToolSetting: PenToolSetting = .init()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configGesture()
    }
    
    private func configGesture() {
        let panGesture = NSPanGestureRecognizer(target: self, action: #selector(configPenGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func configPenGesture(_ gesture: NSPanGestureRecognizer) {
        delegate?.addLine(gesture)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        for stroke in penToolSetting.penStrokes {
            let nsColor = NSColor(stroke.penColor)
            nsColor.set()
            
            stroke.penPath.lineWidth = stroke.penThickness
            stroke.penPath.stroke()
        }
    }
}
