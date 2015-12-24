#!/bin/sh
#cd `dirname $0`

echo "building meshtool..."
g++ -std=c++03 -O2 -m64 -o meshtool src.meshtool/main.cpp src.meshtool/mesh.cpp -Lsrc.meshtool/irrlicht -lIrrlicht.l64 -lGL -lX11 -lXxf86vm

echo "building fonttool..."
g++ -std=c++03 -O2 -m64 -o fonttool src.fonttool/stb_image_write.c src.fonttool/stb_truetype.c src.fonttool/main.cpp

echo "done."
