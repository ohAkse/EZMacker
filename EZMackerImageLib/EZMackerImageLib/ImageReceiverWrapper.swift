//
//  ImageReceiverWrapper.swift
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

public protocol ImageReceiverProvidable {
    func printValues()
    func receivedCallbackFromNative(callback: @escaping (Int) -> Void)
}

public class ImageReceiverWrapper: NSObject, ImageReceiverProvidable {
    private var imageSenderBridge: ImageReceiverBridge
    
    public override init() {
        self.imageSenderBridge = ImageReceiverBridge()
        super.init()
    }
    
    public func printValues() {
        imageSenderBridge.printValue()
    }
    public func receivedCallbackFromNative(callback: @escaping (Int) -> Void) {
        imageSenderBridge.receivedCallback { value in
            callback(Int(value))
        }
    }
}
