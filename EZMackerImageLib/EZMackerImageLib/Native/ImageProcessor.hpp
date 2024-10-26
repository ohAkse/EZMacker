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
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <future>
#include "FlipType.h"
#include "RotateType.h"
#include "Transform/ImageFlipProcessor.hpp"
#include "Transform/ImageRotateProcessor.hpp"
using namespace std;
using namespace cv;

class ImageProcessor {
private:
    ImageFlipProcessor * m_ImageFlipProcessor;
    ImageRotateProcessor * m_ImageRotateProcessor;
public:
    ImageProcessor();
    ~ImageProcessor();
    
    future<vector<unsigned char>> processImageRotateAsync(const vector<unsigned char>& imageData, RotateType);
    vector<unsigned char> processImageRotateSync(const vector<unsigned char>& imageData, RotateType); // Test
    future<vector<unsigned char>> processImageFlipAsync(const vector<unsigned char>& imageData, FlipType flipType);
};

#endif /* ImageSenderProcessor_hpp */
