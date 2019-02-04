#!/bin/bash

cd x265

rm -r out
mkdir out
cd out

make clean

export LIBS="-lc -lm"

# for arm remove pixel_avg_pp calc_Residual ssd_s  chroma add_ps

if [ $CPU == "arm" ];
then
    export CFLAGS="$CFLAGS -O3 -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__  -DANDROID_ABI=arm-v7a -DHAVE_NEON -DX265_ARCH_ARM"
    export ASM=$CC
    export CMAKE_ASM_FLAGS=$CFLAGS
    ENABLE_ASSEMBLY="OFF"
    CROSS_COMPILE_ARM="ON"
fi

if [ $CPU == "arm64" ];
then
    export CFLAGS="$CFLAGS -O3 -D__ARM_ARCH_8__ -D__ARM_ARCH_8A__ -DANDROID_ABI=arm64-v8a -DHAVE_NEON -DX265_ARCH_ARM"
    export ASM=$AS_ORIG
        export CMAKE_ASM_FLAGS=$CFLAGS
    ENABLE_ASSEMBLY="OFF"
    CROSS_COMPILE_ARM="ON"
fi

if [ $CPU == "x86" ];
then 
  export ASM="/usr/bin/nasm"
  ENABLE_ASSEMBLY="ON"
  CROSS_COMPILE_ARM="OFF"
fi

if [ $CPU == "x86_64" ];
then 
  export ASM="/usr/bin/nasm"
  ENABLE_ASSEMBLY="ON"
  CROSS_COMPILE_ARM="OFF"
fi

CCMF=$(pwd)/crosscompile.cmake

echo \
"set(CROSS_COMPILE_ARM $CROSS_COMPILE_ARM)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_C_COMPILER $CC)
set(CMAKE_CXX_COMPILER \"$CXX\")
set(CMAKE_C_LINK_EXECUTABLE $LD)
set(CMAKE_CXX_LINK_EXECUTABLE $LD)
set(CMAKE_CXX_LINK_EXECUTABLE $LD)
set(CMAKE_ASM_COMPILER $ASM)
set(CMAKE_FIND_ROOT_PATH $PLATFORM)
et(CMAKE_SYSROOT $SYSROOT)" > $CCMF

#-DCMAKE_TOOLCHAIN_FILE=$CCM

cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_SYSROOT=$SYSROOT  -DCMAKE_C_FLAGS="$CFLAGS $LIBS" -DCMAKE_CXX_FLAGS="$CFLAGS $LIBS" -DCMAKE_ASM_FLAGS="$CMAKE_ASM_FLAGS" \
  -DCMAKE_SYSTEM_NAME=Android \
  -DCMAKE_SYSTEM_VERSION=$API \
  -DCMAKE_ANDROID_ABI=$SO_ARCH \
  -DCMAKE_ANDROID_NDK=$NDK \
  -DCMAKE_C_LINK_EXECUTABLE=$LD \
  -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
  -DCMAKE_FIND_ROOT_PATH=$PLATFORM \
  -DANDROID_PIE=ON \
       -DENABLE_SHARED=OFF \
       -DCROSS_COMPILE_ARM=$CROSS_COMPILE_ARM \
       -DENABLE_ASSEMBLY=$ENABLE_ASSEMBLY \
       -DENABLE_CLI=OFF \
       -DENABLE_LIBNUMA=OFF \
       -DENABLE_PIC=ON \
       -DCMAKE_ASM_COMPILER=$ASM \
       -DCMAKE_C_LINK_EXECUTABLE=$LD \
       -DNASM_EXECUTABLE=$ASM \
       -DSTATIC_LINK_CRT=YES \
   ../source && make VERBOSE=1 -j8 && make install
#ccmake ../source 
   