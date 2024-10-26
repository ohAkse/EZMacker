//
//  ImageSenderBridge.h
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

// ImageProcessBridge.h

#import <Foundation/Foundation.h>
#import "FlipType.h"
#import "RotateType.h"
NS_ASSUME_NONNULL_BEGIN

@interface ImageProcessBridge : NSObject

- (instancetype)init;
- (void)dealloc;
- (nullable NSData *)rotateImageSync:(nullable NSData *)imageData rotateType:(RotateType)rotateType;
- (void)rotateImageAsync:(nullable NSData *)imageData
              rotateType:(RotateType)rotateType
             completion:(void(^)(NSData * _Nullable resultData))completion;
- (void)flipImageAsync:(nullable NSData *)imageData
              flipType:(FlipType)flipType
             completion:(void(^)(NSData * _Nullable resultData))completion;

@end

NS_ASSUME_NONNULL_END
