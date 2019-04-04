#!/bin/sh
cd `dirname $0`

echo "generating allegro project for gcc..."
mkdir lib/allegro/_CMAKE
cd lib/allegro/_CMAKE
cmake -G "Unix Makefiles" -DCMAKE_C_FLAGS=-fPIC -DCMAKE_BUILD_TYPE=MinSizeRel -DSHARED=OFF -DWANT_COLOR=OFF -DWANT_D3D=OFF -DWANT_DEMO=OFF -DWANT_DOCS=OFF -DWANT_EXAMPLES=OFF -DWANT_FLAC=OFF -DWANT_FONT=OFF -DWANT_IMAGE=OFF -DWANT_MEMFILE=OFF -DWANT_MODAUDIO=OFF -DWANT_MONOLITH=ON -DWANT_OPENAL=OFF -DWANT_OPENSL=OFF -DWANT_OPUS=OFF -DWANT_OSS=OFF -DWANT_PHYSFS=OFF -DWANT_PRIMITIVES=OFF -DWANT_RELEASE_LOGGING=OFF -DWANT_STATIC_RUNTIME=ON -DWANT_TESTS=OFF -DWANT_TTF=OFF -DWANT_VIDEO=OFF -DWANT_VORBIS=OFF ..

echo "building allegro..."
make
cd ../../..

echo "generating vortex project for gcc..."
mkdir _CMAKE
cd _CMAKE
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=MinSizeRel ..

echo "building vortex..."
make
cd ..

echo "copying vortex to _build dir..."
mkdir _build
cp _CMAKE/libvortex.so _build/libvortex.so

echo "done."
