@echo off

echo building meshtool...
g++ -O2 -m32 -std=c++11 -o meshtool.exe meshtool/main.cpp meshtool/mesh.cpp -Lmeshtool/irrlicht -lirrlicht.win32 -lgdi32 -lwinmm -lopengl32 -mwindows

echo building fonttool...
g++ -O2 -m32 -std=c++11 -o fonttool.exe fonttool/stb_image_write.c fonttool/stb_truetype.c fonttool/main.cpp

echo done.
pause
