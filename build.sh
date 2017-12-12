#!/bin/bash

set -e

IOSSDK_VER="11.1"

\rm -rf build

# xcodebuild -showsdks

xcodebuild -project SDWebImage.xcodeproj -target "SDWebImage iOS static" -configuration Release -sdk iphoneos${IOSSDK_VER} build
xcodebuild -project SDWebImage.xcodeproj -target "SDWebImage iOS static" -configuration Release -sdk iphonesimulator${IOSSDK_VER} build

cd build
# for the fat lib file
mkdir -p Release-iphone/lib
xcrun -sdk iphoneos lipo -create "Release-iphoneos/libSDWebImage iOS static.a" "Release-iphonesimulator/libSDWebImage iOS static.a" -output Release-iphone/lib/libSDWebImage.a
xcrun -sdk iphoneos lipo -info Release-iphone/lib/libSDWebImage.a
# for header files
#mkdir -p Release-iphone/include
#cp ../framework/Source/*.h Release-iphone/include
#cp ../framework/Source/iOS/*.h Release-iphone/include

# Build static framework
mkdir -p SDWebImage.framework/Versions/A
cp Release-iphone/lib/libSDWebImage.a SDWebImage.framework/Versions/A/SDWebImage
mkdir -p SDWebImage.framework/Versions/A/Headers
cp Release-iphoneos/include/SDWebImage/*.h SDWebImage.framework/Versions/A/Headers
cp ../WebImage/SDWebImage.h SDWebImage.framework/Versions/A/Headers
ln -sfh A SDWebImage.framework/Versions/Current
ln -sfh Versions/Current/SDWebImage SDWebImage.framework/SDWebImage
ln -sfh Versions/Current/Headers SDWebImage.framework/Headers
