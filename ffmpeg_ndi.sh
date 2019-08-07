#!/bin/bash

cd ffmpeg-ndi

rm ffmpeg
make clean
rm config.h


export CPPFLAGS="$CPPFLAGS -I../ndi/include"
export LIBSFLAGS="$LIBSFLAGS -L../ndi/lib/$SO_ARCH -l:libndi.so"

VER="4.1"

if [ $CPU == "arm" ];
then
  export $CPU="arm"
  FIXES="--enable-asm --enable-neon"
fi

if [ $CPU == "x86" ];
then
  FIXES="--enable-asm --enable-libxavs"
fi

if [ $CPU == "arm64" ];
then
  FIXES="--enable-asm --enable-neon --enable-libxavs2 --enable-libaom"
fi

if [ $CPU == "x86_64" ];
then
  FIXES="--enable-asm --enable-libxavs2 --enable-libxavs  --enable-libaom"
fi

export EXPEREMETAL="--disable-runtime-cpudetect --enable-small"
export FLAGS="--enable-version3 --enable-gpl --enable-nonfree --enable-libndi_newtek --enable-libmp3lame --enable-libx264  --enable-libx265 --enable-libvpx --enable-libvorbis --enable-libtheora --enable-libopus --enable-libfdk-aac --enable-libfreetype --enable-libass --enable-libfribidi --enable-fontconfig --enable-pthreads --enable-libxvid --enable-filters --enable-openssl --enable-librtmp --disable-protocol=udp,udplite --enable-libopencore-amrwb --enable-libopencore-amrnb --enable-libvo-amrwbenc --enable-libspeex --enable-libsoxr --enable-libwavpack --enable-libwebp --enable-libxml2 --enable-libopenh264 --enable-mediacodec --enable-jni "


./configure $FLAGS \
    --prefix=$PREFIX \
    --sysroot=$SYSROOT \
    --arch=$CPU \
    --disable-shared \
    --enable-static \
    --enable-pic \
    --enable-ffmpeg --disable-ffplay --disable-ffprobe --disable-ffnvcodec  \
    --disable-debug \
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

cat ffmpeg > "../build/ffmpeg-ndi_${CPU}"
#cat ffmpeg > "../../app/src/main/libs/$SO_ARCH/libffmpeg.so"


readelf --program-headers ffmpeg




