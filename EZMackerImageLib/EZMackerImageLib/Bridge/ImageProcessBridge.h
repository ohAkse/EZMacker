//
//  ImageSenderBridge.h
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#ifndef ImageSenderBridge_h
#define ImageSenderBridge_h
#import <Foundation/Foundation.h>

@interface ImageProcessBridge : NSObject
- (instancetype)init;
- (void)setValue:(int)value;
- (void)printValue;
- (void)printInoutValue;
- (void)updateNativeValue:(int64_t *)value;
- (void)setInt64Callback:(void (^)(int64_t))int64callback;

@end


#endif /* ImageSenderBridge_h */
