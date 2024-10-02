//
//  ImageSenderWrapper.swift
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

public protocol ImageProcessWrapperProvidable {
    func setNativeValue(in value: Int)
    func updateNativeValue(inOut value: inout Int64)
    func printNativeValue()
    func printInoutNativeValue()
    func setInt64callback(_ callback: @escaping (Int64) -> Void)
}

public class ImageProcessWrapper: NSObject, ImageProcessWrapperProvidable {
    private var imageSenderBridge: ImageProcessBridge
    
    public override init() {
        self.imageSenderBridge = ImageProcessBridge()
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
    public func setInt64callback(_ callback: @escaping (Int64) -> Void) {
        imageSenderBridge.setInt64Callback { value in
            callback(value)
        }
    }
}
