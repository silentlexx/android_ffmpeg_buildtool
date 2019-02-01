#!/bin/bash

cd opus

make clean
rm Makefile

export LIBS="-lc -lgcc"

./configure --prefix=$PREFIX $HOST  --disable-shared

make -j8
make install

if [ $CPU=="x86" ];
then
   cat ./libopus.la > $PREFIX/lib/libopus.la
   cat ./opus.pc > $PREFIX/lib/pkgconfig/opus.pc
   cat ./.libs/libopus.a >  $PREFIX/lib/libopus.a
   mkdir $PREFIX/include/opus
   cat ./include/opus.h > $PREFIX/include/opus/opus.h
   cat ./include/opus_custom.h > $PREFIX/include/opus/opus_custom.h
   cat ./include/opus_defines.h > $PREFIX/include/opus/opus_defines.h
   cat ./include/opus_multistream.h > $PREFIX/include/opus/opus_multistream.h
   cat ./include/opus_projection.h > $PREFIX/include/opus/opus_projection.h
   cat ./include/opus_types.h > $PREFIX/include/opus/opus_types.h

   echo "manual install done"
fi

         
