#!/bin/bash

#https://github.com/alvisisme/android-zlib.git

cd zlib

ZLIB_VERSION=1.2.11

CWD=$PWD
mkdir -p $CWD/build

cd $CWD/build
if [ ! -f zlib.tar.gz ];then
wget https://github.com/madler/zlib/archive/v$ZLIB_VERSION.tar.gz -O zlib.tar.gz
fi
if [ -d zlib ];then
rm -rf zlib
fi

tar xf zlib.tar.gz
mv zlib-$ZLIB_VERSION zlib
cd zlib

sed -i '199d' CMakeLists.txt
sed -i '189d' CMakeLists.txt
rm -r build
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_SYSROOT=$SYSROOT -DCMAKE_TOOLCHAIN_FILE=$CCM -DCMAKE_C_FLAGS="$CFLAGS" \
  -DCMAKE_SYSTEM_NAME=Android \
  -DCMAKE_SYSTEM_VERSION=$API \
  -DCMAKE_ANDROID_ABI=$SO_ARCH \
  -DCMAKE_ANDROID_NDK=$NDK \
  -DCMAKE_C_LINK_EXECUTABLE=$LD \
  -DCMAKE_FIND_ROOT_PATH=$PLATFORM \
  -DCMAKE_C_LINK_EXECUTABLE=$LD \
 ..
make
make install

cd ..

if [ $CPU=="x86" ];
then
   cat ./build/libz.a > $PREFIX/lib/libz.la
   cat ./build/zlib.pc > $PREFIX/lib/pkgconfig/zlib.pc
   cat ./build/zconf.h > $PREFIX/include/zconf.h
   cat ./zlib.h > $PREFIX/include/zlib.h

   echo "manual install done"
fi

rm $PREFIX/lib/libz.so

cd $CWD


echo "Shared error it's OK!"