#!/bin/bash

cd dav1d

#make clean

export LIBS="-lc"

rm -r ./build
mkdir ./build

if [ $CPU == "arm" ];
then
  CFG="-Denable_asm=false"
fi

if [ $CPU == "x86" ];
then
  CFG="-Denable_asm=false"
fi

if [ $CPU == "arm64" ];
then
  CFG="-Denable_asm=false"
fi

if [ $CPU == "x86_64" ];
then
  CFG="-Denable_avx512=false"
fi


meson ./build --buildtype release --default-library static --prefix $PREFIX --cross-file meson.$CPU.cross $CFG

read

cd ./build

meson configure

ninja

meson test -v

ninja install

