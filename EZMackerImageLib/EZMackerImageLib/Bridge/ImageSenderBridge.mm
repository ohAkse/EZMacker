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
    int _value;
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
    NSLog(@"SmartImageInterfaice dealloc called");
    delete _imageSenderProcessor;
}

- (void)setValue:(int)value {
    _value = value;
}

- (int)getValue {
    return _value;
}
- (void)printValue {
    NSLog(@"Interface 값: %d", [self getValue]);
    _imageSenderProcessor->setValue([self getValue]);
    _imageSenderProcessor->printValue();
    
}
- (int)updateAndReturn:(int)value {
    return _imageSenderProcessor->updateAndReturn(value);
}
@end
