//
//  DispatchQueue + Extension.swift
//  EZMackerThreadLib
//
//  Created by 박유경 on 9/15/24.
//

import Foundation
import os.signpost

extension DispatchQueue {
    public func asyncLogging(message: String = #function, execute work: @escaping () -> Void) {
        guard let config = getSpecific(key: DispatchQueueFactory.configKey),
              getSpecific(key: DispatchQueueFactory.loggingEnabledKey) == true else {
            async(execute: work)
            return
        }
        
        let signpostID = OSSignpostID(log: DispatchQueueFactory.log)
        async {
            os_signpost(.begin, log: DispatchQueueFactory.log, name: config.signpostName, signpostID: signpostID, "%{public}s: Task Start: %{public}s", self.label, message)
            work()
            os_signpost(.end, log: DispatchQueueFactory.log, name: config.signpostName, signpostID: signpostID, "%{public}s: Task End: %{public}s", self.label, message)
        }
    }
    
    public func asyncAfterLogging(deadline: DispatchTime, message: String = #function, execute work: @escaping () -> Void) {
        guard let config = getSpecific(key: DispatchQueueFactory.configKey),
              getSpecific(key: DispatchQueueFactory.loggingEnabledKey) == true else {
            asyncAfter(deadline: deadline, execute: work)
            return
        }
        
        let signpostID = OSSignpostID(log: DispatchQueueFactory.log)
        asyncAfter(deadline: deadline) {
            os_signpost(.begin, log: DispatchQueueFactory.log, name: config.signpostName, signpostID: signpostID, "%{public}s: Delayed Task Start: %{public}s", self.label, message)
            work()
            os_signpost(.end, log: DispatchQueueFactory.log, name: config.signpostName, signpostID: signpostID, "%{public}s: Delayed Task End: %{public}s", self.label, message)
        }
    }
    public func eventLogging(event: String) {
        let signpostID = OSSignpostID(log: DispatchQueueFactory.log)
        os_signpost(.event, log: DispatchQueueFactory.log, name: "Event", signpostID: signpostID, "%{public}s: %@", self.label, event)
    }

    public static func asyncGlobalLogging(qos: DispatchQoS.QoSClass = .default, message: String = #function, execute work: @escaping () -> Void) {
        let signpostID = OSSignpostID(log: DispatchQueueFactory.log)
        DispatchQueue.global(qos: qos).async {
            os_signpost(.begin, log: DispatchQueueFactory.log, name: "GlobalQueueTask", signpostID: signpostID, "%{public}s: Task Start: %{public}s", "Global.\(qos)", message)
            work()
            os_signpost(.end, log: DispatchQueueFactory.log, name: "GlobalQueueTask", signpostID: signpostID, "%{public}s: Task End: %{public}s", "Global.\(qos)", message)
        }
    }
}
