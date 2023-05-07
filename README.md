# 简介
* 此仓库为c++实现, 大体改自[rknpu2](https://github.com/rockchip-linux/rknpu2), python快速部署见于[rknn-multi-threaded](https://github.com/leafqycc/rknn-multi-threaded)
* 使用[线程池](https://github.com/senlinzhan/dpool)异步操作rknn模型, 提高rk3588/rk3588s的NPU使用率, 进而提高推理帧数
* 此分支使用模型为[yolov5s_relu_tk2_RK3588_i8.rknn](https://github.com/airockchip/rknn_model_zoo/tree/main/models),相较于主分支精度略有下降, 稳定性略有降低, 同线程下CPU占用低10-15%, NPU低5-10% 温度低2-5°, 极限帧率高约10-15帧

# 更新说明
* 无

# 使用说明
### 演示
  * 系统需安装有**OpenCV**
  * 下载Releases中的测试视频于项目根目录,运行build-linux_RK3588.sh
  * 可切换至root用户运行performance.sh定频提高性能和稳定性
  * 编译完成后进入install运行命令./rknn_yolov5_demo **模型所在路径** **视频所在路径/摄像头序号**

### 部署应用
  * 修改include/rknnPool.hpp中的rknn_lite类
  * 修改inclue/rknnPool.hpp中的rknnPool类的构造函数

# 多线程模型帧率测试
* 使用performance.sh进行CPU/NPU定频尽量减少误差
* 测试模型来源: 
* [yolov5s_relu_tk2_RK3588_i8.rknn](https://github.com/airockchip/rknn_model_zoo/tree/main/models)

|  模型\线程数   | 1    |  2   | 3  |  4  | 5  | 6  | 12  | 18  | 24  |
|  ----  | ----  |  ----  | ----  |  ----  | ----  | ----  | ----  | ----  | ----  |
| yolov5s  | 25.1434 | 54.0759 | 78.9150  | 78.0721 | 92.7852 | 106.3192 | 120.8722 | 130.3242 | 136.4224 |

# 补充
* 异常处理尚未完善, 目前仅支持rk3588/rk3588s下的运行
* 可参考[rknn_model_zoo](https://github.com/airockchip/rknn_model_zoo/tree/main/models)进行模型的微调训练, 以适应不同场景下的应用

# Acknowledgements
* https://github.com/rockchip-linux/rknpu2
* https://github.com/senlinzhan/dpool
* https://github.com/ultralytics/yolov5
* https://github.com/airockchip/rknn_model_zoo
* https://github.com/rockchip-linux/rknn-toolkit2
