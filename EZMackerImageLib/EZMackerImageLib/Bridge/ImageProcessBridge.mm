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
    ImageProcessor* _processor;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _processor = new ImageProcessor();
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc called");
    delete _processor;
}

- (NSData *)rotateImageSync:(NSData *)imageData rotateType:(RotateType)rotateType {
    if (!imageData) {
        NSLog(@"Input image data is nil");
        return nil;
    }

    @try {
        const unsigned char* bytes = static_cast<const unsigned char*>(imageData.bytes);
        vector<unsigned char> inputVector(bytes, bytes + imageData.length);
        vector<unsigned char> result = _processor->processImageRotateSync(inputVector, rotateType);
        
        if (result.empty()) {
            NSLog(@"Image processing failed");
            return nil;
        }
        
        return [NSData dataWithBytes:result.data() length:result.size()];
    }
    @catch (NSException *exception) {
        NSLog(@"Error processing image: %@", exception);
        return nil;
    }
}

- (void)rotateImageAsync:(NSData *)imageData rotateType:(RotateType)rotateType completion:(void(^)(NSData *))completion {
    if (!imageData) {
        NSLog(@"Input image data is nil");
        if (completion) {
            completion(nil);
        }
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            const unsigned char* bytes = static_cast<const unsigned char*>(imageData.bytes);
            vector<unsigned char> inputVector(bytes, bytes + imageData.length);
            auto futureResult = self->_processor->processImageRotateAsync(inputVector, rotateType);
            auto result = futureResult.get();
            NSData* resultData = nil;
            if (!result.empty()) {
                resultData = [NSData dataWithBytes:result.data()
                                         length:result.size()];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(resultData);
                }
            });
        } @catch (NSException *exception) {
            NSLog(@"Error processing image asynchronously: %@", exception);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil);
                }
            });
        }
    });
}


- (void)flipImageAsync:(NSData *)imageData flipType:(FlipType)flipType completion:(void(^)(NSData *))completion {
    if (!imageData) {
        NSLog(@"Input image data is nil");
        if (completion) completion(nil);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            const unsigned char* bytes = static_cast<const unsigned char*>(imageData.bytes);
            vector<unsigned char> inputVector(bytes, bytes + imageData.length);
            auto futureResult = self->_processor->processImageFlipAsync(inputVector, static_cast<FlipType>(flipType));
            auto result = futureResult.get();
            NSData* resultData = result.empty() ? nil : [NSData dataWithBytes:result.data() length:result.size()];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(resultData);
            });
        } @catch (NSException *exception) {
            NSLog(@"Error processing image asynchronously: %@", exception);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(nil);
            });
        }
    });
}
- (void)filterImageAsync:(NSData *)imageData filterType:(FilterType)filterType completion:(void(^)(NSData *resultData))completion {
    if (!imageData) {
        NSLog(@"Input image data is nil");
        if (completion) completion(nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            if (!self->_processor) {
                NSLog(@"Image processor is not initialized");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(nil);
                });
                return;
            }
            
            const unsigned char* bytes = static_cast<const unsigned char*>(imageData.bytes);
            std::vector<unsigned char> inputVector(bytes, bytes + imageData.length);
            
            auto futureResult = self->_processor->processImageFilterAsync(inputVector, static_cast<FilterType>(filterType));
            auto result = futureResult.get();
            
            NSData* resultData = result.empty() ? nil : [NSData dataWithBytes:result.data() length:result.size()];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(resultData);
            });
        } @catch (NSException *exception) {
            NSLog(@"Error processing image asynchronously: %@", exception);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(nil);
            });
        }
    });
}
@end
