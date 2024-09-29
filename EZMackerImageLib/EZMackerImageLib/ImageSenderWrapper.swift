//
//  ImageSenderWrapper.swift
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

public protocol ImageSenderProvidable {
    func setValues(_ value: Int)
    func getValues() -> Int
    func updateAndReturn(_ value: Int) -> Int
    func printValues()
}

public class ImageSenderWrapper: NSObject, ImageSenderProvidable {
    private var imageSenderBridge: ImageSenderBridge
    
    public override init() {
        self.imageSenderBridge = ImageSenderBridge()
        super.init()
    }
    
    public func setValues(_ value: Int) {
        imageSenderBridge.setValue(Int32(value))
    }
    
    public func getValues() -> Int {
        return Int(imageSenderBridge.getValue())
    }
    
    public func printValues() {
        imageSenderBridge.printValue()
    }
    public func updateAndReturn(_ value: Int) -> Int {
        return Int(imageSenderBridge.updateAndReturn(Int32(value)))
    }
}
