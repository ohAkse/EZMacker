//
//  SmartFileLocatorViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import Combine
import SwiftUI

class SmartFileLocatorViewModel: ObservableObject {
    @Published var tabs: [String] = []
    @Published var selectedTab: String?
    @Published var fileViewsPerTab: [String: [UUID: FileInfo]] = [:]
    
    @AppStorage("savedTabs") private var savedTabs: Data = Data()
    @AppStorage("savedFileViews") private var savedFileViews: Data = Data()
    
    private let appSmartFileService: AppSmartFileProvidable
    private let appSmartFileMonitor : AppSmartFileMonitorable
    private let systemPreferenceService: SystemPreferenceAccessible
    private var cancellables = Set<AnyCancellable>()
    
     
    init(appSmartFileService: AppSmartFileProvidable, appSmartFileMonitor: AppSmartFileMonitorable, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartFileService = appSmartFileService
        self.appSmartFileMonitor = appSmartFileMonitor
        self.systemPreferenceService = systemPreferenceService
        loadSavedData()
        setupFileMonitors()
    }
    
    // MARK: - Data Management
    
    private func loadSavedData() {
        DispatchQueue.main.async {
            self.tabs = self.decodeSavedData(from: self.savedTabs, defaultValue: [])
            self.fileViewsPerTab = self.decodeSavedData(from: self.savedFileViews, defaultValue: [:])
            self.selectedTab = self.tabs.first
            self.restoreFileAccess()
        }
    }
    
    private func decodeSavedData<T: Decodable>(from data: Data, defaultValue: T) -> T {
        (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
    }
    
    private func saveData() {
        DispatchQueue.main.async {
            self.savedTabs = try! JSONEncoder().encode(self.tabs)
            self.savedFileViews = try! JSONEncoder().encode(self.fileViewsPerTab)
        }
    }
    
    // MARK: - File Management
    
    private func restoreFileAccess() {
        for (tab, fileViews) in fileViewsPerTab {
            for (id, fileInfo) in fileViews {
                if let bookmark = fileInfo.securityScopeBookmark {
                    do {
                        var isStale = false
                        let url = try URL(resolvingBookmarkData: bookmark, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale)
                        if isStale {
                            updateFileInfo(for: id, in: tab, with: url, sendNotification: false)
                        } else {
                            setupFileMonitor(for: id, in: tab, url: url)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.fileViewsPerTab[tab]?.removeValue(forKey: id)
                        }
                    }
                }
            }
        }
        saveData()
    }
    
    private func setupFileMonitors() {
        for (tab, fileViews) in fileViewsPerTab {
            for (id, fileInfo) in fileViews {
                if let url = fileInfo.fileURL {
                    setupFileMonitor(for: id, in: tab, url: url)
                }
            }
        }
    }
    
    private func setupFileMonitor(for id: UUID, in tab: String, url: URL) {
        appSmartFileMonitor.startMonitoring(id: id, url: url) { [weak self] id, url in
            self?.handleFileChange(for: id, in: tab, url: url)
        }
    }
    
    private func handleFileChange(for id: UUID, in tab: String, url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if FileManager.default.fileExists(atPath: url.path) {
                if let oldFileName = self.fileViewsPerTab[tab]?[id]?.fileName,
                   oldFileName != url.lastPathComponent {
                    self.handleFileRename(oldFileName: oldFileName, newURL: url, id: id, tab: tab)
                } else {
                    self.updateFileInfo(for: id, in: tab, with: url)
                }
            } else {
                self.handleFileDeletion(id: id, tab: tab)
            }
        }
    }
    
    private func handleFileRename(oldFileName: String, newURL: URL, id: UUID, tab: String) {
        AppNotificationManager.shared.sendNotification(
            title: "파일 이름 변경",
            subtitle: "\(oldFileName) 이름이 변경되었습니다."
        )
        
        DispatchQueue.main.async {
            self.fileViewsPerTab[tab]?.removeValue(forKey: id)
            self.appSmartFileMonitor.stopMonitoring(id: id)
            
            let newID = UUID()
            self.setFileInfo(fileURL: newURL, for: newID, in: tab)
        }
    }
    
