//
//  DispatchQueueFactory.swift
//  EZMackerThreadLib
//
//  Created by 박유경 on 9/14/24.
//

import Foundation

open class DispatchQueueBuilder {
    public init() {}
    public func createQueue(for config: DispatchQueueConfiguration) -> DispatchQueue {
        return DispatchQueue(label: config.label, attributes: config.attributes)
    }
}
