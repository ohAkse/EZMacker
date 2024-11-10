//
//  ImageFlipProcessor.hpp
//  EZMackerImageLib
//
//  Created by 박유경 on 10/26/24.
//

#ifndef ImageFlipProcessor_hpp
#define ImageFlipProcessor_hpp

#include <iostream>
#include <vector>
#include <future>
#include "FlipType.h"
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>

using namespace std;
using namespace cv;
class ImageFlipProcessor {
public:
    ImageFlipProcessor();
    ~ImageFlipProcessor();
    future<std::vector<unsigned char>> flipImageAsync(const std::vector<unsigned char>& imageData, FlipType flipType);

private:
    
};

#endif /* ImageFlipProcessor_hpp */
