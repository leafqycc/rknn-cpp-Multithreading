set -e

# TARGET_SOC="rk3588"
GCC_COMPILER=aarch64-linux-gnu

export LD_LIBRARY_PATH=${TOOL_CHAIN}/lib64:$LD_LIBRARY_PATH
export CC=${GCC_COMPILER}-gcc
export CXX=${GCC_COMPILER}-g++

ROOT_PWD=$( cd "$( dirname $0 )" && cd -P "$( dirname "$SOURCE" )" && pwd )

# build
BUILD_DIR=${ROOT_PWD}/build/build_linux_aarch64

if [ ! -d "${BUILD_DIR}" ]; then
  mkdir -p ${BUILD_DIR}
fi

cd ${BUILD_DIR}
cmake ../.. -DCMAKE_SYSTEM_NAME=Linux
make -j8
make install
cd -

# relu版本
cd install/rknn_yolov5_demo_Linux/ && ./rknn_yolov5_demo ./model/RK3588/yolov5s-640-640.rknn ../../720p60hz.mp4
# silu版本
# cd install/rknn_yolov5_demo_Linux/ && ./rknn_yolov5_demo ./model/RK3588/yolov5s.rknn ../../720p60hz.mp4
# 使用摄像头
# cd install/rknn_yolov5_demo_Linux/ && ./rknn_yolov5_demo ./model/RK3588/yolov5s-640-640.rknn 0

