//
//  ImageFlipProcessor.cpp
//  EZMackerImageLib
//
//  Created by 박유경 on 10/26/24.
//

#include "ImageFlipProcessor.hpp"

ImageFlipProcessor::ImageFlipProcessor() {}

ImageFlipProcessor::~ImageFlipProcessor() {
    cout<<"ImageFlipProcessor deinit called"<<endl;
}

future<vector<unsigned char>> ImageFlipProcessor::flipImageAsync(const vector<unsigned char>& imageData, FlipType flipType) {
    return async(launch::async, [imageData, flipType]() -> vector<unsigned char> {
        try {
            Mat image = imdecode(Mat(imageData), IMREAD_UNCHANGED);
            if (image.empty()) {
                throw runtime_error("Failed to decode image");
            }

            Mat flippedImage;
            flip(image, flippedImage, (flipType == FlipType::Horizontal) ? 1 : 0);

            vector<unsigned char> encodedImage;
            vector<int> params;
            params.push_back(cv::IMWRITE_PNG_COMPRESSION);
            params.push_back(0);

            if (!imencode(".png", flippedImage, encodedImage, params)) {
                throw runtime_error("Failed to encode image");
            }

            return encodedImage;
        } catch (const Exception& e) {
            cout << "OpenCV error: " << e.what() << endl;
            return vector<unsigned char>();
        }
    });
}
