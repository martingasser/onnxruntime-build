#!/usr/bin/env bash

set -e

SOURCE_DIR=${SOURCE_DIR:=static_lib}
BUILD_DIR=${BUILD_DIR:=build/android/}
OUTPUT_DIR=${OUTPUT_DIR:=output/android_static_lib}
ONNXRUNTIME_SOURCE_DIR=${ONNXRUNTIME_SOURCE_DIR:=onnxruntime}
ONNXRUNTIME_VERSION=${ONNXRUNTIME_VERSION:=$(cat ONNXRUNTIME_VERSION)}
CMAKE_OPTIONS=$CMAKE_OPTIONS
CMAKE_BUILD_OPTIONS=$CMAKE_BUILD_OPTIONS

ANDROID_NDK_DIR=$1

CPU_COUNT=$(sysctl -n hw.physicalcpu)
PARALLEL_JOB_COUNT=${PARALLEL_JOB_COUNT:=$CPU_COUNT}

cd $(dirname $0)

(
    git submodule update --init --depth=1 $ONNXRUNTIME_SOURCE_DIR
    cd $ONNXRUNTIME_SOURCE_DIR
    if [ $ONNXRUNTIME_VERSION != $(cat VERSION_NUMBER) ]; then
        git fetch origin tag v$ONNXRUNTIME_VERSION
        git checkout v$ONNXRUNTIME_VERSION
    fi
    git submodule update --init --depth=1 --recursive
)


build_abi() {
  ANDROID_ABI="$1"
  cmake \
      -S $SOURCE_DIR \
      -B $BUILD_DIR/$ANDROID_ABI \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_CONFIGURATION_TYPES=Release \
      -D CMAKE_INSTALL_PREFIX=$OUTPUT_DIR/$ANDROID_ABI \
      -D ONNXRUNTIME_SOURCE_DIR=$(pwd)/$ONNXRUNTIME_SOURCE_DIR \
      -D CMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_DIR}/build/cmake/android.toolchain.cmake" \
      -D ANDROID_PLATFORM="android-27" \
      -D ANDROID_ABI=$ANDROID_ABI \
      -D ANDROID_MIN_SDK="27" \
      -D onnxruntime_EXTENDED_MINIMAL_BUILD="ON" \
      -D onnxruntime_DISABLE_ML_OPS="ON" \
      $CMAKE_OPTIONS

  cmake \
      --build $BUILD_DIR/$ANDROID_ABI \
      --config Release \
      --parallel $PARALLEL_JOB_COUNT \
      $CMAKE_BUILD_OPTIONS
  cmake --install $BUILD_DIR/$ANDROID_ABI --config Release
}

build_abi "arm64-v8a"
build_abi "armeabi-v7a"
build_abi "x86"
build_abi "x86_64"