#include "mesh.h"
#include "stringutils.h"
#include <fstream>

static int rgb(float r, float g, float b, float a) {
  unsigned char br = static_cast<unsigned char>(r * 255.0f);
  unsigned char bg = static_cast<unsigned char>(g * 255.0f);
  unsigned char bb = static_cast<unsigned char>(b * 255.0f);
  unsigned char ba = static_cast<unsigned char>(a * 255.0f);
  return (ba << 24) | (br << 16) | (bg << 8) | bb;
}

void SaveMSH(const mesh_t* mesh, const std::string& filename) {
  // create file
  std::ofstream f(filename.c_str(), std::ios::binary | std::ios::trunc);
  if ( !f.is_open() ) return;

  // id & version
  std::string id = "ME01";
  f.write(id.c_str(), id.size());

  // number of surfaces
  unsigned short numSurfaces = static_cast<unsigned short>(mesh->surfaces.size());
  f.write(reinterpret_cast<const char*>(&numSurfaces), sizeof(numSurfaces));

  // surfaces
  for ( size_t s = 0; s < mesh->surfaces.size(); ++s ) {
    const surface_t& surf = mesh->surfaces[s];

    // write material
    int color     = rgb(surf.material.red, surf.material.green, surf.material.blue, surf.material.opacity);
    int specular  = 0xffffffff;
    int emissive  = 0x00000000;
    int ambient   = 0xffffffff;
    unsigned char blend = static_cast<unsigned char>(surf.material.blend);
    unsigned char flags = 0;
    float cubeOpacity = 0.5f;
    float refrCoef = -1;
    unsigned char usedTexs = 0;
    if ( surf.material.culling ) flags |= 1;
    if ( surf.material.depth_write ) flags |= 2;
    if ( surf.material.base_tex != "" ) usedTexs |= 1;
    if ( surf.material.lightmap != "" ) usedTexs |= 64;
    f.write(reinterpret_cast<const char*>(&color), sizeof(color));
    f.write(reinterpret_cast<const char*>(&specular), sizeof(specular));
    f.write(reinterpret_cast<const char*>(&emissive), sizeof(emissive));
    f.write(reinterpret_cast<const char*>(&ambient), sizeof(ambient));
    f.write(reinterpret_cast<const char*>(&blend), sizeof(blend));
    f.write(reinterpret_cast<const char*>(&flags), sizeof(flags));
    f.write(reinterpret_cast<const char*>(&surf.material.shininess), sizeof(surf.material.shininess));
    f.write(reinterpret_cast<const char*>(&cubeOpacity), sizeof(cubeOpacity));
    f.write(reinterpret_cast<const char*>(&refrCoef), sizeof(refrCoef));
    f.write(reinterpret_cast<const char*>(&usedTexs), sizeof(usedTexs));
    if ( surf.material.base_tex != "" ) {
      std::string str = StripPath(surf.material.base_tex);
      int size = static_cast<int>(str.size());
      f.write(reinterpret_cast<const char*>(&size), sizeof(size));
      f.write(str.c_str(), size);
    }
    if ( surf.material.lightmap != "" ) {
      std::string str = StripPath(surf.material.lightmap);
      int size = static_cast<int>(str.size());
      f.write(reinterpret_cast<const char*>(&size), sizeof(size));
      f.write(str.c_str(), size);
    }

    // write surface
    int numIndices = static_cast<int>(surf.indices.size());
    unsigned short numVertices = static_cast<unsigned short>(surf.vertices.size());
    unsigned char vertexFlags = 1 | 2 | 8 | 16 | 32;
    f.write(reinterpret_cast<const char*>(&numIndices), sizeof(numIndices));
    f.write(reinterpret_cast<const char*>(&numVertices), sizeof(numVertices));
    f.write(reinterpret_cast<const char*>(&vertexFlags), sizeof(vertexFlags));
    f.write(reinterpret_cast<const char*>(&surf.indices[0]), numIndices * sizeof(surf.indices[0]));
    for ( int v = 0; v < numVertices; ++v ) {
      unsigned short b0 = static_cast<unsigned short>(surf.vertices[v].bones[0]);
      unsigned short b1 = static_cast<unsigned short>(surf.vertices[v].bones[1]);
      unsigned short b2 = static_cast<unsigned short>(surf.vertices[v].bones[2]);
      unsigned short b3 = static_cast<unsigned short>(surf.vertices[v].bones[3]);
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].x), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].y), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].z), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].nx), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].ny), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].nz), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].tx), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].ty), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].tz), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].u0), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].v0), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].u1), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].v1), sizeof(float));
      f.write(reinterpret_cast<const char*>(&b0), sizeof(b0));
      f.write(reinterpret_cast<const char*>(&b1), sizeof(b1));
      f.write(reinterpret_cast<const char*>(&b2), sizeof(b2));
      f.write(reinterpret_cast<const char*>(&b3), sizeof(b3));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].weights[0]), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].weights[1]), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].weights[2]), sizeof(float));
      f.write(reinterpret_cast<const char*>(&surf.vertices[v].weights[3]), sizeof(float));
    }
  }

  f.close();
}

