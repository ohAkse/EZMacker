//
//  Reflection + Extension.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/14/24.
//

import Foundation

public protocol Reflectable {
    var typeName: String { get }
}

extension Reflectable {
    var typeName: String {
        return String(describing: type(of: self))
    }
    
    var propertiy: [String: Any] {
        let mirror = Mirror(reflecting: self)
        var props: [String: Any] = [:]
        for child in mirror.children {
            if let label = child.label {
                props[label] = child.value
            }
        }
        return props
    }
    
    var propertyList: [(String, Any)] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap { child in
            guard let label = child.label else { return nil }
            return (label, child.value)
        }
    }
}
