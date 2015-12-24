#!/bin/sh
cd `dirname $0`

echo "building meshtool..."
g++ -std=c++03 -stdlib=libstdc++ -O2 -m32 -o meshtool src.meshtool/main.cpp src.meshtool/mesh.cpp -Lsrc.meshtool/irrlicht -lirrlicht.mac -framework AppKit -framework IOKit -framework OpenGL

echo "building fonttool..."
g++ -std=c++03 -stdlib=libstdc++ -O2 -m32 -o fonttool src.fonttool/stb_image_write.c src.fonttool/stb_truetype.c src.fonttool/main.cpp

echo "done."
