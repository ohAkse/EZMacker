//
//  AppSmartFileMonitoringService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public protocol AppSmartFileMonitorable {
    func startMonitoring(id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void)
    func stopMonitoring(id: UUID)
}

public class AppSmartFileMonitoringService: AppSmartFileMonitorable {
    
    public init() {}
    private (set) var fileMonitors: [UUID: DispatchSourceFileSystemObject] = [:]
    private (set) var pendingUpdates: [UUID: DispatchWorkItem] = [:]
    private let updateQueue = DispatchQueue(label: "ezMacker.com")

    public func startMonitoring(id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void) {
        let fileDescriptor = open(url.path, O_EVTONLY)
        guard fileDescriptor >= 0 else { return }
        
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
        
        updateQueue.asyncAfter(deadline: .now() + 1.0, execute: workItem)
        pendingUpdates[id] = workItem
    }

    private func processFileChange(for id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void) {
        DispatchQueue.main.async {
            changeHandler(id, url)
        }
    }
}
