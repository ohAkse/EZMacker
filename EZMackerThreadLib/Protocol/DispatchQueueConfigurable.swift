//
//  DispatchQueueConfigurable.swift
//  EZMackerThreadLib
//
//  Created by 박유경 on 9/15/24.
//

import Foundation


public protocol DispatchQueueConfigurable {
    var label: String { get }
    var attributes: DispatchQueue.Attributes { get }
    var signpostName: StaticString { get }
}

public protocol ConcurrentQueueConfigurable: DispatchQueueConfigurable {}
public protocol SerialQueueConfigurable: DispatchQueueConfigurable {}
