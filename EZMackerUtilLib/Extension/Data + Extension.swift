//
//  Data + Extension.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public extension Data {
    func toHyphenSeparatedMACAddress() -> String {
        return self.map { String(format: "%02X", $0) }.joined(separator: "-")
    }
}
