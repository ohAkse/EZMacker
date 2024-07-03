//
//  SmartFileViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Combine
import QuickLookThumbnailing

class SmartFileViewModel: ObservableObject {
    @Published var fileInfo: FileInfo = .empty
    
    private let appSmartFileService: AppSmartFileProvidable
    private let systemPreferenceService: SystemPreferenceAccessible
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        Logger.writeLog(.debug, message: "SmartFileViewModel deinit Called")
    }
    
    init(appSmartFileService: AppSmartFileProvidable, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartFileService = appSmartFileService
        self.systemPreferenceService = systemPreferenceService
    }
    
    func setFileInfo(fileURL: URL) {
        appSmartFileService.getFileInfo(fileUrl: fileURL)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        Logger.writeLog(.error, message: "Error getting file info: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] (fileName, fileSize, fileType, fileURL) in
                    self?.fileInfo.fileName = fileName
                    self?.fileInfo.fileSize = fileSize
                    self?.fileInfo.fileType = fileType
                    self?.fileInfo.fileURL = fileURL
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
                    self?.fileInfo.thumbNail = image
                }
            )
            .store(in: &cancellables)
    }
}
