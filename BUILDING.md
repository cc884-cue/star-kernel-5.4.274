# 构建说明

## 已验证配置

此前在 Ubuntu 24.04 环境中使用 Clang/LLVM 14（Clang 14.0.6、LLD 14.0.6）完成了 `Image.gz dtbs modules` 全量构建。构建脚本目标为 ARM64，配置基于 `vendor/lahaina-qgki_defconfig`，并合并 `arch/arm64/configs/vendor/star_QGKI.config` 和 `arch/arm64/configs/vendor/star_root.config`。

这是一份构建流程说明，不代表已在实体设备启动验证。不同发行版、工具链和固件可能产生不同结果。

## 依赖

在 Ubuntu/Debian 系统准备以下工具与开发库：

```sh
sudo apt update
sudo apt install -y \
  bc bison build-essential clang-14 flex gcc-aarch64-linux-gnu \
  libelf-dev libssl-dev lld-14 llvm-14 make python3 rsync
```

请确认系统中存在 `clang-14`、`clang++-14`、`ld.lld-14`、`aarch64-linux-gnu-gcc`，以及 LLVM 14 的 `llvm-ar`、`llvm-nm`、`llvm-objcopy`、`llvm-objdump`、`llvm-strip`、`llvm-readelf`、`llvm-size`、`llvm-addr2line`、`llvm-ranlib` 和 `llvm-strings`。发行版仓库未提供这些版本时，请先配置可信的软件源或安装对应工具链，不要直接替换成未经验证的版本。

## 构建

在源码根目录运行：

```sh
./build.sh
```

可限制并行任务数：

```sh
JOBS=8 ./build.sh
```

脚本会完成 defconfig、合并设备与 ReSukiSU 配置、`olddefconfig`、准备生成头文件，然后构建 `Image.gz`、DTB/DTBO 和内核模块。构建输出位于 `.build/out/`，LLVM 工具别名位于 `.toolchain/bin/`；这两个目录已从 Git 忽略。无需以 root 身份运行编译脚本。成功时脚本会打印 kernel release；本源码版本预期为 `5.4.274-qgki-g4dfe63e0666f`。版本字符串相同不代表设备兼容性已经验证。

主要输出路径：

- `.build/out/arch/arm64/boot/Image.gz`
- `.build/out/arch/arm64/boot/dts/vendor/qcom/`
- `.build/out/` 下按内核配置生成的 `.ko` 模块

## 设备与刷写警告

构建出的内核镜像不是可直接刷写的 `boot.img`。不要把 `Image.gz` 或 DTBO 直接写入分区。打包前必须针对设备当前固件确认 boot header、vendor ramdisk、DTB/DTBO 与 vbmeta 配置；应先备份分区并准备可行的恢复方案。未经验证的镜像可能导致无法启动或数据丢失。
