//
//  Then.swift
//  EZMacker
//
//  Created by 박유경 on 6/11/24.
//

import Foundation

protocol Then {}

extension Then where Self: NSObject {
    @discardableResult
    func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Then {}
