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
  export $CPU="cortex-a8"
fi


if [ $CPU == "x86" ];
then
  FIXES="--disable-asm"
fi

export EXPEREMETAL="--enable-runtime-cpudetect --enable-hardcoded-tables --enable-small --enable-version3"

export FLAGS="--enable-gpl --enable-version3 --enable-nonfree --disable-demuxer=rtp,rtsp --disable-muxer=rtp,rtsp,rtp_mpegts --disable-indev=v4l2 --enable-libmp3lame --enable-libx264  --enable-libx265 --enable-libvpx --enable-libvorbis --enable-libtheora --enable-libopus --enable-libfdk-aac --enable-libfreetype --enable-libass --enable-libfribidi --enable-fontconfig --enable-pthreads --enable-libxvid --enable-filters"


./configure $FLAGS \
    --prefix=$PREFIX \
    --sysroot=$SYSROOT \
    --arch=$CPU \
    --disable-shared \
    --enable-static \
    --enable-pic \
    --enable-ffmpeg --disable-ffplay --disable-ffprobe --disable-ffnvcodec  \
    --disable-network \
    --disable-avdevice  --enable-small --disable-debug \
    --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages \
    --disable-symver \
    --cross-prefix=$target_host- \
    --target-os=android \
    --enable-cross-compile --pkg-config-flags="--static" \
    --extra-libs="-lgnustl_static -lm"\
     $FIXES $EXPEREMETAL
    
echo "Press enter"
read


make -j8 || exit 1
make install 

cat ffmpeg > "../../app/src/main/assets/ffmpeg-${VER}_${CPU}"

readelf --program-headers ffmpeg




