# Vortex

## Introduction
Vortex is an open-source, lightweight 3D graphics rendering library which is easy to use and integrate with any application that requires graphics.

It has been released under the terms of the [**Zlib license**](https://en.wikipedia.org/wiki/Zlib_License), which allows its use within both open and closed source software. This license allows to use the library in commercial applications.

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

## Installation
You should clone the repository onto **<*CerberusFolder*>/modules_ext/vortex**, or download as a zip file and put the vortex folder on that same **<*CerberusFolder*>/modules_ext** location. You should select **Help -> Rebuild Help** on the Cerberus-X IDE (Ted) afterwards, and the documentation will be available in your modules help.

## Acknowledgments
* **Sean T. Barret** for his **stb_image_write** and **stb_truetype** libraries, used on the tools (these libraries are public domain).
