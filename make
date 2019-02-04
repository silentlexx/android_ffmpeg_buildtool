#!/bin/bash

SCRIPT=${1}
export CPU=${2}


export ABI=$CPU

TLIB="lib"

export NDKVER="r13b"
export NDK="/home/silentlexx/Android/android-ndk-$NDKVER"
export API=21
export GCCVER="4.9"
export LLVM="false"
NEWSYSROOT="false"

export LANG=en_US.UTF-8
export LANGUAGE=en

if [ $NDKVER == "r19" ];
then
    export LLVM="true"
    NEWSYSROOT="true"
fi

if [ $NDKVER == "r18b" ];
then
    NEWSYSROOT="true"
fi

if [ $CPU == 'arm' ];
then
    export ABI='arm'
    TBIN="arm-linux-androideabi-$GCCVER"  
    export CMAKE_CPU="armv7-a"
    export TARGET="arm-linux-androideabi"
    export ADDI_CFLAGS="-fpic -mcpu=cortex-a8 -march=armv7-a -mfpu=neon -mthumb -mfloat-abi=softfp  \
             -DNDEBUG"
    export SO_ARCH="armeabi-v7a"
    CLANG_TARGET="armv7a-linux-androideabi"
    export API=18
fi


if [ $CPU == 'arm64' ];
then
    export CMAKE_CPU="aarch64"
    export ABI='aarch64'
    TBIN="aarch64-linux-android-$GCCVER"
    export TARGET="aarch64-linux-android"
    export SO_ARCH="arm64-v8a"
    export ADDI_CFLAGS="-fpic -march=armv8-a \
             -DNDEBUG"
    CLANG_TARGET=$TARGET
fi


if [ $CPU == 'x86' ];
then
    export CMAKE_CPU="i686"
    TBIN="x86-$GCCVER"     
    export TARGET="i686-linux-android"
    export ADDI_CFLAGS="-fpic -march=i686 -mtune=atom"
    export SO_ARCH="x86"
    CLANG_TARGET=$TARGET
  #  export ASM="--disable-asm"
    export API=18
fi

if [ $CPU == 'x86_64' ];
then
    export CMAKE_CPU="x86_64"
    ABI='x86_64'
    TBIN="x86_64-$GCCVER"  
    export TARGET="x86_64-linux-android"
    TLIB="lib"
    export ADDI_CFLAGS="-fpic -march=x86-64 -mtune=atom"
    export SO_ARCH="x86_64"
    CLANG_TARGET=$TARGET
fi


STL="gnu-libstdc++/4.9"

if [ $LLVM == "true" ];
then
    TBIN="llvm"
    STL="llvm-libc++"
fi


export TOOLCHAIN="$NDK/toolchains/$TBIN/prebuilt/linux-x86_64"
export PLATFORM="$NDK/platforms/android-$API/arch-$CPU"
export PATH="$PATH:$TOOLCHAIN/bin"
export HOST="--host=$TARGET"
export SYSROOT="$PLATFORM"
export PREFIX=$(pwd)/build/${CPU}-api${API}-${NDKVER}
export CXX_STL="$NDK/sources/cxx-stl/$STL"
export CXX_STL_LIBS="$NDK/sources/cxx-stl/$STL/libs/$SO_ARCH"
export CPUABI=$ABI
export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib --sysroot=$SYSROOT -L$PLATFORM/usr/lib -L$PREFIX/lib -L$NDK/sysroot/usr/lib/$TARGET -L$TOOLCHAIN/lib/gcc/$TARGET/$GCCVER.x -L$CXX_STL_LIBS -fPIE -pie"
export CPPFLAGS="-I$PLATFORM/usr/include -I$PREFIX/include -I$NDK/sysroot/usr/include -I$NDK/sysroot/usr/include/$TARGET -I$CXX_STL/include -I$CXX_STL_LIBS/include"
export CFLAGS_TOOLCHAIN="-fPIC -DANDROID -D__ANDROID_API__=$API -D__ANDROID__ -DPIC -nostdlib  $ADDI_CFLAGS $CPPFLAGS -lc"
export CFLAGS="$CFLAGS_TOOLCHAIN -O3 --sysroot=$SYSROOT "
#export INCLUDE_PATH="$PLATFORM/usr/include;$PREFIX/include;$NDK/sysroot/usr/include;$NDK/sysroot/usr/include/$TARGET;$CXX_STL/include;$CXX_STL_LIBS/include"
export PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig"
export target_host="$TOOLCHAIN/bin/$TARGET"
export CROSS_COMPILE="${target_host}-"
export AR="$target_host-ar"
export AS_ORIG="$target_host-as"
export AS="$target_host-gcc"
export CC="$target_host-gcc"
export CXX="$target_host-g++"
export LD="$target_host-ld"
export STRIP="$target_host-strip"


if [ $LLVM == "true" ];
then
export target_host_clang="$TOOLCHAIN/bin/${CLANG_TARGET}${API}"
export AR="$target_host-ar"
export AS="$target_host-as"
export CC="$target_host_clang-clang"
export CXX="$target_host_clang-clang++"
export LD="$target_host-ld"
export STRIP="$target_host-strip"
fi


if [ ! -f $target_host-pkg-config ];
then
    ln -s /usr/bin/pkg-config $target_host-pkg-config
fi



env > debug_env.txt

pkg-config --list-all

#echo "Build $SCRIPT ($TARGET) [ENTER]:"
#read
echo "Start building...."
bash -c "./$SCRIPT.sh"
echo "Build $SCRIPT ($TARGET) ended!"