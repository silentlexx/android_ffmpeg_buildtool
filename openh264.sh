#!/bin/bash

cd openh264

#make clean

export LIBS="-lm -lpthread -lc"

export arch=$CPU

declare -A arch_abis=(
	["arm"]="armeabi-v7a"
	["arm64"]="arm64-v8a"
	["x86"]="x86"
	["x86_64"]="x86_64"
)

declare -A ndk_levels=(
	["arm"]="18"
	["arm64"]="21"
	["x86"]="18"
	["x86_64"]="21"
)


if [ "$CPU" == "x86" ]; then
	export ASMFLAGS=-DX86_32_PICASM
else
	export ASMFLAGS=
fi

    make OS=android NDKROOT=$NDK TARGET=android-${ndk_levels[$arch]} clean

	make $J PREFIX=$PREFIX OS=android NDKROOT=$NDK TARGET=android-${ndk_levels[$arch]} NDKLEVEL=${ndk_levels[$arch]} ARCH=$arch -C ./ NDK_TOOLCHAIN_VERSION=gcc install-static


