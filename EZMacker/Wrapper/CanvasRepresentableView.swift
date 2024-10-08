//
//  CanvasRepresentableView.swift
//  EZMacker
//
//  Created by 박유경 on 10/5/24.
//

import AppKit
import SwiftUI

struct CanvasRepresentableView: NSViewRepresentable {
    @Binding var currentDrawing: [NSBezierPath]
    @ObservedObject var smartImageTunerViewModel: SmartImageTunerViewModel
    
    func makeNSView(context: Context) -> NSView {
        let view = NSCanvasView().then {
            $0.delegate = context.coordinator
            $0.viewModel = smartImageTunerViewModel
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
    
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
                let newPath = NSBezierPath()
                newPath.move(to: point)
                parent.currentDrawing.append(newPath)
            } else if gestureRecognizer.state == .changed, let currentPath = parent.currentDrawing.last {
                currentPath.line(to: point)
            }
            
            gestureRecognizer.view?.needsDisplay = true
        }
    }
}

class NSCanvasView: NSView {
    weak var delegate: CanvasRepresentableView.Coordinator?
    weak var viewModel: SmartImageTunerViewModel?
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
        
        NSColor.black.set()
        for path in delegate?.parent.currentDrawing ?? [] {
            path.lineWidth = 5
            path.stroke()
        }
    }
}
