//
//  ImageSenderProcessor.cpp
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

#include "ImageProcessor.hpp"

ImageProcessor::ImageProcessor() {
    m_ImageFlipProcessor = new ImageFlipProcessor();
    m_ImageRotateProcessor = new ImageRotateProcessor();
}

ImageProcessor::~ImageProcessor() {
    cout<<"ImageProcessor deinit called"<<endl;
    delete m_ImageFlipProcessor;
    delete m_ImageRotateProcessor;
}
future<vector<unsigned char>> ImageProcessor::processImageRotateAsync(const vector<unsigned char>& imageData, RotateType rotateType) {
    return m_ImageRotateProcessor->rotateImageAsync(imageData, rotateType);
}
future<vector<unsigned char>> ImageProcessor::processImageFlipAsync(const vector<unsigned char>& imageData, FlipType flipType) {
    return m_ImageFlipProcessor->flipImageAsync(imageData, flipType);
}
vector<unsigned char> ImageProcessor::processImageRotateSync(const vector<unsigned char>& imageData, RotateType rotateType) {
    return m_ImageRotateProcessor->rotateImageSync(imageData, rotateType);
}
