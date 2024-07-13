//
//  SmartFileSearchViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import Combine
import QuickLookThumbnailing

class SmartFileSearchViewModel: ObservableObject {
    @Published var fileInfo: FileInfo = .empty
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        Logger.writeLog(.debug, message: "SmartFileViewModel deinit Called")
    }
    
    init() {
    }
}

