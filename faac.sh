#!/bin/bash

cd faac

make clean
rm Makefile

export LIBS="-lc -lgcc"

./configure --prefix=$PREFIX $HOST

make -j8
make install