#!/bin/sh
cd `dirname $0`

echo "generating allegro project for gcc..."
mkdir lib/allegro/_CMAKE
cd lib/allegro/_CMAKE
cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 -DCMAKE_BUILD_TYPE=MinSizeRel -DSHARED=OFF -DWANT_COLOR=OFF -DWANT_D3D=OFF -DWANT_DEMO=OFF -DWANT_DOCS=OFF -DWANT_EXAMPLES=OFF -DWANT_FLAC=OFF -DWANT_FONT=OFF -DWANT_IMAGE=OFF -DWANT_MEMFILE=OFF -DWANT_MODAUDIO=OFF -DWANT_MONOLITH=ON -DWANT_OPENAL=OFF -DWANT_OPENSL=OFF -DWANT_OPUS=OFF -DWANT_OSS=OFF -DWANT_PHYSFS=OFF -DWANT_PRIMITIVES=OFF -DWANT_RELEASE_LOGGING=OFF -DWANT_STATIC_RUNTIME=ON -DWANT_TESTS=OFF -DWANT_TTF=OFF -DWANT_VIDEO=OFF -DWANT_VORBIS=OFF ..

echo "building allegro..."
make
cd ../../..

echo "generating glfw project for gcc..."
mkdir lib/glfw/_CMAKE
cd lib/glfw/_CMAKE
cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DGLFW_BUILD_DOCS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_INSTALL=OFF ..

echo "building glfw..."
make
cd ../../..

echo "generating sdl2 project for mingw..."
mkdir lib/sdl2/_CMAKE
cd lib/sdl2/_CMAKE
cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 -DCMAKE_BUILD_TYPE=MinSizeRel -DSDL_SHARED=OFF ..

echo "building sdl2..."
make
cd ../../..

echo "generating vortex project for gcc..."
mkdir _CMAKE
cd _CMAKE
cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 -DCMAKE_BUILD_TYPE=MinSizeRel ..

echo "building vortex..."
make
cd ..

echo "copying vortex to _build dir..."
mkdir _build
cp _CMAKE/libvortex.dylib _build/libvortex.dylib

echo "done."
