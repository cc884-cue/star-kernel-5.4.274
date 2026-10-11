# Xiaomi Mi 11 Ultra（star / SM8350）内核

面向 Xiaomi Mi 11 Ultra（设备代号 `star`，Qualcomm SM8350）的非官方内核源码。目标环境为 HyperOS 2 / Android 14。

## 当前版本与来源

- Kernel release：`5.4.274-qgki-g4dfe63e0666f`
- 源码基线：LineageOS `android_kernel_xiaomi_sm8350` 的 `lineage-21`（Linux 5.4.268）
- 已移植 Linux stable 5.4.269–5.4.274 修复
- 配置目标：`vendor/lahaina-qgki_defconfig`，合并本仓库的 `star_QGKI.config` 与 `star_root.config`
- Root 实现：内置 ReSukiSU `v4.2.0-rc2`（`CONFIG_KSU=y`，manual hooks）

本仓库包含修改后的完整内核源码和构建脚本。构建过程与依赖见 [`BUILDING.md`](BUILDING.md)。构建产物及本机临时文件不纳入源码仓库。

## 构建与验证状态

在 Ubuntu 24.04、Clang/LLVM 14 环境中，`Image.gz dtbs modules` 全量构建成功；`Image.gz` gzip 完整性检查通过，`msm_drm.ko` 的 vermagic 与 kernel release 一致。

**尚未在实体 Xiaomi Mi 11 Ultra 上启动或测试。** 编译成功以及 release 字符串匹配都不能证明它与特定 HyperOS 固件、厂商模块或 KMI 完全兼容。请将其视为实验性源码。

## Root 与其他选项

- 已集成 ReSukiSU；ReSukiSU 管理器和其他用户态组件不包含在本仓库构建产物说明中。
- SUSFS 未启用（`CONFIG_KSU_SUSFS` 未设置）。

## 重要安全提示

本仓库源码**不是可直接刷入的 `boot.img`**。不要将 `Image.gz` 或 DTBO 直接写入设备分区。启动镜像打包必须匹配设备当前固件的 boot header、vendor ramdisk、DTB/DTBO 组合及 vbmeta 设置；操作前应确认镜像布局、备份原分区并准备可靠的恢复方式。源码树编译出来的 `lahaina.dtb` 与 `star-sm8350-overlay.dtbo` 也需要先和设备当前 HyperOS 2 固件核对。

请自行承担构建、打包和刷写风险；本项目不保证适用于所有固件版本，也不承诺数据安全或设备可用性。

## 许可证与致谢

源码树由多个上游组件组成，请遵循各文件及组件原有许可证，并保留版权和许可证声明。Linux 内核主许可证见 [`COPYING`](COPYING)；各子目录许可证见 `LICENSES/`、相关目录中的 `LICENSE` 及源码头部声明。ReSukiSU 的许可证文件位于 `KernelSU/LICENSE`。

感谢 LineageOS、Linux stable、ReSukiSU 及所有原始贡献者。本项目与 Xiaomi、LineageOS 或 ReSukiSU 项目无隶属关系。
