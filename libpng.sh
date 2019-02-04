#!/bin/bash

cd libpng



if [ $CPU == "arm" ];
then 
  export ASM=$AS
fi

if [ $CPU == "arm64" ];
then 
  export ASM=$AS
  export CFLAGS=$(echo $CFLAGS | sed -i 's/\-O3//g')
fi

if [ $CPU == "x86" ];
then 
  export ASM="nasm"
fi

if [ $CPU == "x86_64" ];
then 
  export ASM="nasm"
  export CFLAGS=$(echo $CFLAGS | sed -i 's/\-O3//g')
fi

export LIBS="-lc -lm"

CCMF=$(pwd)/crosscompile.cmake

echo \
"set(CMAKE_C_COMPILER $CC)
set(CMAKE_CXX_COMPILER \"$CXX\")
set(CMAKE_C_LINK_EXECUTABLE $LD)
set(CMAKE_CXX_LINK_EXECUTABLE $LD)
set(CMAKE_EXE_LINKER_FLAGS \"$LDFLAGS\")
set(CMAKE_ASM_COMPILER $AS)
set(CMAKE_FIND_ROOT_PATH $PLATFORM)
et(CMAKE_SYSROOT $SYSROOT)" > $CCMF

rm -r build
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX  -DCMAKE_SYSROOT=$SYSROOT -DCMAKE_TOOLCHAIN_FILE=$CCM  -DCMAKE_C_FLAGS="$CFLAGS $LIBS" \
  -DCMAKE_SYSTEM_NAME=Android \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_CPU \
  -DCMAKE_SYSTEM_VERSION=$API \
  -DCMAKE_ANDROID_ABI=$ABI \
  -DCMAKE_ANDROID_NDK=$NDK \
  -DCMAKE_C_LINK_EXECUTABLE=$LD \
  -DCMAKE_FIND_ROOT_PATH=$PLATFORM \
  -DCMAKE_BUILD_TYPE=Release \
  -DPNG_SHARED=OFF \
  -DPNG_TESTS=OFF \
 ..

#pwdesc=$(echo $PLATFORM | sed 's_/_\\/_g')
#pwdasm=$(echo $ASM | sed 's_/_\\/_g')
#sed -i -e "s/$pwdasm --sysroot=$pwdesc/$pwdasm /g" ./CMakeFiles/png_static.dir/build.make

make -j8
make install