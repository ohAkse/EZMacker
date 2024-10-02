//
//  SmartImageTunerViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 9/28/24.
//

import SwiftUI
import EZMackerImageLib
import EZMackerUtilLib

class SmartImageTunerViewModel: ObservableObject {
    deinit {
        Logger.writeLog(.debug, message: "SmartImageTunerViewModel deinit Called")
    }
    private let imageSenderWrapper: ImageProcessWrapperProvidable
    init(imageSenderWrapper: ImageProcessWrapperProvidable) {
        self.imageSenderWrapper = imageSenderWrapper
    }
}

// CallBack Result From Native
extension SmartImageTunerViewModel {
    func bindNativeOutput() {
        // MARK: ReceiverTest
        imageSenderWrapper.setInt64callback { newValue in
            DispatchQueue.main.async {
                Logger.writeLog(.info, message: "Received updated value from C++: \(newValue)")
            }
        }
    }
    func setInt64() {
        var num: Int64 = 5 // Test Value
        self.imageSenderWrapper.updateNativeValue(inOut: &num)
    }
}
