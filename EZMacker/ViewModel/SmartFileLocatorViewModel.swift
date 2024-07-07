//
//  SmartFileLocatorViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import Combine
import QuickLookThumbnailing

class SmartFileLocatorViewModel: ObservableObject {
    @Published var fileInfo: FileInfo = .empty
    @Published var tabs: [String] = []
    @Published var selectedTab: String?
    @Published var fileViewsPerTab: [String: [UUID: FileInfo]] = [:]
    
    private let appSmartFileService: AppSmartFileProvidable
    private let systemPreferenceService: SystemPreferenceAccessible
    private var cancellables = Set<AnyCancellable>()
    
    init(appSmartFileService: AppSmartFileProvidable, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartFileService = appSmartFileService
        self.systemPreferenceService = systemPreferenceService
    }
    
    func addTab(_ tabName: String) {
        if !tabs.contains(tabName) {
            tabs.append(tabName)
            selectedTab = tabName
            fileViewsPerTab[tabName] = [:]
        }
    }
    
    func deleteTab(_ tab: String) {
        if let index = tabs.firstIndex(of: tab) {
            tabs.remove(at: index)
            fileViewsPerTab.removeValue(forKey: tab)
            if selectedTab == tab {
                selectedTab = tabs.first
            }
        }
    }
    
    func addFileView(for tab: String) {
        let newID = UUID()
        fileViewsPerTab[tab, default: [:]][newID] = FileInfo.empty
    }
    
    func deleteFileView(id: UUID, from tab: String) {
        fileViewsPerTab[tab]?.removeValue(forKey: id)
    }
    
    func setFileInfo(fileURL: URL, for id: UUID, in tab: String) {
        appSmartFileService.getFileInfo(fileUrl: fileURL)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        Logger.writeLog(.error, message: "Error getting file info: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] (fileName, fileSize, fileType, fileURL) in
                    var updatedFileInfo = FileInfo.empty
                    updatedFileInfo.fileName = fileName
                    updatedFileInfo.fileSize = fileSize
                    updatedFileInfo.fileType = fileType
                    updatedFileInfo.fileURL = fileURL
                    self?.fileViewsPerTab[tab]?[id] = updatedFileInfo
                }
            )
            .store(in: &cancellables)
        
        appSmartFileService.getThumbnail(for: fileURL)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        Logger.writeLog(.error, message: "Error generating thumbnail: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] image in
                    self?.fileViewsPerTab[tab]?[id]?.thumbNail = image
                }
            )
            .store(in: &cancellables)
    }
}
