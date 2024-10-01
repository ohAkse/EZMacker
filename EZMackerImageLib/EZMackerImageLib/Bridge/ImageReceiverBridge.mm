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
    ImageReceiverProcessor* _imageReceiverProcessor;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageReceiverProcessor = new ImageReceiverProcessor();
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ImageReceiverBridge dealloc called");
    delete _imageReceiverProcessor;
}


- (void)printValue {
    _imageReceiverProcessor->printValue();
}
- (void)receivedCallbackFromNative:(void (^)(int))callback {
    _imageReceiverProcessor->setValueCallback([callback](int value) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(value);
        });
    });
}
@end
