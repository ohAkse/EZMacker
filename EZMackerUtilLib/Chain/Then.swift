//
//  Then.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public protocol Then {}

public extension Then where Self: NSObject {
    @discardableResult
    func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Then {}
