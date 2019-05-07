#!/bin/bash



build32(){

# https://github.com/xxDroid/libsoxr-android

cd libsoxr/libsoxr-android/android

rm -r obj

$NDK/ndk-build APP_ABI=$SO_ARCH

cat ./obj/local/$SO_ARCH/libsoxr.a > $PREFIX/lib/libsoxr.a
cat ../libsoxr/src/soxr.h > $PREFIX/include/soxr.h

echo \
"prefix=$PREFIX
exec_prefix=$PREFIX
libdir=$PREFIX/lib
includedir=$PREFIX/include

Name: soxr
Description: soxr
Version: 0.1.3
Libs: -L\${libdir} -lsoxr
Cflags: -I\${includedir} " > $PREFIX/lib/pkgconfig/soxr.pc
}

build64(){

cd libsoxr/soxr

rm -r build
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX  -DCMAKE_SYSROOT=$SYSROOT -DCMAKE_C_FLAGS="$CFLAGS $LIBS" \
  -DCMAKE_SYSTEM_NAME=Android \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_CPU \
  -DCMAKE_SYSTEM_VERSION=$API \
  -DCMAKE_ANDROID_ABI=$ABI \
  -DCMAKE_ANDROID_NDK=$NDK \
  -DBUILD_SHARED_LIBS=OFF \
  -DWITH_OPENMP=OFF \
  -DBUILD_TESTS=OFF \
  -DWITH_LSR_BINDINGS=OFF \
  ..

make $J
make install

}

if [ $CPU == "arm" ];
then
    build32
fi

if [ $CPU == "x86" ];
then
    build32
fi

if [ $CPU == "arm64" ];
then
    build64
fi

if [ $CPU == "x86_64" ];
then
    build64
fi






