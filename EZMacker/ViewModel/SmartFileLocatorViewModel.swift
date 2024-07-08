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
    private var fileMonitors: [UUID: DispatchSourceFileSystemObject] = [:]
    private var updateQueue = DispatchQueue(label: "com.yourapp.fileUpdateQueue")
    private var pendingUpdates: [UUID: DispatchWorkItem] = [:]
     
    init(appSmartFileService: AppSmartFileProvidable, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartFileService = appSmartFileService
        self.systemPreferenceService = systemPreferenceService
        loadSavedData()
        setupFileMonitors()
    }
    
    private func loadSavedData() {
        DispatchQueue.main.async {
            if let decodedTabs = try? JSONDecoder().decode([String].self, from: self.savedTabs) {
                self.tabs = decodedTabs
            }
            if let decodedFileViews = try? JSONDecoder().decode([String: [UUID: FileInfo]].self, from: self.savedFileViews) {
                self.fileViewsPerTab = decodedFileViews
            }
            self.selectedTab = self.tabs.first
            self.restoreFileAccess()
        }
    }
    
    private func restoreFileAccess() {
        for (tab, fileViews) in fileViewsPerTab {
            for (id, fileInfo) in fileViews {
                if let bookmark = fileInfo.securityScopeBookmark {
                    var isStale = false
                    do {
                        let url = try URL(resolvingBookmarkData: bookmark, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale)
                        if isStale {
                            updateFileInfo(for: id, in: tab, with: url, sendNotification: false)
                        } else {
                            setupFileMonitor(for: id, in: tab, url: url)
                        }
                    } catch {
                        fileViewsPerTab[tab]?.removeValue(forKey: id)
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
        let fileDescriptor = open(url.path, O_EVTONLY)
        guard fileDescriptor >= 0 else { return }
        
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: [.write, .rename, .delete, .attrib],
            queue: .main
        )
        
        source.setEventHandler { [weak self] in
            self?.handleFileChange(for: id, in: tab, url: url)
        }
        
        source.setCancelHandler {
            close(fileDescriptor)
        }
        
        source.resume()
        fileMonitors[id] = source
    }
    
    private func handleFileChange(for id: UUID, in tab: String, url: URL) {
        // 기존 대기 중인 업데이트가 있다면 취소
        pendingUpdates[id]?.cancel()
        
        // 새로운 업데이트 작업 생성
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            if FileManager.default.fileExists(atPath: url.path) {
                // 파일이 여전히 존재하는 경우
                if let oldFileName = self.fileViewsPerTab[tab]?[id]?.fileName,
                   oldFileName != url.lastPathComponent {
                    // 파일 이름이 변경된 경우
                    AppNotificationManager.shared.sendNotification(
                        title: "파일 이름 변경",
                        subtitle: "\(oldFileName) 이름이 변경되었습니다."
                    )
                    
                    // 기존 파일 정보 제거
                    self.fileViewsPerTab[tab]?.removeValue(forKey: id)
                    self.fileMonitors[id]?.cancel()
                    self.fileMonitors.removeValue(forKey: id)
                    
                    // 새 파일로 등록
                    let newID = UUID()
                    self.setFileInfo(fileURL: url, for: newID, in: tab)
                } else {
                    // 파일 내용만 변경된 경우
                    self.updateFileInfo(for: id, in: tab, with: url)
                }
            } else {
                // 파일이 삭제된 경우
                if let deletedFileName = self.fileViewsPerTab[tab]?[id]?.fileName {
                    AppNotificationManager.shared.sendNotification(
                        title: "파일 삭제",
                        subtitle: "\(deletedFileName) 파일이 삭제되었습니다."
                    )
                }
                
                // 파일 정보 제거
                self.fileViewsPerTab[tab]?.removeValue(forKey: id)
                self.fileMonitors[id]?.cancel()
                self.fileMonitors.removeValue(forKey: id)
                
                self.saveData()
                
                // UI 업데이트
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
        
        // 1초 후에 업데이트 실행
        updateQueue.asyncAfter(deadline: .now() + 1.0, execute: workItem)
        
        // 대기 중인 업데이트 저장
        pendingUpdates[id] = workItem
    }
      
    private func updateFileInfo(for id: UUID, in tab: String, with url: URL, sendNotification: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if FileManager.default.fileExists(atPath: url.path) {
                self.appSmartFileService.getFileInfo(fileUrl: url)
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
                            guard var existingFileInfo = self.fileViewsPerTab[tab]?[id] else { return }
                            
                            // 파일 이름 변경 확인
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
                            
                            // 파일 모니터 재설정
                            self.resetFileMonitor(for: id, in: tab, url: fileURL)
                            
                            // UI 업데이트를 위해 objectWillChange 호출
                            self.objectWillChange.send()
                        }
                    )
                    .store(in: &self.cancellables)
            } else {
                print("File not found at path: \(url.path)")
                if let deletedFileName = self.fileViewsPerTab[tab]?[id]?.fileName, sendNotification {
                    AppNotificationManager.shared.sendNotification(
                        title: "파일 삭제",
                        subtitle: "\(deletedFileName) 파일이 삭제되었습니다."
                    )
                }
                self.fileViewsPerTab[tab]?.removeValue(forKey: id)
                self.saveData()
                self.objectWillChange.send()
            }
        }
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
                    self?.fileViewsPerTab[tab]?[id]?.thumbNail = image
                    self?.saveData()
                }
            )
            .store(in: &cancellables)
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
        if let deletedFileName = fileViewsPerTab[tab]?[id]?.fileName {
            AppNotificationManager.shared.sendNotification(
                title: "파일 삭제",
                subtitle: "\(deletedFileName) 파일이 삭제되었습니다."
            )
        }
        fileViewsPerTab[tab]?.removeValue(forKey: id)
        fileMonitors[id]?.cancel()
        fileMonitors.removeValue(forKey: id)
        saveData()
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

    private func resetFileMonitor(for id: UUID, in tab: String, url: URL) {
        // 기존 모니터 제거
        fileMonitors[id]?.cancel()
        fileMonitors.removeValue(forKey: id)
        
        // 새 모니터 설정
        setupFileMonitor(for: id, in: tab, url: url)
    }
}
