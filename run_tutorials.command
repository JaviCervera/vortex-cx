#!/bin/sh
cd `dirname $0`

echo "building tutorials..."
cd tutorial
gcc -o primitives primitives.c -L../_CMAKE -lvortex
gcc -o image image.c -L../_CMAKE -lvortex

echo "running tutorials..."
echo ""
./primitives
./image

echo "cleaning up..."
rm primitives
rm image
cd ..

echo "done."
