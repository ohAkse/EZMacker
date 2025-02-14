//
//  ImageFilterProcessor.hpp
//  EZMackerImageLib
//
//  Created by 박유경 on 10/30/24.
//

#ifndef ImageFilterProcessor_hpp
#define ImageFilterProcessor_hpp

#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/imgcodecs.hpp>
#include <vector>
#include <future>
#include "FilterType.h"

using namespace std;
using namespace cv;
class ImageFilterProcessor {
public:
    ImageFilterProcessor();
    ~ImageFilterProcessor();

    future<vector<unsigned char>> filterImageAsync(const vector<unsigned char>& imageData, FilterType filterType);
private:
    
};
#endif /* ImageFilterProcessor_hpp */
