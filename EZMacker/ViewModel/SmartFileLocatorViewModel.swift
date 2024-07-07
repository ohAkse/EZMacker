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
    private let systemPreferenceService: SystemPreferenceAccessible
    private var cancellables = Set<AnyCancellable>()
    
    init(appSmartFileService: AppSmartFileProvidable, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartFileService = appSmartFileService
        self.systemPreferenceService = systemPreferenceService
        loadSavedData()
    }
    
    private func loadSavedData() {
        if let decodedTabs = try? JSONDecoder().decode([String].self, from: savedTabs) {
            self.tabs = decodedTabs
        }
        if let decodedFileViews = try? JSONDecoder().decode([String: [UUID: FileInfo]].self, from: savedFileViews) {
            self.fileViewsPerTab = decodedFileViews
        }
        self.selectedTab = tabs.first
        
        restoreFileAccess()
    }
    
    private func restoreFileAccess() {
        for (tab, fileViews) in fileViewsPerTab {
            for (id, fileInfo) in fileViews {
                if let bookmark = fileInfo.securityScopeBookmark {
                    var isStale = false
                    do {
                        _ = try URL(resolvingBookmarkData: bookmark, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale)
                        if isStale {
                            fileViewsPerTab[tab]?.removeValue(forKey: id)
                        }
                    } catch {
                        fileViewsPerTab[tab]?.removeValue(forKey: id)
                    }
                }
            }
        }
        saveData()
    }
    
    private func renewBookmark(for id: UUID, in tab: String, with url: URL) {
        if let newBookmark = try? url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil) {
            fileViewsPerTab[tab]?[id]?.securityScopeBookmark = newBookmark
            saveData()
        }
    }
    
    private func saveData() {
        if let encodedTabs = try? JSONEncoder().encode(tabs) {
            savedTabs = encodedTabs
        }
        if let encodedFileViews = try? JSONEncoder().encode(fileViewsPerTab) {
            savedFileViews = encodedFileViews
        }
    }
    
    func addTab(_ tabName: String) {
        if !tabs.contains(tabName) {
            tabs.append(tabName)
            selectedTab = tabName
            fileViewsPerTab[tabName] = [:]
            saveData()
        }
    }
    
    func deleteTab(_ tab: String) {
        if let index = tabs.firstIndex(of: tab) {
            tabs.remove(at: index)
            fileViewsPerTab.removeValue(forKey: tab)
            if selectedTab == tab {
                selectedTab = tabs.first
            }
            saveData()
        }
    }
    
    func addFileView(for tab: String) {
        let newID = UUID()
        fileViewsPerTab[tab, default: [:]][newID] = FileInfo.empty
        saveData()
    }
    
    func deleteFileView(id: UUID, from tab: String) {
        fileViewsPerTab[tab]?.removeValue(forKey: id)
        saveData()
    }
    
    func setFileInfo(fileURL: URL, for id: UUID, in tab: String) {
        appSmartFileService.getFileInfo(fileUrl: fileURL)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] (fileName, fileSize, fileType, fileURL, Date) in
                    var updatedFileInfo = FileInfo(fileName: fileName, fileSize: fileSize, fileType: fileType, fileURL: fileURL, tab: tab, modificationDate: Date)
                    
                    if let bookmarkData = try? fileURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil) {
                        updatedFileInfo.securityScopeBookmark = bookmarkData
                    }
                    
                    self?.fileViewsPerTab[tab]?[id] = updatedFileInfo
                    self?.saveData()
                }
            )
            .store(in: &cancellables)
        
        appSmartFileService.getThumbnail(for: fileURL)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] image in
                    self?.fileViewsPerTab[tab]?[id]?.thumbNail = image
                    self?.saveData()
                }
            )
            .store(in: &cancellables)
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
            NSWorkspace.shared.open(url)
        } catch {
            Logger.writeLog(.info, message: error.localizedDescription)
        }
    }
}
