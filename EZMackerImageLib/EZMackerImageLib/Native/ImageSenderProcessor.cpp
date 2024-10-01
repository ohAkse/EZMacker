//
//  ImageSenderProcessor.cpp
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#include "ImageSenderProcessor.hpp"
#include <opencv2/opencv.hpp>
#include <opencv2/stitching.hpp>

ImageSenderProcessor::ImageSenderProcessor():
m_value(0), m_inoutValue(nullptr)
{}

ImageSenderProcessor::~ImageSenderProcessor() {}

void ImageSenderProcessor::setValue(int val) {
    m_value = val;
}

void ImageSenderProcessor::printValue() noexcept {
    std::cout << "Native Value: " << m_value << std::endl;
}
void ImageSenderProcessor::printInoutValue() noexcept {
    std::cout << "Native Value: " << *m_inoutValue << std::endl;
}
void ImageSenderProcessor::updateNativeValue(int64_t* inoutValue) {
    this->m_inoutValue = inoutValue;
    *inoutValue = (*inoutValue) + 11;
}
