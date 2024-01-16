#!/usr/bin/env bash

set -e

SOURCE_DIR=${SOURCE_DIR:=static_lib}
BUILD_DIR=${BUILD_DIR:=build/iossim/}
OUTPUT_DIR=${OUTPUT_DIR:=output/iossim_static_lib}
ONNXRUNTIME_SOURCE_DIR=${ONNXRUNTIME_SOURCE_DIR:=onnxruntime}
ONNXRUNTIME_VERSION=${ONNXRUNTIME_VERSION:=$(cat ONNXRUNTIME_VERSION)}
CMAKE_OPTIONS=$CMAKE_OPTIONS
CMAKE_BUILD_OPTIONS=$CMAKE_BUILD_OPTIONS

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

cmake \
    -S $SOURCE_DIR \
    -B $BUILD_DIR \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_CONFIGURATION_TYPES=Release \
    -D CMAKE_INSTALL_PREFIX=$OUTPUT_DIR \
    -D ONNXRUNTIME_SOURCE_DIR=$(pwd)/$ONNXRUNTIME_SOURCE_DIR \
    -D CMAKE_SYSTEM_NAME="iOS" \
    -D onnxruntime_BUILD_SHARED_LIB="OFF" \
    -D CMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
    -D CMAKE_OSX_SYSROOT="iphonesimulator" \
    -D CMAKE_OSX_DEPLOYMENT_TARGET="13" \
    -D protobuf_BUILD_PROTOC_BINARIES="OFF" \
    -D onnxruntime_EXTENDED_MINIMAL_BUILD="ON" \
    -D onnxruntime_DISABLE_ML_OPS="ON" \
    -D CMAKE_TOOLCHAIN_FILE="$(pwd)/$ONNXRUNTIME_SOURCE_DIR/cmake/onnxruntime_ios.toolchain.cmake" \
    $CMAKE_OPTIONS

cmake \
    --build $BUILD_DIR \
    --config Release \
    --parallel $PARALLEL_JOB_COUNT \
    $CMAKE_BUILD_OPTIONS
cmake --install $BUILD_DIR --config Release
