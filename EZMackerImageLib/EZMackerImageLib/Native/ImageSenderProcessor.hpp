//
//  ImageSenderProcessor.hpp
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#ifndef ImageSenderProcessor_hpp
#define ImageSenderProcessor_hpp
#include <iostream>
#include <stdio.h>

class ImageSenderProcessor {
private:
    int64_t m_value;
    int64_t* m_inoutValue;

public:
    ImageSenderProcessor();
    ~ImageSenderProcessor();
    void setValue(int value);
    void updateNativeValue(int64_t* inoutValue);
    void printValue() noexcept;
    void printInoutValue() noexcept;
};

#endif /* ImageSenderProcessor_hpp */
