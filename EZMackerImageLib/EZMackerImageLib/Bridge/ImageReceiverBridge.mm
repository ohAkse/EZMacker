//
//  ImageReceiverBridge.m
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#import <Foundation/Foundation.h>
#import "ImageReceiverBridge.h"

#include "imageReceiverProcessor.hpp"

@implementation ImageReceiverBridge {
    int _value;
    ImageReceiverProcessor* _imageReceiverProcessor;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageReceiverProcessor = new ImageReceiverProcessor();
        _value = 55;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"SmartImageInterfaice dealloc called");
    delete _imageReceiverProcessor;
}


- (void)printValue {
    NSLog(@"Interface 값: %d", _value);
}
- (void)receivedCallbackFromNative:(void (^)(int))callback {
    _imageReceiverProcessor->setCallback([callback](int value) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(value);
        });
    });
}
@end