void SaveSKL(const mesh_t* mesh, const std::string& filename) {
  // create file
  std::ofstream f(filename.c_str(), std::ios::binary | std::ios::trunc);
  if ( !f.is_open() ) return;

  // id & version
  std::string id = "SK01";
  f.write(id.c_str(), id.size());

  // number of bones
  unsigned short numBones = static_cast<unsigned short>(mesh->bones.size());
  f.write(reinterpret_cast<const char*>(&numBones), sizeof(numBones));

  // bones
  for ( size_t b = 0; b < numBones; ++b ) {
    const bone_t& bone = mesh->bones[b];

    // name
    int len = bone.name.size();
    f.write(reinterpret_cast<const char*>(&len), sizeof(len));
    f.write(bone.name.c_str(), len);

    // parent index
    f.write(reinterpret_cast<const char*>(&bone.parent_index), sizeof(bone.parent_index));

    // inv pose matrix
    f.write(reinterpret_cast<const char*>(&bone.inv_pose[0]), sizeof(bone.inv_pose));
  }

  f.close();
}

void SaveANM(const mesh_t* mesh, const std::string& filename) {
  // create file
  std::ofstream f(filename.c_str(), std::ios::binary | std::ios::trunc);
  if ( !f.is_open() ) return;

  // id & version
  std::string id = "AN01";
  f.write(id.c_str(), id.size());

  // number of frames
  unsigned short numFrames = static_cast<unsigned short>(mesh->num_frames);
  f.write(reinterpret_cast<const char*>(&numFrames), sizeof(numFrames));

  // animation speed
  f.write(reinterpret_cast<const char*>(&mesh->anim_speed), sizeof(mesh->anim_speed));

  // number of bones
  unsigned short numBones = static_cast<unsigned short>(mesh->bones.size());
  f.write(reinterpret_cast<const char*>(&numBones), sizeof(numBones));

  // animation data
  for ( size_t b = 0; b < numBones; ++b ) {
    const bone_t& bone = mesh->bones[b];

    // position keys
    unsigned short numKeys = static_cast<unsigned short>(bone.positions.size());
    f.write(reinterpret_cast<const char*>(&numKeys), sizeof(numKeys));
    for ( size_t i = 0; i < numKeys; ++i ) {
      unsigned short frame = static_cast<unsigned short>(bone.positions[i].first);
      f.write(reinterpret_cast<const char*>(&frame), sizeof(frame));
      f.write(reinterpret_cast<const char*>(&bone.positions[i].second), sizeof(bone.positions[i].second));
    }

    // rotation keys
    numKeys = static_cast<unsigned short>(bone.rotations.size());
    f.write(reinterpret_cast<const char*>(&numKeys), sizeof(numKeys));
    for ( size_t i = 0; i < numKeys; ++i ) {
      unsigned short frame = static_cast<unsigned short>(bone.rotations[i].first);
      f.write(reinterpret_cast<const char*>(&frame), sizeof(frame));
      f.write(reinterpret_cast<const char*>(&bone.rotations[i].second), sizeof(bone.rotations[i].second));
    }

    // scale keys
    numKeys = static_cast<unsigned short>(bone.scales.size());
    f.write(reinterpret_cast<const char*>(&numKeys), sizeof(numKeys));
    for ( size_t i = 0; i < numKeys; ++i ) {
      unsigned short frame = static_cast<unsigned short>(bone.scales[i].first);
      f.write(reinterpret_cast<const char*>(&frame), sizeof(frame));
      f.write(reinterpret_cast<const char*>(&bone.scales[i].second), sizeof(bone.scales[i].second));
    }
  }

  f.close();
}