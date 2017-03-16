@echo off

rem echo building meshtool...
rem g++ -std=c++03 -w -O2 -m32 -o meshtool.exe src.meshtool/main.cpp src.meshtool/mesh.cpp -Lsrc.meshtool/irrlicht -lirrlicht.win32 -lgdi32 -lwinmm -lopengl32 -mwindows

echo building loadmesh dll...
g++ -std=c++03 -w -O2 -m32 -shared -o meshtool.data/loadmesh.dll src_meshtool/loadmesh.cc -Lsrc_meshtool/irrlicht -lirrlicht.win32 -lgdi32 -lwinmm -lopengl32

echo building fonttool...
g++ -std=c++03 -O2 -m32 -o fonttool.exe src.fonttool/stb_image_write.c src.fonttool/stb_truetype.c src.fonttool/main.cpp

echo done.
pause
