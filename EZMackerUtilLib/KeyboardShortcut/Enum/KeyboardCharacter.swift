//
//  KeyboardCharacter.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import SwiftUI

public enum KeyboardCharacter {
    case o
    case n
    case m
    case none
    case comma
    case period
    case slash
    case semicolon
    case apostrophe
    case openSquareBracket
    case closeSquareBracket
    case leftArrow
    case rightArrow
    case topArrow
    case bottomArrow
    case one
    case two
    
    public init(_ keyCode: UInt16) {
        switch keyCode {
        case 0x1D:
            self = .o
        case 0x2E:
            self = .m
        case 0x2D:
            self = .n
        case 0x2B:
            self = .comma
        case 0x2F:
            self = .period
        case 0x2C:
            self = .slash
        case 0x29:
            self = .semicolon
        case 0x27:
            self = .apostrophe
        case 0x21:
            self = .openSquareBracket
        case 0x1E:
            self = .closeSquareBracket
        case 0x7B:
            self = .leftArrow
        case 0x7C:
            self = .rightArrow
        case 0x7E:
            self = .topArrow
        case 0x7D:
            self = .bottomArrow
        case 0x12:
            self = .one
        case 0x13:
            self = .two
        default:
            self = .none
        }
    }
}
