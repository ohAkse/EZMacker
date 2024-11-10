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
    m_ImageFilterProcessor = new ImageFilterProcessor();
}

ImageProcessor::~ImageProcessor() {
    cout<<"ImageProcessor deinit called"<<endl;
    if (m_ImageFlipProcessor)
    delete m_ImageFlipProcessor;
    if (m_ImageRotateProcessor)
    delete m_ImageRotateProcessor;
    if (m_ImageFilterProcessor)
    delete m_ImageFilterProcessor;
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

future<vector<unsigned char>> ImageProcessor::processImageFilterAsync(const vector<unsigned char>& imageData, FilterType filterType) {
    return m_ImageFilterProcessor->filterImageAsync(imageData, filterType);
}
