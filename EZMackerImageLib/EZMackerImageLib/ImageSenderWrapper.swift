//
//  ImageSenderWrapper.swift
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

public protocol ImageSenderProvidable {
    func setNativeValue(in value: Int)
    func updateNativeValue(inOut value: inout Int64)
    func printNativeValue()
    func printInoutNativeValue()
}

public class ImageSenderWrapper: NSObject, ImageSenderProvidable {
    private var imageSenderBridge: ImageSenderBridge
    
    public override init() {
        self.imageSenderBridge = ImageSenderBridge()
        super.init()
    }
    public func setNativeValue(in value: Int) {
        imageSenderBridge.setValue(Int32(value))
    }

    public func updateNativeValue(inOut value: inout Int64) {
        imageSenderBridge.updateNativeValue(&value)
    }
    public func printNativeValue() {
        imageSenderBridge.printValue()
    }
    public func printInoutNativeValue() {
        imageSenderBridge.printInoutValue()
    }
}
