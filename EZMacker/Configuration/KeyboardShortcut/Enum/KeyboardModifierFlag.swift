//
//  KeyboardModifierFlag.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

enum ModifierFlag {
    case option
    case control
    case command
    case shift
    case none

    init(_ flags: NSEvent.ModifierFlags) {
        switch true {
        case flags.contains(.control):
            self = .control
        case flags.contains(.option):
            self = .option
        case flags.contains(.command):
            self = .command
        case flags.contains(.shift):
            self = .shift
        default:
            self = .none
        }
    }
}
