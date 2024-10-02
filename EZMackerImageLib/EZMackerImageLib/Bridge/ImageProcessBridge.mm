//
//  ImageSenderBridge.m
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#import <Foundation/Foundation.h>
#import "ImageProcessBridge.h"

#include "ImageProcessor.hpp"

@implementation ImageProcessBridge {
    ImageProcessor* _imageSenderProcessor;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _imageSenderProcessor = new ImageProcessor();
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
- (void)setInt64Callback:(void (^)(int64_t))int64callback {
    _imageSenderProcessor->setInt64Callback([int64callback](int64_t value) {
        int64callback(value);
    });
}
@end
