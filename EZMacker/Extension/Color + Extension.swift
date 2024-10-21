//
//  Color + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 10/19/24.
//

import SwiftUI
import AppKit

extension NSBezierPath.LineCapStyle {
    var cgLineCap: CGLineCap {
        switch self {
        case .butt: return .butt
        case .round: return .round
        case .square: return .square
        @unknown default: return .butt
        }
    }
}

extension NSBezierPath.LineJoinStyle {
    var cgLineJoin: CGLineJoin {
        switch self {
        case .miter: return .miter
        case .round: return .round
        case .bevel: return .bevel
        @unknown default: return .miter
        }
    }
}
