![Vortex](./stuff/vortex_med.png)

## Introduction
Vortex is an open-source, lightweight 3D graphics rendering library which is easy to use and easy to integrate with any application that requires graphics. It can also be used as the base for a higher level graphics or game engine.

It has been released under the terms of the [**zlib license**](https://en.wikipedia.org/wiki/Zlib_License), which allows its use within both open source and closed source software. This license allows to use the library in commercial applications.

##Features
* A clean, simple API programmed in the **Monkey-X** language.
* Works on all Monkey targets that support OpenGL ES 2: **Windows**, **OS X**, **Linux**, **Android**, **iOS** and **HTML5**.
* Graphics architecture based on modern **OpenGL ES 2.0**. It makes use of shaders and vertex buffer objects.
* Supports 2D (primitives, images, text) and 3D rendering.
* Loads textures in the most common formats: JPG, PNG, BMP...
* Includes tool to convert **TrueType** (ttf) fonts into bitmap based fonts.
* Meshes can be created procedurally or loaded from a custom JSON based format (includes converter which uses the [**Assimp**](http://assimp.sourceforge.net) library).
* **Materials** (brushes) support base color, base texture, opacity, and specular reflections. They also support different blending modes: alpha, additive, multiplicative.
* **Dynamic lighting** with directional and point lights (maximum of 8 light sources).
* Simple **hierarchical animations**, with support for different sequences per mesh.