    private func handleFileDeletion(id: UUID, tab: String) {
        if let deletedFileName = fileViewsPerTab[tab]?[id]?.fileName {
            AppNotificationManager.shared.sendNotification(
                title: "파일 삭제",
                subtitle: "\(deletedFileName) 파일이 삭제되었습니다."
            )
        }
        
        DispatchQueue.main.async {
            self.fileViewsPerTab[tab]?.removeValue(forKey: id)
            self.appSmartFileMonitor.stopMonitoring(id: id)
            
            self.saveData()
            self.objectWillChange.send()
        }
    }
    
    private func updateFileInfo(for id: UUID, in tab: String, with url: URL, sendNotification: Bool = true) {
        appSmartFileService.getFileInfo(fileUrl: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error updating file info: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] (fileName, fileSize, fileType, fileURL, date) in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        guard var existingFileInfo = self.fileViewsPerTab[tab]?[id] else { return }
                        
                        if existingFileInfo.fileName != fileName, sendNotification {
                            AppNotificationManager.shared.sendNotification(
                                title: "파일 이름 변경",
                                subtitle: "\(existingFileInfo.fileName)의 이름이 \(fileName)로 변경되었습니다."
                            )
                        }
                        
                        existingFileInfo.fileName = fileName
                        existingFileInfo.fileSize = fileSize
                        existingFileInfo.fileType = fileType
                        existingFileInfo.fileURL = fileURL
                        existingFileInfo.modificationDate = date
                        
                        if let bookmarkData = try? fileURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil) {
                            existingFileInfo.securityScopeBookmark = bookmarkData
                        }
                        
                        self.fileViewsPerTab[tab]?[id] = existingFileInfo
                        self.saveData()
                        self.updateThumbnail(for: id, in: tab, with: fileURL)
                        
                        self.setupFileMonitor(for: id, in: tab, url: fileURL)
                        
                        self.objectWillChange.send()
                    }
                }
            )
            .store(in: &cancellables)
    }

    func setFileInfo(fileURL: URL, for id: UUID, in tab: String) {
        updateFileInfo(for: id, in: tab, with: fileURL, sendNotification: false)
        setupFileMonitor(for: id, in: tab, url: fileURL)
    }

    private func updateThumbnail(for id: UUID, in tab: String, with url: URL) {
        appSmartFileService.getThumbnail(for: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] image in
                    DispatchQueue.main.async {
                        self?.fileViewsPerTab[tab]?[id]?.thumbNail = image
                        self?.saveData()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func addTab(_ tabName: String) {
        DispatchQueue.main.async {
            if !self.tabs.contains(tabName) {
                self.tabs.append(tabName)
                self.selectedTab = tabName
                self.fileViewsPerTab[tabName] = [:]
                self.saveData()
            }
        }
    }
    
    func deleteTab(_ tab: String) {
        DispatchQueue.main.async {
            if let index = self.tabs.firstIndex(of: tab) {
                self.tabs.remove(at: index)
                self.fileViewsPerTab.removeValue(forKey: tab)
                if self.selectedTab == tab {
                    self.selectedTab = self.tabs.first
                }
                self.saveData()
            }
        }
    }
    
    func addFileView(for tab: String) {
        DispatchQueue.main.async {
            let newID = UUID()
            self.fileViewsPerTab[tab, default: [:]][newID] = FileInfo.empty
            self.saveData()
        }
    }
    
    func deleteFileView(id: UUID, from tab: String) {
        DispatchQueue.main.async {
            if let deletedFileName = self.fileViewsPerTab[tab]?[id]?.fileName {
                AppNotificationManager.shared.sendNotification(
                    title: "파일 삭제",
                    subtitle: "\(deletedFileName) 파일이 삭제되었습니다."
                )
            }
            self.fileViewsPerTab[tab]?.removeValue(forKey: id)
            self.appSmartFileMonitor.stopMonitoring(id: id)
            self.saveData()
        }
    }

    func getFileInfo(for id: UUID, in tab: String) -> FileInfo? {
        return fileViewsPerTab[tab]?[id]
    }
    
    func openFile(for id: UUID, in tab: String) {
        guard let fileInfo = getFileInfo(for: id, in: tab),
              let bookmark = fileInfo.securityScopeBookmark else {
            return
        }
        
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmark, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale)
            if isStale {
                updateFileInfo(for: id, in: tab, with: url)
            }
            NSWorkspace.shared.open(url)
        } catch {
            print("Error opening file: \(error.localizedDescription)")
        }
    }
}
