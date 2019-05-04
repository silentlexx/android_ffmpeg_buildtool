#!/bin/bash

# https://github.com/JudgeZarbi/RTMPDump-OpenSSL-1.1

cd librtmp

rm -r obj

$NDK/ndk-build SSL=$PREFIX APP_ABI=$SO_ARCH

cat ./obj/local/$SO_ARCH/librtmp.a > $PREFIX/lib/librtmp.a
mkdir $PREFIX/include/librtmp
cat ./librtmp/rtmp.h > $PREFIX/include/librtmp/rtmp.h
cat ./librtmp/log.h > $PREFIX/include/librtmp/log.h
cat ./librtmp/amf.h > $PREFIX/include/amf.h

echo \
"prefix=$PREFIX
exec_prefix=$PREFIX
libdir=$PREFIX/lib
includedir=$PREFIX/include

Name: librtmp
Description: librtmp
Requires: 
Requires.private: openssl
Version: 1.0
Libs: -L\${libdir} -lrtmp -lz -lssl
Cflags: -I\${includedir} -I\${includedir}/librtmp" > $PREFIX/lib/pkgconfig/librtmp.pc