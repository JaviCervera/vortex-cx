@echo off

echo generating allegro project for mingw...
cd lib/allegro
mkdir _CMAKE
cd _CMAKE
cmake -G "MinGW Makefiles" -DCMAKE_C_FLAGS=-m32 -DCMAKE_BUILD_TYPE=MinSizeRel -DSHARED=OFF -DWANT_COLOR=OFF -DWANT_D3D=OFF -DWANT_DEMO=OFF -DWANT_DOCS=OFF -DWANT_EXAMPLES=OFF -DWANT_FLAC=OFF -DWANT_FONT=OFF -DWANT_IMAGE=OFF -DWANT_MEMFILE=OFF -DWANT_MODAUDIO=OFF -DWANT_MONOLITH=ON -DWANT_OPENAL=OFF -DWANT_OPENSL=OFF -DWANT_OPUS=OFF -DWANT_OSS=OFF -DWANT_PHYSFS=OFF -DWANT_PRIMITIVES=OFF -DWANT_RELEASE_LOGGING=OFF -DWANT_STATIC_RUNTIME=ON -DWANT_TESTS=OFF -DWANT_TTF=OFF -DWANT_VIDEO=OFF -DWANT_VORBIS=OFF ..

echo building allegro...
mingw32-make
cd ../../..

echo generating vortex project for mingw...
mkdir _CMAKE
cd _CMAKE
cmake -G "MinGW Makefiles" -DCMAKE_C_FLAGS=-m32 -DCMAKE_BUILD_TYPE=MinSizeRel ..

echo building vortex...
mingw32-make
cd ..

echo moving vortex to _build dir...
mkdir _build
move "_CMAKE\libvortex.dll" "_build\vortex.dll"

pause
