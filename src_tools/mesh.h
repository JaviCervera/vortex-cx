#ifndef MESH_H
#define MESH_H

// Export mode and call convention
#if defined(_WIN32) && defined(BUILD_SHARED)
#define EXPORT __declspec(dllexport)
#define CALL __stdcall
#else
#define EXPORT
#define CALL
#endif

#include <string>
#include <vector>

#define DEFAULT_SPECULARPOWER  64.0f

struct vec3_t {
  float x;
  float y;
  float z;
  vec3_t(float x, float y, float z) : x(x), y(y), z(z) {}
};

struct quat_t {
  float w;
  float x;
  float y;
  float z;
  quat_t(float w, float x, float y, float z) : w(w), x(x), y(y), z(z) {}
};

struct material_t {
  int blend;
  std::string base_tex;
  std::string lightmap;
  unsigned char red;
  unsigned char green;
  unsigned char blue;
  unsigned char opacity;
  float shininess;
  float specular_power;
  int culling;
  int depth_write;
  material_t() : blend(0), red(255), green(255), blue(255), opacity(255), shininess(0.0f), culling(1), depth_write(1) {}
  material_t(int blend, const std::string& base_tex, const std::string& lightmap, unsigned char r, unsigned char g, unsigned char b, unsigned char a, float shininess, float specular_power, int culling, int depth_write)
    : blend(blend), base_tex(base_tex), lightmap(lightmap), red(r), green(g), blue(b), opacity(a), shininess(shininess), specular_power(specular_power), culling(culling), depth_write(depth_write) {}
  bool operator==(const material_t& other) {
    return  blend == other.blend &&
            base_tex == other.base_tex &&
            lightmap == other.lightmap &&
            red == other.red &&
            green == other.green &&
            blue == other.blue &&
            opacity == other.opacity &&
            shininess == other.shininess &&
            specular_power == other.specular_power &&
            culling == other.culling &&
            depth_write == other.depth_write;
  }
};

struct vertex_t {
  float x, y, z;
  float nx, ny, nz;
  float tx, ty, tz;
  float u0, v0;
  float u1, v1;
  int bones[4];
  float weights[4];
  vertex_t(float x, float y, float z, float nx, float ny, float nz, float u0, float v0, float u1, float v1)
    : x(x), y(y), z(z), nx(nx), ny(ny), nz(nz), tx(0), ty(0), tz(0), u0(u0), v0(v0), u1(u1), v1(v1) {
      bones[0] = bones[1] = bones[2] = bones[3] = -1;
      weights[0] = weights[1] = weights[2] = weights[3] = 0;
    }
};

struct vertexframe_t {
  int                 frame;
  std::vector<vec3_t> positions;
  std::vector<vec3_t> normals;
};

struct surface_t {
  material_t                  material;
  std::vector<unsigned short> indices;
  std::vector<vertex_t>       vertices;
  std::vector<vertexframe_t>  vertex_frames;
};

struct bone_t {
  std::string                           name;
  int                                   parent_index;
  float                                 transform[16];
  float                                 inv_pose[16];
  std::vector<std::pair<int, vec3_t> >  positions;
  std::vector<std::pair<int, quat_t> >  rotations;
  std::vector<std::pair<int, vec3_t> >  scales;
  std::vector<int>                      surfaces;
};

struct mesh_t {
  std::vector<surface_t>  surfaces;
  std::vector<bone_t>     bones;
  int                     num_frames;
  float                   anim_speed;
};

extern "C" {
  EXPORT mesh_t* CALL LoadMesh(const char* filename);
  EXPORT void CALL DeleteMesh(mesh_t* mesh);
}

#endif
