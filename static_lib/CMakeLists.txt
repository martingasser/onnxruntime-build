cmake_minimum_required(VERSION 3.26)
project(onnxruntime_static_lib)

set(CMAKE_MSVC_RUNTIME_LIBRARY MultiThreaded)
set(ONNX_USE_MSVC_STATIC_RUNTIME ON)
set(protobuf_MSVC_STATIC_RUNTIME ON)
set(onnxruntime_BUILD_SHARED_LIB ON)

add_subdirectory(${ONNXRUNTIME_SOURCE_DIR}/cmake onnxruntime EXCLUDE_FROM_ALL)
message(STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")

include(bundle_static_library.cmake)
bundle_static_library(${PROJECT_NAME} onnxruntime)

install(
    FILES
    ${ONNXRUNTIME_SOURCE_DIR}/include/onnxruntime/core/session/onnxruntime_c_api.h
    ${ONNXRUNTIME_SOURCE_DIR}/include/onnxruntime/core/session/onnxruntime_cxx_api.h
    ${ONNXRUNTIME_SOURCE_DIR}/include/onnxruntime/core/session/onnxruntime_cxx_inline.h
    ${ONNXRUNTIME_SOURCE_DIR}/include/onnxruntime/core/providers/cpu/cpu_provider_factory.h


    ${ONNXRUNTIME_SOURCE_DIR}/include/onnxruntime/core/session/onnxruntime_float16.h

    ${ONNXRUNTIME_SOURCE_DIR}/include/onnxruntime/core/session/onnxruntime_run_options_config_keys.h
    ${ONNXRUNTIME_SOURCE_DIR}/include/onnxruntime/core/session/onnxruntime_session_options_config_keys.h
    ${ONNXRUNTIME_SOURCE_DIR}/include/onnxruntime/core/framework/provider_options.h
    TYPE INCLUDE
)

install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}${PROJECT_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}
    RENAME ${CMAKE_STATIC_LIBRARY_PREFIX}onnxruntime${CMAKE_STATIC_LIBRARY_SUFFIX}
    TYPE LIB
)
