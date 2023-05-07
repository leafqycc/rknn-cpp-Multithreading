# 简介
* 此仓库为c++实现, 大体改自[rknpu2](https://github.com/rockchip-linux/rknpu2), python快速部署见于[rknn-multi-threaded](https://github.com/leafqycc/rknn-multi-threaded)
* 使用[线程池](https://github.com/senlinzhan/dpool)异步操作rknn模型, 提高rk3588/rk3588s的NPU使用率, 进而提高推理帧数
* [yolov5s](https://github.com/rockchip-linux/rknpu2/tree/master/examples/rknn_yolov5_demo/model/RK3588)使用relu激活函数进行优化,提高量化能力
* **rk3568等**请自行修改include/rknnPool.hpp下的rknn_lite类和rknnPool的构造函数

# 更新说明
* 修复了cmake找不到pthread的问题

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
* [yolov5s-silu](https://github.com/rockchip-linux/rknn-toolkit2/tree/master/examples/onnx/yolov5) 
* [yolov5s-relu](https://github.com/rockchip-linux/rknpu2/tree/master/examples/rknn_yolov5_demo/model/RK3588)
* 测试视频可见于 [bilibili](https://www.bilibili.com/video/BV1zo4y1x7aE/?spm_id_from=333.999.0.0)

|  模型\线程数   | 1    |  2   | 3  |  4  | 5  | 6  | 12  |
|  ----  | ----  |  ----  | ----  |  ----  | ----  | ----  | ----  |
| Yolov5s - silu  | 15.9269  | 32.9192 | 52.8330  | 46.6782 | 58.2921 | 71.8070 |  |
| Yolov5s - relu  | 26.8601 | 58.0305 | 77.6904 | 80.7144 | 93.9126 | 101.1400 | 122.7334 |

# 补充
* 异常处理尚未完善, 目前仅支持rk3588/rk3588s下的运行
* relu版本相较于silu有着较大性能提升, 以及存在一些精度损失, 详情见于[rknn_model_zoo](https://github.com/airockchip/rknn_model_zoo/tree/main/models/CV/object_detection/yolo)

# Acknowledgements
* https://github.com/rockchip-linux/rknpu2
* https://github.com/senlinzhan/dpool
* https://github.com/ultralytics/yolov5
* https://github.com/airockchip/rknn_model_zoo
* https://github.com/rockchip-linux/rknn-toolkit2
