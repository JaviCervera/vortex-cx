# ![Vortex](./logo.png) Vortex

Vortex is an open-source, lightweight 3D graphics rendering library which is easy to use and easy to integrate with any application that requires graphics. It can also be used as the base for a higher level graphics or game engine.

It has been released under the terms of the [**MIT license**](https://en.wikipedia.org/wiki/MIT_License), which allows its use within both open and closed source software. This license allows to use the library in commercial applications.

## Features
* A clean, simple object oriented API programmed in the [**Cerberus-X**](http://www.cerberus-x.com) language.
* Works on all Cerberus-X targets that support OpenGL ES 2: **Windows**, **macOS**, **Linux**, **Android**, **iOS** and **HTML5**.
* Graphics architecture based on modern **OpenGL ES 2.0**. It makes use of shaders and vertex buffer objects.
* Supports 2D (primitives, images, text) and 3D rendering.
* Loads textures in the most common formats: JPG, PNG, BMP...
* Includes tool to convert **TrueType** (ttf) fonts into bitmap based fonts.
* Meshes can be created in code or loaded from a custom format (includes tool which uses the [**Irrlicht**](http://irrlicht.sourceforge.net) engine to import meshes, with support for several popular formats).
* **Materials** support diffuse color, diffuse texture, lightmap, normal map, cube map, opacity, specular reflections and shadows. They also support different blending modes: solid, alpha, additive, multiplicative.
* **Dynamic lighting** with directional and point lights (configurable number of lights).
* **Realtime shadows** from a single directional light source.
* **Vertex based animation** for meshes (vertex animations are automatically generated from skeletal animations).
* **Linear fog** for ambient effects.
* **Collision detection** with cubes and spheres, triangle collision detection with raycasting.
* **Camera picking** of entities.

## Installation
You should clone the repository onto **<*CerberusFolder*>/modules_ext/vortex**, or download as a zip file and put the vortex folder on that same **<*CerberusFolder*>/modules_ext** location. You should select **Help -> Rebuild Help** on the Cerberus-X IDE (Ted) afterwards, and the documentation will be available in your modules help.

## Acknowledgments
* The **Irrlicht team** for the engine used on the mesh tool (Irrlicht is licensed under the Zlib license).
* **Sean T. Barret** for his **stb_image_write** and **stb_truetype** libraries, used on the tools (these libraries are public domain).

![meshtool](./stuff/meshtool.jpg)

## TODO v2.0
- [x] Use CamelCase in constants
- [x] Vertex color importing in meshtool
- [x] Add Material.Fog and export flag to mesh file
- [x] Add Entity.LookAt
- [x] Fix render to texture on HTML5
- [x] Add box collision with static boxes
- [x] Add Texture.SetPixels method
- [ ] Add Building section to README.md
- [ ] Clean comments
- [ ] Document tools
- [ ] Make sure that every class & method is documented
