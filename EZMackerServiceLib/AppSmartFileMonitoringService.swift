//
//  AppSmartFileMonitoringService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation
import EZMackerThreadLib
public protocol AppSmartFileMonitorable {
    func startMonitoring(id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void)
    func stopMonitoring(id: UUID)
}

public class AppSmartFileMonitoringService: AppSmartFileMonitorable {
    
    public init() {}
    private let fileMonotringQueue = DispatchQueueFactory.createQueue(for: FileMonitoringQueueConfiguration(), withPov: false)
    private(set) var fileMonitors: [UUID: DispatchSourceFileSystemObject] = [:]
    private(set) var pendingUpdates: [UUID: DispatchWorkItem] = [:]

    public func startMonitoring(id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void) {
        let fileDescriptor = open(url.path, O_EVTONLY)
        
        guard fileDescriptor >= 0 else {
            changeHandler(id, url)
            return
        }
        
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: [.write, .rename, .delete, .attrib],
            queue: .main
        )
        
        source.setEventHandler { [weak self] in
            self?.onFileChanged(for: id, url: url, changeHandler: changeHandler)
        }
        
        source.setCancelHandler {
            close(fileDescriptor)
        }
        
        source.resume()
        fileMonitors[id] = source
    }

    public func stopMonitoring(id: UUID) {
        fileMonitors[id]?.cancel()
        fileMonitors.removeValue(forKey: id)
        pendingUpdates[id]?.cancel()
        pendingUpdates.removeValue(forKey: id)
    }

    private func onFileChanged(for id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void) {
        pendingUpdates[id]?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.processFileChange(for: id, url: url, changeHandler: changeHandler)
        }
        
        fileMonotringQueue.asyncAfter(deadline: .now() + 1.0, execute: workItem)
        pendingUpdates[id] = workItem
    }

    private func processFileChange(for id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void) {
        DispatchQueue.main.async {
            changeHandler(id, url)
        }
    }
}
