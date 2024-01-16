# ONNX Runtime Build

This project is to build custom [ONNX Runtime](https://onnxruntime.ai) libraries which are not provided in [the official releases](https://github.com/microsoft/onnxruntime/releases).

Currently supports static library builds only with the default options.

## Building Libraries

### Prerequisites

- [Requirements for building ONNX Runtime for inferencing](https://onnxruntime.ai/docs/build/inferencing.html#prerequisites) (for native build)
- [Requirements for building ONNX Runtime for Web](https://onnxruntime.ai/docs/build/inferencing.html#prerequisites) (for Wasm build)
- Bash
  - On Windows, you can use Git Bash provided by [Git for Windows](https://git-scm.com/download/win).

### Build Scripts

Build for macOS:

```sh
./build-macos-static_lib.sh
```

Build for Wasm:

```sh
./build-wasm-static_lib.sh
```

Build for iOS:

```sh
./build-ios-static_lib.sh
```

Build for iOS simulator:

```sh
./build-iossim-static.sh
```

Build for Android:

Create a .android-env file in the project root and set those values:

```sh
ANDROID_NDK_DIR=
ANDROID_PLATFORM=
ANDROID_MIN_SDK=
```

```sh
./build-android-static_lib.sh
```

Build Apple xcframework: