# Xiaomi Mi 11 Ultra（star / SM8350）内核：全功能 SUSFS 实验版

> **实验发布：** 本分支 `experiment/susfs-full-v420` 仅供代码审阅和自愿测试，不替换仓库 `main` 或既有 `star-v5.4.274` 稳定发布。

面向 Xiaomi Mi 11 Ultra（设备代号 `star`，Qualcomm SM8350），目标系统为 HyperOS 2 / Android 14。内核源码基线为 LineageOS `android_kernel_xiaomi_sm8350` 的 `lineage-21`，并移植 Linux stable 5.4.269–5.4.274 修复。

## 本实验构建

- Kernel release：`5.4.274-qgki-susfs-exp`
- Root 实现：内置 ReSukiSU `v4.2.0-rc2`（commit `3576e6a5`，`CONFIG_KSU=y`）
- SUSFS：启用全功能实验配置（`CONFIG_KSU_SUSFS=y`，包括隐藏路径、隐藏挂载、kstat、uname/cmdline 伪装、open redirect、sus map 等配置项）
- 分支源码：本分支提交历史及 GitHub 自动生成的源码归档
- 构建附件：[`susfs-full-v5.4.274-exp-v420` 发布页](https://github.com/cc884-cue/star-kernel-5.4.274/releases/tag/susfs-full-v5.4.274-exp-v420)

## 重要：许可证兼容性尚未解决

SUSFS 上游项目将相关实现标注为 **GPL-3.0-or-later**；此内核基线的主许可证为 **GPL-2.0-only**。两者之间可能存在许可证兼容性问题，**该问题尚未解决，也不应将本实验发布理解为兼容性已获确认**。本版本明确作为未完成许可证审查的实验性公开测试材料；请在复用或再分发前自行审查相应许可证与义务。参考实现：[ikun-1145141/android_kernel_xiaomi_sm8350_star](https://github.com/ikun-1145141/android_kernel_xiaomi_sm8350_star)。

## 构建与设备验证状态

`Image.gz`、DTB/DTBO 和 91 个模块已完成全量构建；`Image.gz` gzip 完整性检查通过。**尚未在实体 Xiaomi Mi 11 Ultra 上启动或测试**，也未验证与特定 HyperOS 固件、厂商模块或 KMI 的兼容性。愿意协助测试的用户请在反馈中注明设备型号、固件版本、构建版本、启动结果和相关日志，并避免上传个人数据。

## 下载与刷写警告

发布附件包括 `Image.gz`、`lahaina.dtb`、`star-sm8350-overlay.dtbo`、模块和构建元数据。**这些文件不是可直接刷入的 `boot.img`；不要将 `Image.gz` 或 DTBO 直接写入设备分区。** 实际打包必须匹配设备当前固件的 boot header、vendor ramdisk、DTB/DTBO 组合和 vbmeta 设置。刷写前应核对设备固件布局、备份原分区并准备可靠恢复方式。源码树编译出来的 DTB/DTBO 也须先与设备当前固件核对。

实验构建脚本及配置位于仓库中。构建环境与基本步骤见 [`BUILDING.md`](BUILDING.md)。请保留各文件原有版权及许可证声明；Linux 内核主许可证见 [`COPYING`](COPYING)，ReSukiSU 许可证见 `KernelSU/LICENSE`。本项目与 Xiaomi、LineageOS 或 ReSukiSU 项目无隶属关系。
