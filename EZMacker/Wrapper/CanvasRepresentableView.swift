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
        private var currentPath: NSBezierPath?
        
        init(_ parent: CanvasRepresentableView) {
            self.parent = parent
        }

        @objc func addLine(_ gestureRecognizer: NSPanGestureRecognizer) {
            let point = gestureRecognizer.location(in: gestureRecognizer.view)
            
            switch gestureRecognizer.state {
            case .began:
                beginNewStroke(at: point)
            case .changed:
                continueStroke(at: point)
            case .ended:
                finishStroke()
            default:
                break
            }

            gestureRecognizer.view?.needsDisplay = true
        }

        private func beginNewStroke(at point: CGPoint) {
            currentPath = NSBezierPath()
            currentPath?.move(to: point)
        }

        private func continueStroke(at point: CGPoint) {
            currentPath?.line(to: point)
            parent.penToolSetting.penStrokes.append(
                PenStroke(penPath: currentPath!, penColor: parent.penToolSetting.selectedColor, penThickness: parent.penToolSetting.selectedThickness)
            )
        }

        private func finishStroke() {
            currentPath = nil
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
            NSColor(stroke.penColor).set()
            stroke.penPath.then {
                $0.lineCapStyle = .round
                $0.lineJoinStyle = .round
                $0.lineWidth = stroke.penThickness
                $0.stroke()
            }
        }
    }
}
