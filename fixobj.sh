#!/bin/bash

PLATFORM=${1}
PDIR=${2}

rm $PDIR/crtbegin_dynamic.o 
ln -s $PLATFORM/usr/lib/crtbegin_dynamic.o $PDIR/crtbegin_dynamic.o 

rm $PDIR/crtend_android.o 
ln -s $PLATFORM/usr/lib/crtend_android.o $PDIR/crtend_android.o 