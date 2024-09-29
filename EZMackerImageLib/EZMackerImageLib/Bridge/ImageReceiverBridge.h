//
//  ImageReceiverBridge.h
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#ifndef ImageReceiverBridge_h
#define ImageReceiverBridge_h

@interface ImageReceiverBridge : NSObject
- (instancetype)init;
- (void)printValue;
- (void)receivedCallbackFromNative:(void (^)(int))callback;
@end
#endif /* ImageReceiverBridge_h */
