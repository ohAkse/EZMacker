//
//  ImageSenderProcessor.cpp
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#include "ImageProcessor.hpp"
#include <opencv2/opencv.hpp>
#include <opencv2/stitching.hpp>

ImageProcessor::ImageProcessor():
m_value(0), m_inoutValue(nullptr)
{}

ImageProcessor::~ImageProcessor() {}

void ImageProcessor::setValue(int val) {
    m_value = val;
}

void ImageProcessor::printValue() noexcept {
    std::cout << "Native Value: " << m_value << std::endl;
}
void ImageProcessor::printInoutValue() noexcept {
    std::cout << "Native InoutValue: " << *m_inoutValue << std::endl;
}
void ImageProcessor::updateNativeValue(int64_t* inoutValue) {
    // this->m_inoutValue = inoutValue;
    *inoutValue = (*inoutValue) + 11;
    if (this->m_int64callback) {
        this->m_int64callback(*inoutValue);
    }
}
void ImageProcessor::setInt64Callback(std::function<void(int64_t)> callback) {
    m_int64callback = std::move(callback);
}
