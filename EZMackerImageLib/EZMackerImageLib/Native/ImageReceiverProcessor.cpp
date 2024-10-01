//
//  ImageReceiverProcessor.cpp
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#include "ImageReceiverProcessor.hpp"

ImageReceiverProcessor::ImageReceiverProcessor(): 
value(10)
{}
ImageReceiverProcessor::~ImageReceiverProcessor(){}

void ImageReceiverProcessor::printValue() noexcept {
    std::cout << "Native Value: " << value << std::endl;
}
void ImageReceiverProcessor::setValueCallback(std::function<void(int)> cb) noexcept{
    callback = cb;
    std::thread([this]() {
        if (this->callback) {
            this->callback(this->value);
        }
    }).detach();
}
