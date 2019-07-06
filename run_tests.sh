#!/bin/sh
cd `dirname $0`

echo "building tests..."
cd tests
gcc test.c -L../_CMAKE -lvortex

echo "running tests..."
echo ""
./a.out

echo "cleaning up..."
rm a.out
cd ..

echo "done."
