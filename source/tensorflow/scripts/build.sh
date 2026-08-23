#!/bin/bash
set -euo pipefail

mkdir -p "$HOME/build"
cd "$HOME/build"

rm -rf tensorflow
git clone https://github.com/tensorflow/tensorflow.git --depth 1
cd tensorflow

# --- Python Configuration ---
PYTHON_BIN_PATH=$(which python3)
PYTHON_LIB_PATH=$($PYTHON_BIN_PATH -c 'import site; print(site.getsitepackages()[0])')
export USE_DEFAULT_PYTHON_LIB_PATH=1

export PYTHON_BIN_PATH PYTHON_LIB_PATH

# --- CUDA & GPU Configuration ---
export TF_NEED_CUDA=1

# Hermetic CUDA settings (TensorFlow 2.16+)
export HERMETIC_CUDA_VERSION="13.1.1"
export HERMETIC_CUDNN_VERSION="9.19.1"
export HERMETIC_CUDA_COMPUTE_CAPABILITIES="12.0"

# Local fallback paths & compilation options
export CC_OPT_FLAGS="-Wno-sign-compare"

# Legacy CUDA settings (retained for backward compatibility with inner sub-modules)
export TF_CUDA_VERSION="13.1"
export TF_CUDNN_VERSION="9.19"
export TF_CUDA_COMPUTE_CAPABILITIES="12.0"
GCC_HOST_COMPILER_PATH=$(which gcc)
export GCC_HOST_COMPILER_PATH
export TF_CUDA_CLANG=0

# Disable unused integrations
export TF_NEED_GCP=0
export TF_NEED_HDFS=0
export TF_NEED_S3=0
export TF_NEED_KINESIS=0
export TF_NEED_ROCM=0
export TF_NEED_TENSORRT=0
export TF_NEED_OPENCL_SYCL=0
export TF_NEED_MPI=0
export TF_SET_ANDROID_WORKSPACE=0
export TF_CONFIGURE_IOS=0

# --- Non-Interactive Configuration ---
# 'printf' feeds finite newlines to satisfy default prompts without triggering SIGPIPE (Error 141)
printf '\n%.0s' {1..50} | ./configure

# --- Execute Bazel Build ---
bazel build \
  --jobs=4 \
  --experimental_remote_cache_async \
  --remote_download_outputs=minimal \
  --discard_analysis_cache \
  --notrack_incremental_state \
  --strip=always \
  --repo_env=USE_PYWRAP_RULES=1 \
  --repo_env=WHEEL_NAME=tensorflow \
  -c opt \
  --config=cuda_wheel \
  --config=nogcp \
  --linkopt="-B/usr/bin" \
  --linkopt="-Wl,--no-keep-memory" \
  --copt="-g0" \
  --linkopt="-fuse-ld=lld" \
  --local_resources=memory=8192 \
  //tensorflow/tools/pip_package:wheel

cp "$HOME/build/tensorflow/bazel-bin/tensorflow/tools/pip_package/wheel_house/"*.whl "$HOME/workspace/build/"
