//
//  ImageSenderBridge.m
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#import <Foundation/Foundation.h>
#import "ImageSenderBridge.h"

#include "ImageSenderProcessor.hpp"

@implementation ImageSenderBridge {
    ImageSenderProcessor* _imageSenderProcessor;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _imageSenderProcessor = new ImageSenderProcessor();
    }
    return self;
}
- (void)dealloc {
    NSLog(@"ImageSenderBridge dealloc called");
    delete _imageSenderProcessor;
}
- (void)setValue:(int)value {
    _imageSenderProcessor->setValue(value);
}
- (void)updateNativeValue:(int64_t *)value {
    return _imageSenderProcessor->updateNativeValue(value);
}
- (void)printValue {
    _imageSenderProcessor->printValue();
}
- (void)printInoutValue {
    _imageSenderProcessor->printInoutValue();
}

@end
