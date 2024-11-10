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
        var currentPath: NSBezierPath?
        
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
                gestureRecognizer.view?.setNeedsDisplay(gestureRecognizer.view?.bounds ?? .zero)
            case .ended:
                finishStroke()
            default:
                break
            }
        }

        private func beginNewStroke(at point: CGPoint) {
            currentPath = NSBezierPath()
            currentPath?.move(to: point)
            parent.penToolSetting.currentStroke.penPath = currentPath ?? NSBezierPath()
        }

        private func continueStroke(at point: CGPoint) {
            currentPath?.line(to: point)
            parent.penToolSetting.currentStroke.penPath = currentPath ?? NSBezierPath()
        }

        private func finishStroke() {
            if let path = currentPath {
                var newStroke = parent.penToolSetting.currentStroke
                newStroke.penPath = path
                parent.penToolSetting.addStroke(newStroke)
            }
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
        guard let context = NSGraphicsContext.current?.cgContext else { return }

        for stroke in penToolSetting.penStrokes {
            drawStroke(stroke, in: context)
        }

        if let currentPath = delegate?.currentPath {
            drawStroke(PenStroke(penPath: currentPath,
                                 penColor: penToolSetting.currentStroke.penColor,
                                 penThickness: penToolSetting.currentStroke.penThickness,
                                 lineCapStyle: penToolSetting.currentStroke.lineCapStyle,
                                 lineJoinStyle: penToolSetting.currentStroke.lineJoinStyle,
                                 isEraser: penToolSetting.currentStroke.isEraser),
                       in: context)
        }
    }
    
    private func drawStroke(_ stroke: PenStroke, in context: CGContext) {
        context.applyAntialiasing(true)
        context.saveGState()
        context
            .applyLineWidth(stroke.penThickness)
            .applyLineCap(stroke.lineCapStyle.cgLineCap)
            .applyLineJoin(stroke.lineJoinStyle.cgLineJoin)
            .applyStrokeColor(stroke.penColor.cgColor ?? .clear)
            .applyPath(stroke.penPath.cgPath)
            .strokePath()
        context.restoreGState()
    }
}
