//
//  Data + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 8/24/24.
//

import Foundation

extension Data {
    func toHyphenSeparatedMACAddress() -> String {
        return self.map { String(format: "%02X", $0) }.joined(separator: "-")
    }
}
