//
//  NSImage + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 10/5/24.
//

import AppKit

extension NSImage {
    func resize(to newSize: NSSize) -> NSImage {
        guard newSize.width > 0, newSize.height > 0, self.size.width > 0, self.size.height > 0 else {
            return self
        }
        let newImage = NSImage(size: newSize)
        
        newImage.lockFocus()
        let ctx = NSGraphicsContext.current
        ctx?.imageInterpolation = .high
        self.draw(in: NSRect(origin: .zero, size: newSize), from: NSRect(origin: .zero, size: size), operation: .copy, fraction: 1)
        newImage.unlockFocus()
        
        return newImage
    }
}
