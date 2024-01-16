#!/bin/bash
xcodebuild -create-xcframework \
  -library output/ios_static_lib/lib/libonnxruntime.a \
  -headers output/ios_static_lib/include/ \
  -library output/iossim_static_lib/lib/libonnxruntime.a \
  -headers output/ios_static_lib/include/ \
  -library output/macos_static_lib/lib/libonnxruntime.a \
  -headers output/macos_static_lib/include/ \
  -output output/onnxruntime.xcframework