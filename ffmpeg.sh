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
  FIXES="--enable-asm --enable-neon"
fi

if [ $CPU == "x86_64" ];
then
  FIXES="--enable-asm"
fi

export EXPEREMETAL="--enable-runtime-cpudetect --enable-hardcoded-tables --enable-version3"
export FLAGS="--enable-gpl --enable-nonfree --disable-indev=v4l2 
--enable-libmp3lame --enable-libx264  --enable-libx265 --enable-libvpx --enable-libvorbis --enable-libtheora --enable-libopus --enable-libfdk-aac --enable-libfreetype --enable-libass --enable-libfribidi --enable-fontconfig --enable-pthreads --enable-libxvid --enable-filters --enable-openssl --enable-librtmp --disable-protocol=udp,udplite
--enable-libopencore-amrwb --enable-libopencore-amrnb --enable-libvo-amrwbenc"


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
    
echo "Press enter"
read

make $J || exit 1
make install 

cat ffmpeg > "../build/ffmpeg-${VER}_${CPU}"
cat ffmpeg > "../../app/src/main/assets/ffmpeg-${VER}_${CPU}"


readelf --program-headers ffmpeg




