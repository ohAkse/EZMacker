//
//  ImageReceiverProcessor.hpp
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#ifndef ImageReceiverProcessor_hpp
#define ImageReceiverProcessor_hpp

#include <stdio.h>
#include <iostream>
#include <thread>
#include <chrono>

class ImageReceiverProcessor {
private:
    int value;
    std::function<void(int)> callback;

public:
    ImageReceiverProcessor();
    ~ImageReceiverProcessor();
    
    void printValue() noexcept;
    void setValueCallback(std::function<void(int)> cb) noexcept;
};
#endif /* ImageReceiverProcessor_hpp */
