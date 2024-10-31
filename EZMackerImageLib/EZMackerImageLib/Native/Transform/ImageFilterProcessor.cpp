//
//  ImageFilterProcessor.cpp
//  EZMackerImageLib
//
//  Created by 박유경 on 10/30/24.
//

#include "ImageFilterProcessor.hpp"

ImageFilterProcessor::ImageFilterProcessor() {}

ImageFilterProcessor::~ImageFilterProcessor() {
    cout << "ImageFilterProcessor deinit called" << endl;
}

future<vector<unsigned char>> ImageFilterProcessor::filterImageAsync(const vector<unsigned char>& imageData, FilterType filterType) {
   return async(launch::async, [this, imageData, filterType]() -> vector<unsigned char> {
       try {
           Mat image = imdecode(Mat(imageData), IMREAD_UNCHANGED);
           if (image.empty()) {
               throw runtime_error("Failed to decode image");
           }

           cv::Mat resultMat;

           switch (filterType) {
               case FilterType::BLACK_AND_WHITE:
                   cv::cvtColor(image, resultMat, cv::COLOR_BGRA2GRAY);
                   cv::cvtColor(resultMat, resultMat, cv::COLOR_GRAY2BGRA);
                   break;

               case FilterType::SEPIA: {
                   float sepia_data[] = {
                       0.272f, 0.534f, 0.131f,
                       0.349f, 0.686f, 0.168f,
                       0.393f, 0.769f, 0.189f
                   };
                   cv::Mat sepia_kernel(3, 3, CV_32F, sepia_data);
                   cv::cvtColor(image, image, cv::COLOR_BGRA2BGR);
                   cv::transform(image, resultMat, sepia_kernel);
                   cv::cvtColor(resultMat, resultMat, cv::COLOR_BGR2BGRA);
                   break;
               }

               case FilterType::VINTAGE: {
                   cv::Mat bgrMat;
                   cv::cvtColor(image, bgrMat, cv::COLOR_BGRA2BGR);
                   std::vector<cv::Mat> channels;
                   cv::split(bgrMat, channels);
                   channels[0] *= 0.9;  // B
                   channels[1] *= 0.7;  // G
                   channels[2] *= 1.2;  // R
                   cv::merge(channels, resultMat);
                   cv::cvtColor(resultMat, resultMat, cv::COLOR_BGR2BGRA);
                   break;
               }

               case FilterType::SHARPEN: {
                   float sharpen_data[] = {
                       -1.0f, -1.0f, -1.0f,
                       -1.0f,  9.0f, -1.0f,
                       -1.0f, -1.0f, -1.0f
                   };
                   cv::Mat kernel(3, 3, CV_32F, sharpen_data);
                   cv::cvtColor(image, image, cv::COLOR_BGRA2BGR);
                   cv::filter2D(image, resultMat, -1, kernel);
                   cv::cvtColor(resultMat, resultMat, cv::COLOR_BGR2BGRA);
                   break;
               }

               case FilterType::BLUR:
                   cv::GaussianBlur(image, resultMat, cv::Size(9, 9), 0);
                   break;

               case FilterType::EMBOSS: {
                   float emboss_data[] = {
                       -2.0f, -1.0f,  0.0f,
                       -1.0f,  1.0f,  1.0f,
                        0.0f,  1.0f,  2.0f
                   };
                   cv::Mat kernel(3, 3, CV_32F, emboss_data);
                   cv::cvtColor(image, image, cv::COLOR_BGRA2BGR);
                   cv::filter2D(image, resultMat, -1, kernel, cv::Point(-1, -1), 128);
                   cv::cvtColor(resultMat, resultMat, cv::COLOR_BGR2BGRA);
                   break;
               }

               case FilterType::SKETCH: {
                   cv::Mat gray;
                   cv::cvtColor(image, gray, cv::COLOR_BGRA2GRAY);
                   cv::GaussianBlur(gray, gray, cv::Size(3, 3), 0);
                   cv::Laplacian(gray, gray, CV_8U, 5);
                   cv::bitwise_not(gray, resultMat);
                   cv::cvtColor(resultMat, resultMat, cv::COLOR_GRAY2BGRA);
                   break;
               }

               case FilterType::NEGATIVE:
                   cv::cvtColor(image, image, cv::COLOR_BGRA2BGR);
                   cv::bitwise_not(image, resultMat);
                   cv::cvtColor(resultMat, resultMat, cv::COLOR_BGR2BGRA);
                   break;

               default:
                   throw runtime_error("Unsupported filter type");
           }

           vector<unsigned char> encodedImage;
           vector<int> params;
           params.push_back(cv::IMWRITE_PNG_COMPRESSION);
           params.push_back(0);
           if (!imencode(".png", resultMat, encodedImage, params)) {
               throw runtime_error("Failed to encode image");
           }

           return encodedImage;

       } catch (const Exception& e) {
           cout << "OpenCV error: " << e.what() << endl;
           return vector<unsigned char>();
       }
   });
}
