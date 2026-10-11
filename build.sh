#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT"
OUT="$ROOT/.build/out"
TOOLBIN="$ROOT/.toolchain/bin"
JOBS="${JOBS:-$(nproc)}"

for tool in make clang-14 clang++-14 ld.lld-14 aarch64-linux-gnu-gcc python3; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        printf 'Required tool not found: %s\n' "$tool" >&2
        exit 1
    fi
done

# Linux 5.4's LLVM=1 expects unversioned LLVM tool names. Create local aliases
# for LLVM 14 tools without modifying the system installation.
mkdir -p "$TOOLBIN" "$OUT"
for name in clang clang++ ld.lld llvm-ar llvm-nm llvm-objcopy llvm-objdump \
            llvm-strip llvm-readelf llvm-size llvm-addr2line llvm-ranlib \
            llvm-strings llvm-symbolizer; do
    candidate="$(command -v "${name}-14" 2>/dev/null || true)"
    if [[ -n "$candidate" && -x "$candidate" ]]; then
        ln -sf "$candidate" "$TOOLBIN/$name"
    fi
done
for name in llvm-ar llvm-nm llvm-objcopy llvm-objdump llvm-strip llvm-readelf \
            llvm-size llvm-addr2line llvm-ranlib llvm-strings; do
    if [[ ! -x "$TOOLBIN/$name" ]]; then
        printf 'Required LLVM 14 tool not found: %s-14\n' "$name" >&2
        exit 1
    fi
done
export PATH="$TOOLBIN:$PATH"

cd "$SRC"
MAKE_ARGS=(
    "-j$JOBS"
    "O=$OUT"
    "ARCH=arm64"
    "CC=clang-14"
    "HOSTCC=clang-14"
    "HOSTCXX=clang++-14"
    "LD=ld.lld-14"
    "LLVM=1"
    "LLVM_IAS=1"
    "LOCALVERSION="
    "CROSS_COMPILE=aarch64-linux-gnu-"
)

make "${MAKE_ARGS[@]}" vendor/lahaina-qgki_defconfig
scripts/kconfig/merge_config.sh -m -O "$OUT" "$OUT/.config" \
    "$SRC/arch/arm64/configs/vendor/star_QGKI.config" \
    "$SRC/arch/arm64/configs/vendor/star_root.config"
make "${MAKE_ARGS[@]}" olddefconfig
rm -f "$OUT/include/generated/vdso-offsets.h" \
    "$OUT/include/generated/.vdso-offsets.h.cmd" \
    "$OUT/include/generated/vdso32-offsets.h" \
    "$OUT/include/generated/.vdso32-offsets.h.cmd"
make "${MAKE_ARGS[@]}" prepare

# ReSukiSU includes generated SELinux and compiler headers. Build their
# standard producers before the KSU subdirectory to avoid partial-build races.
make "${MAKE_ARGS[@]}" security/selinux/
make "${MAKE_ARGS[@]}" init/version.o

make "${MAKE_ARGS[@]}" Image.gz dtbs modules
printf '\nKernel release: '
make -s "${MAKE_ARGS[@]}" kernelrelease
printf '\nImage: %s\n' "$OUT/arch/arm64/boot/Image.gz"
printf 'DTBs: %s/arch/arm64/boot/dts/vendor/qcom\n' "$OUT"
printf 'Modules: %s\n' "$OUT"
