#!/bin/bash

rm -rf build
rm -rf output

sh build-macos-static_lib.sh
sh build-ios-static_lib.sh
sh build-iossim-static_lib.sh
sh build-xcframework.sh

sh build-android-static.sh

sh build-wasm-static_lib.sh