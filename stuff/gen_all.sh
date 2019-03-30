#!/bin/sh
cd `dirname $0`

echo "generating input codes..."
g++ gen_inputcodes.cc
./a.out
g++ gen_inputcodes2.cc
./a.out
rm gen_inputcodes2.cc

echo "generating default font..."
g++ gen_defaultfont.cc ../lib/base64/base64.c
./a.out

echo "done."
rm a.out
