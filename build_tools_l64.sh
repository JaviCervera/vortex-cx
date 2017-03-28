#!/bin/sh
#cd `dirname $0`

echo "building meshtool..."
g++ -std=c++03 -O2 -m64 -o meshtool.data/meshtool.bin src_meshtool/meshtool.cc src_meshtool/loadmesh.cc src_meshtool/genxml.cc -Lsrc_meshtool/irrlicht -lIrrlicht.l64
#-lGL -lX11 -lXxf86vm

echo "building fltk file requester..."
g++ -std=c++03 -O2 -m64 -o meshtool.data/fltkrequestfile.bin -Isrc_meshtool/fltk src_meshtool/fltkrequestfile.cc -Lsrc_meshtool/fltk -lfltk.l64 -lXext -lXrender -lXfixes -lX11 -ldl -lXinerama

echo "building fltk color requester..."
g++ -std=c++03 -O2 -m64 -o meshtool.data/fltkrequestcolor.bin -Isrc_meshtool/fltk src_meshtool/fltkrequestcolor.cc -Lsrc_meshtool/fltk -lfltk.l64 -lXext -lXrender -lXfixes -lX11 -ldl -lXinerama

#echo "building fonttool..."
#g++ -std=c++03 -O2 -m64 -o fonttool src.fonttool/stb_image_write.c src.fonttool/stb_truetype.c src.fonttool/main.cpp

echo "done."
