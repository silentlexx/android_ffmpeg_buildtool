#!/bin/bash

cd freetype

make clean
rm Makefile

export LIBS="-lc"

#./autogen.sh
#./configure --prefix=$PREFIX $HOST  --disable-shared --with-sysroot=$SYSROOT --without-harfbuzz

rm -r build 
mkdir build && cd build
cmake  -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_SYSROOT=$SYSROOT -DCMAKE_TOOLCHAIN_FILE=$CCM -DCMAKE_C_FLAGS="$CFLAGS $LIBS" \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_VERSION=$API \
  -DCMAKE_C_LINK_EXECUTABLE=$LD \
  -DCMAKE_FIND_ROOT_PATH=$PLATFORM \
  -DCMAKE_C_LINK_EXECUTABLE=$LD \
   ..

make -j8
make install


echo \
"prefix=$PREFIX
exec_prefix=$PREFIX
libdir=$PREFIX/lib
includedir=$PREFIX/include

Name: Freetype 2
Description: Freetype2
Requires: 
Requires.private: zlib, libpng
Version: 21.0.15
Libs: -L\${libdir} -lfreetype
Cflags: -I\${includedir}/freetype2" > $PREFIX/lib/pkgconfig/freetype2.pc