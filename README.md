# Vortex

Vortex is an open-source, lightweight 3D graphics rendering library which is easy to use and integrate with any application that requires graphics.

It has been released under the terms of the [**Zlib license**](https://en.wikipedia.org/wiki/Zlib_License), which allows its use within both open and closed source software. This license allows to use the library in commercial applications.

Since Vortex uses submodules, to correctly clone the repository, do:

`git clone --recursive https://github.com/JaviCervera/vortex.git`

If you have already cloned the repository without initializing submodules, you can do it afterwards running this on the Vortex repository:

`git submodule update --init`

To pull changes from the repository, including its submodules, do:

`git pull --recurse-submodules`

## Features

* A clean, simple procedural API programmed in C.
* Works on Windows, macOS and Linux (and probably other UNIX variants). Android, iOS and Emscripten support is planned.
* Graphics architecture based on modern OpenGL ES 2.0. It makes use of shaders and vertex buffer objects.
* 2D (primitives, images, text) and 3D rendering.
* Assimp (assbin) and MD2 model formats supported.
* Most common texture formats are support: JPG, PNG, BMP...
* TrueType (ttf) fonts for text rendering.
* Diffuse, emissive, specular and ambient colors supported.
* Diffuse, emissive, specular, ambient, normal and cubemap textures supported.
* Solid, alpha, additive and multiplicative blned modes.
* Dynamic lighting with directional, point and spot lights.
* Realtime shadows from a single directional light and multiple spot lights.
* Vertex based animation.
* Linear fog for ambient effects.

## Building on Windows

You should have **Cmake** installed and added to your `PATH` to build the engine. In order to compile, just double click the `build.bat` file. The library `vortex.dll` will be created on the `_build` folder.

Once built, you can drastically reduce the size of the generated `vortex.dll` executable by running `compress.exe`, which will use the UPX compressor.

## Building on macOS

You should have **Cmake** and **swig3.0** installed to be able to build the engine. You can install them for example with [Brew](https://brew.sh/). After installing Brew on your system, type:

`$brew install cmake`
`$brew install swig3.0`

Then, just double click from Finder on `build.command` and the library `vortex.dylib` will be created on the `_build` folder.

## Building on Linux

You should have **Cmake** and **swig3.0** installed to be able to build the engine. For example, to install them on Ubuntu, type:

`$sudo apt install cmake`

`$sudo apt install swig3.0`

Then, from a Terminal go to the Vortex folder and run the build script:

`$./build.sh`

The library `vortex.so` will be created on the `_build` folder (it is a 64 bit binary).

## Acknowledgments

* The [**Allegro**](https://github.com/liballeg/allegro5) developers.
* **Sean T. Barret** for his wonderful [**stb** libraries](https://github.com/nothings/stb).
* **Zhicheng Wei** for his [Base64 library](https://github.com/zhicheng/base64).
