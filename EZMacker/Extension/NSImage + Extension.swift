//
//  NSImage + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 10/5/24.
//

import AppKit

extension NSImage {
    func resize(to newSize: NSSize) -> NSImage {
        let img = NSImage(size: newSize)
        img.lockFocus()
        let ctx = NSGraphicsContext.current
        ctx?.imageInterpolation = .high
        self.draw(in: NSRect(origin: .zero, size: newSize), from: NSRect(origin: .zero, size: size), operation: .copy, fraction: 1)
        img.unlockFocus()
        return img
    }
}
