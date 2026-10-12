# SUSFS 全功能实验发布说明

此文件说明源码分支 `experiment/susfs-full-v420` 及对应的实验构建发布。它不替换 `main` 或既有稳定发布。

## 已知许可证问题

SUSFS 上游项目将实现标注为 **GPL-3.0-or-later**，而本项目的 Linux 内核基线标注为 **GPL-2.0-only**。两种许可证之间的兼容性问题**尚未解决**，也未完成独立法律审查。此次发布是明确标注风险的实验性公开测试材料；发布本身不表示许可证兼容性已得到确认，也不构成法律意见。请在复用或再分发前自行审查相关许可证和义务。

参考实现：[ikun-1145141/android_kernel_xiaomi_sm8350_star](https://github.com/ikun-1145141/android_kernel_xiaomi_sm8350_star)。

## 构建及设备状态

- 内核版本：`5.4.274-qgki-susfs-exp`
- ReSukiSU：`v4.2.0-rc2`（commit `3576e6a5`）
- SUSFS：完整实验配置；启用选定的隐藏、伪装及重定向功能
- 构建：`Image.gz`、DTB/DTBO 和 91 个模块全量构建完成；gzip 完整性检查通过
- 真机状态：**未在实体 Xiaomi Mi 11 Ultra 上启动或测试**；厂商模块/KMI 兼容性未经验证

## 发布附件与安全提示

发布归档包含内核 `Image.gz`、`lahaina.dtb`、`star-sm8350-overlay.dtbo`、91 个 `.ko` 模块、内核配置、模块构建元数据和校验和。

这些二进制**不是可直接刷入的 `boot.img`**。不要把 `Image.gz` 或 DTBO 直接写入分区。设备启动镜像必须按当前固件正确组合 boot header、vendor ramdisk、DTB/DTBO 与 vbmeta；刷写前须核对设备布局、备份并准备恢复方案。

愿意协助验证的测试者请注明设备型号、固件版本、发布版本与启动结果；分享日志前请移除个人信息。
