//
//  DispatchQueueFactory.swift
//  EZMackerThreadLib
//
//  Created by 박유경 on 9/14/24.
//

import Foundation
import os.log

public protocol DispatchQueueFactoryCreatable {
    func createQueue(withPov: Bool) -> DispatchQueue
}

public class DispatchQueueFactory {
    public static let configKey = DispatchSpecificKey<DispatchQueueConfigurable>()
    public static let loggingEnabledKey = DispatchSpecificKey<Bool>()
    static let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "EZMacker", category: .pointsOfInterest)
    
    public static func createQueue(for config: DispatchQueueConfigurable, withPov: Bool = false) -> DispatchQueue {
        switch config {
        case let serialConfig as SerialQueueConfigurable:
            return createSerialQueue(config: serialConfig, withPov: withPov)
        case let concurrentConfig as ConcurrentQueueConfigurable:
            return createConcurrentQueue(config: concurrentConfig, withPov: withPov)
        default:
            fatalError("Unsupported queue configuration")
        }
    }
    
    private static func createSerialQueue(config: SerialQueueConfigurable, withPov: Bool) -> DispatchQueue {
        let queue = DispatchQueue(label: config.label, attributes: config.attributes)
        configureQueue(queue, with: config, withPov: withPov)
        return queue
    }
    
    private static func createConcurrentQueue(config: ConcurrentQueueConfigurable, withPov: Bool) -> DispatchQueue {
        let queue = DispatchQueue(label: config.label, attributes: config.attributes.union(.concurrent))
        configureQueue(queue, with: config, withPov: withPov)
        return queue
    }
    
    private static func configureQueue(_ queue: DispatchQueue, with config: DispatchQueueConfigurable, withPov: Bool) {
        queue.setSpecific(key: configKey, value: config)
        queue.setSpecific(key: loggingEnabledKey, value: withPov)
    }
}
