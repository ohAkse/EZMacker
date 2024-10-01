//
//  ImageSenderBridge.h
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#ifndef ImageSenderBridge_h
#define ImageSenderBridge_h
#import <Foundation/Foundation.h>

@interface ImageSenderBridge : NSObject
- (instancetype)init;
- (void)setValue:(int)value;
- (void)printValue;
- (void)printInoutValue;
- (void)updateNativeValue:(int64_t *)value;
@end


#endif /* ImageSenderBridge_h */
