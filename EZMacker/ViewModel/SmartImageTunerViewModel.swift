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

    init(imageSenderWrapper: ImageSenderProvidable, imageReceiverWrapper: ImageReceiverProvidable) {
        self.imageSenderWrapper = imageSenderWrapper
        self.imageReceiverWrapper = imageReceiverWrapper
        
        ImageSenderTest()
        imageReceiveTest()
    }
    func ImageSenderTest() {
        // MARK: SenderTest
        imageSenderWrapper.setValues(5)
        imageSenderWrapper.printValues()
        
        let result = imageSenderWrapper.updateAndReturn(5)
        Logger.writeLog(.info, message: result)
    }
    func imageReceiveTest() {
        imageReceiverWrapper.printValues()
        imageReceiverWrapper.receivedCallbackFromNative { value in
            print("Received value from C++: \(value)")
        }
    }
}
