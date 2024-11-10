//
//  Then.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation
import CoreGraphics
public protocol Then {}

public extension Then where Self: NSObject {
    @discardableResult
    func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}
public extension Then {
    @discardableResult
    func then(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}
extension CGContext: Then {
    @discardableResult
    public func then(_ block: (CGContext) -> Void) -> CGContext {
        block(self)
        return self
    }
}
extension NSObject: Then {}
