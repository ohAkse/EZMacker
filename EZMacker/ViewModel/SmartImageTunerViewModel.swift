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
    private let imageSenderWrapper: ImageSenderProvidable
    private let imageReceiverWrapper: ImageReceiverProvidable
    var num: Int64 = 5 // Test Value
    init(imageSenderWrapper: ImageSenderProvidable, imageReceiverWrapper: ImageReceiverProvidable) {
        self.imageSenderWrapper = imageSenderWrapper
        self.imageReceiverWrapper = imageReceiverWrapper
        // Test용
        imageSenderWrapper.updateNativeValue(inOut: &num)
    }
}

// CallBack Result From Native
extension SmartImageTunerViewModel {
    func bindNativeOutput() {
        imageSenderWrapper.printInoutNativeValue()
        // MARK: ReceiverTest
        imageReceiverWrapper.receivedCallbackFromNative { value in
            print("Received value from C++: \(value)")
        }
    }
}
