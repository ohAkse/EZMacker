//
//  ConcurrentConfiguration.swift
//  EZMackerThreadLib
//
//  Created by 박유경 on 9/15/24.
//

import Foundation

public struct WifiScanQueueConfiguration: ConcurrentQueueConfigurable {
    public init() {}
    public var label: String {
        return "[Concurrent]wifiScan"
    }
    public var attributes: DispatchQueue.Attributes {
        return .concurrent
    }
    public var signpostName: StaticString {
        return "WifiScanQueue"
    }
}

public struct CommandRunQueueConfiguration: ConcurrentQueueConfigurable {
    public init() {}
    public var label: String {
        return "[Concurrent]commandRun"
    }
    public var attributes: DispatchQueue.Attributes {
        return .concurrent
    }
    public var signpostName: StaticString {
        return "CommandRunQueue"
    }
}
