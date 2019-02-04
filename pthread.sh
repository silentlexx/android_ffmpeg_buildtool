#!/bin/bash

mkdir -p $PREFIX/include
mkdir -p $PREFIX/lib
mkdir -p $PREFIX/lib/pkgconfig
$AR -rc $PREFIX/lib/libpthread.a
$AR -rc $PREFIX/lib/librt.a