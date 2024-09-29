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
    int value;

public:
    void setValue(int val);
    int getValue() const;
    void printValue() const;
    int updateAndReturn(int value);
};

#endif /* ImageSenderProcessor_hpp */
