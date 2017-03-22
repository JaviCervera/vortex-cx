@echo off

echo building meshtool...
g++ -std=c++03 -w -O2 -m32 -o meshtool.data/meshtool.exe src_meshtool/meshtool.cc  src_meshtool/loadmesh.cc src_meshtool/genxml.cc -Lsrc_meshtool/irrlicht -lirrlicht.win32 -lgdi32

rem echo building loadmesh dll...
rem g++ -std=c++03 -w -O2 -m32 -shared -o meshtool.data/loadmesh.dll -DBUILD_SHARED src_meshtool/loadmesh.cc -Lsrc_meshtool/irrlicht -lirrlicht.win32 -lgdi32

echo building fonttool...
g++ -std=c++03 -O2 -m32 -o fonttool.exe src.fonttool/stb_image_write.c src.fonttool/stb_truetype.c src.fonttool/main.cpp

echo done.
pause
