#!/bin/sh
cd `dirname $0`

echo "building examples..."
cd examples
gcc -o primitives primitives.c -L../_CMAKE -lvortex
gcc -o image image.c -L../_CMAKE -lvortex

echo "running examples..."
echo ""
./primitives
./image

echo "cleaning up..."
rm primitives
rm image
cd ..

echo "done."
