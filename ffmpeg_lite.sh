#!/bin/bash

if [ $LLVM == "true" ];
then
    cd ffmpeg-clang
fi

if [ $LLVM == "false" ];
then
    cd ffmpeg
fi


rm ffmpeg
make clean
rm config.h

VER="4.1"

if [ $CPU == "arm" ];
then
  export $CPU="arm"
  FIXES="--enable-asm --enable-neon"
fi

if [ $CPU == "x86" ];
then
  FIXES="--enable-asm"
fi

if [ $CPU == "arm64" ];
then
  FIXES="--enable-asm --enable-neon "
fi

if [ $CPU == "x86_64" ];
then
  FIXES="--enable-asm"
fi

export EXPEREMETAL="--disable-runtime-cpudetect --enable-small --enable-version3"
export FLAGS="--enable-gpl --enable-nonfree --disable-indev=v4l2 --disable-protocol=udp,udplite
--enable-libmp3lame --enable-libopenh264 --enable-pthreads --enable-filters --enable-libvo-amrwbenc --disable-network"


./configure $FLAGS \
    --prefix=$PREFIX \
    --sysroot=$SYSROOT \
    --arch=$CPU \
    --disable-shared \
    --enable-static \
    --enable-pic \
    --enable-ffmpeg --disable-ffplay --disable-ffprobe --disable-ffnvcodec  \
    --disable-avdevice --disable-debug \
    --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages \
    --disable-symver \
    --cross-prefix=$target_host- \
    --target-os=android \
    --enable-cross-compile --pkg-config-flags="--static" \
    --extra-libs="-lgnustl_static -lm -lpng -l:libz.so -lpthread" \
     $FIXES $EXPEREMETAL || exit 1
    
echo "Press enter to start building ffmpeg"
read

make $J || exit 1
make install 

cat ffmpeg > "../build/ffmpeg_lite_${CPU}"
cat ffmpeg > "../../app/src/main/libs/$SO_ARCH/libffmpeglite.so"


readelf --program-headers ffmpeg




