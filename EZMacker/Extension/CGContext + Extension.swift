//
//  CGContext + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 10/20/24.
//

import CoreGraphics

extension CGContext {
    func applyLineWidth(_ width: CGFloat) -> CGContext {
        self.setLineWidth(width)
        return self
    }
    func applyLineCap(_ cap: CGLineCap) -> CGContext {
        self.setLineCap(cap)
        return self
    }
    
    func applyLineJoin(_ join: CGLineJoin) -> CGContext {
        self.setLineJoin(join)
        return self
    }
    func applyStrokeColor(_ color: CGColor) -> CGContext {
        self.setStrokeColor(color)
        return self
    }
    func applyPath(_ path: CGPath) -> CGContext {
        self.addPath(path)
        return self
    }
    @discardableResult
    func applyAntialiasing(_ isApply: Bool) -> CGContext {
        self.setAllowsAntialiasing(isApply)
        self.setShouldAntialias(isApply)
        return self
    }
    
}
