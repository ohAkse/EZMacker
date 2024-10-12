//
//  ImageSenderProcessor.hpp
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#ifndef ImageSenderProcessor_hpp
#define ImageSenderProcessor_hpp

#include <stdio.h>
#include <iostream>
#include <thread>
#include <chrono>

class ImageProcessor {
private:
    int64_t m_value;
    int64_t* m_inoutValue;
    std::function<void(int64_t)> m_int64callback;

public:
    ImageProcessor();
    ~ImageProcessor();
    void setInt64Callback(std::function<void(int64_t)> callback);
    void setValue(int value);
    void updateNativeValue(int64_t* inoutValue);
    void printValue() noexcept;
    void printInoutValue() noexcept;
};

#endif /* ImageSenderProcessor_hpp */
