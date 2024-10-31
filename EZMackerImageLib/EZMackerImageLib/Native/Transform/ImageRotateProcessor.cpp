//
//  ImageRotateProcessor.cpp
//  EZMackerImageLib
//
//  Created by 박유경 on 10/26/24.
//

#include "ImageRotateProcessor.hpp"

ImageRotateProcessor::ImageRotateProcessor() {}

ImageRotateProcessor::~ImageRotateProcessor() {
    cout<<"ImageRotateProcessor deinit called"<<endl;
}

vector<unsigned char> ImageRotateProcessor::rotateImageImpl(const vector<unsigned char>& imageData, RotateType rotateType) {
    try {
        Mat image = imdecode(Mat(imageData), IMREAD_UNCHANGED);
        if (image.empty()) {
            throw runtime_error("Failed to decode image");
        }
        cv::Mat rotatedImage;
        cv::rotate(image, rotatedImage, convertToOpenCVRotateFlag(rotateType));

        vector<unsigned char> encodedImage;
        vector<int> params;
        params.push_back(cv::IMWRITE_PNG_COMPRESSION);
        params.push_back(0);

        if (!imencode(".png", rotatedImage, encodedImage, params)) {
            throw runtime_error("Failed to encode image");
        }

        return encodedImage;
    } catch (const Exception& e) {
        cout << "OpenCV error: " << e.what() << endl;
        return vector<unsigned char>();
    }
}

future<vector<unsigned char>> ImageRotateProcessor::rotateImageAsync(const vector<unsigned char>& imageData, RotateType rotateType) {
    return async(launch::async, &ImageRotateProcessor::rotateImageImpl, this, imageData, rotateType);
}

vector<unsigned char> ImageRotateProcessor::rotateImageSync(const vector<unsigned char>& imageData, RotateType rotateType) {
    return rotateImageImpl(imageData, rotateType);
}
