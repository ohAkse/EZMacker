//
//  ImageRotateProcessor.hpp
//  EZMackerImageLib
//
//  Created by 박유경 on 10/26/24.
//

#ifndef ImageRotateProcessor_hpp
#define ImageRotateProcessor_hpp

#ifdef NO
#undef NO
#endif

#include <iostream>
#include <vector>
#include <future>
#include "RotateType.h"
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>

using namespace std;
using namespace cv;

class ImageRotateProcessor {
public:
    ImageRotateProcessor();
    ~ImageRotateProcessor();
    future<vector<unsigned char>> rotateImageAsync(const vector<unsigned char>& imageData, RotateType RotateType);
    vector<unsigned char> rotateImageSync(const vector<unsigned char>& imageData, RotateType rotateTYpe);
private:
    vector<unsigned char> rotateImageImpl(const vector<unsigned char>& imageData, RotateType rotateType);
    int convertToOpenCVRotateFlag(RotateType type) {
         switch (type) {
             case RotateType::ROTATE_90_CLOCKWISE:
                 return cv::ROTATE_90_CLOCKWISE;
             case RotateType::ROTATE_180:
                 return cv::ROTATE_180;
             case RotateType::ROTATE_90_COUNTERCLOCKWISE:
                 return cv::ROTATE_90_COUNTERCLOCKWISE;
             default:
                 return cv::ROTATE_90_CLOCKWISE;
         }
     }
};

#endif /* ImageRotateProcessor_hpp */
