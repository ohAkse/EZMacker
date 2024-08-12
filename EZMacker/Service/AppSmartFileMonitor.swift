//
//  AppSmartFileMonitor.swift
//  EZMacker
//
//  Created by 박유경 on 7/13/24.
//

import Foundation

protocol AppSmartFileMonitorable {
    func startMonitoring(id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void)
    func stopMonitoring(id: UUID)
}

class AppSmartFileMonitor: AppSmartFileMonitorable {
    
    private var fileMonitors: [UUID: DispatchSourceFileSystemObject] = [:]
    private let updateQueue = DispatchQueue(label: "ezMacker.com")
    private var pendingUpdates: [UUID: DispatchWorkItem] = [:]

    func startMonitoring(id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void) {
        let fileDescriptor = open(url.path, O_EVTONLY)
        guard fileDescriptor >= 0 else { return }
        
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: [.write, .rename, .delete, .attrib],
            queue: .main
        )
        
        source.setEventHandler { [weak self] in
            self?.handleFileChange(for: id, url: url, changeHandler: changeHandler)
        }
        
        source.setCancelHandler {
            close(fileDescriptor)
        }
        
        source.resume()
        fileMonitors[id] = source
    }

    func stopMonitoring(id: UUID) {
        fileMonitors[id]?.cancel()
        fileMonitors.removeValue(forKey: id)
        pendingUpdates[id]?.cancel()
        pendingUpdates.removeValue(forKey: id)
    }

    private func handleFileChange(for id: UUID, url: URL, changeHandler: @escaping (UUID, URL) -> Void) {
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
