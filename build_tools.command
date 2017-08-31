#!/bin/sh
cd `dirname $0`

echo "building meshtool..."
g++ -std=c++03 -stdlib=libstdc++ -arch i386 -arch x86_64 -O2 -o meshtool.data/meshtool.bin src_tools/meshtool.cc src_tools/loadmesh.cc src_tools/genxml.cc -Lsrc_tools/irrlicht -lIrrlicht.mac -framework AppKit -framework IOKit -framework OpenGL

echo "building fonttool..."
g++ -std=c++03 -stdlib=libstdc++ -arch i386 -arch x86_64 -O2 -o fonttool.data/fonttool.bin src_tools/fonttool.cc

echo "done."
