//
//  ImageReceiverProcessor.cpp
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#include "ImageReceiverProcessor.hpp"

ImageReceiverProcessor::ImageReceiverProcessor(): value(10){}
ImageReceiverProcessor::~ImageReceiverProcessor() {}

void ImageReceiverProcessor::printValue() const {
    std::cout << "Native Value: " << value << std::endl;
}
void ImageReceiverProcessor::setCallback(std::function<void(int)> cb) {
    callback = cb;
    std::thread([this]() {
        // std::this_thread::sleep_for(std::chrono::seconds(3));
        if (this->callback) {
            this->callback(this->value);
        }
    }).detach();
}
