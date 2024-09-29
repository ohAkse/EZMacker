//
//  ImageSenderProcessor.cpp
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#include "ImageSenderProcessor.hpp"

void ImageSenderProcessor::setValue(int val) {
    value = val;
}

int ImageSenderProcessor::getValue() const {
    return value;
}

void ImageSenderProcessor::printValue() const {
    std::cout << "Native Value: " << value << std::endl;
}
int ImageSenderProcessor::updateAndReturn(int value) {
    this->value = value;
    return value + 2; // 예: 입력값에 2를 더해 반환
}
