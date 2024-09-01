//
//  KeyboardModifierFlag.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import SwiftUI

public enum ModifierFlag {
    case option
    case control
    case command
    case shift
    case none

    public init(_ flags: NSEvent.ModifierFlags) {
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
