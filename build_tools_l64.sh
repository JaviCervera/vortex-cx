#!/bin/sh
#cd `dirname $0`

echo "building meshtool..."
g++ -std=c++03 -O2 -m64 -o meshtool.data/meshtool.bin src_tools/meshtool.cc src_tools/loadmesh.cc src_tools/savemesh.cc -Lsrc_tools/irrlicht -lIrrlicht.l64
#-lGL -lX11 -lXxf86vm

echo "building fonttool..."
g++ -std=c++03 -O2 -m64 -o fonttool.data/fonttool.bin src_tools/fonttool.cc

echo "done."
