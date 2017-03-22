#ifndef MESH_H
#define MESH_H

#include <string>
#include <vector>

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
  float red;
  float green;
  float blue;
  float opacity;
  float shininess;
  int culling;
  int depth_write;
  material_t() {}
  material_t(int blend, const std::string& base_tex, float r, float g, float b, float a, float shininess, int culling, int depth_write)
    : blend(blend), base_tex(base_tex), red(r), green(g), blue(b), opacity(a), shininess(shininess), culling(culling), depth_write(depth_write) {}
  bool operator==(const material_t& other) {
    return  blend == other.blend &&
            base_tex == other.base_tex &&
            red == other.red &&
            green == other.green &&
            blue == other.blue &&
            opacity == other.opacity &&
            shininess == other.shininess &&
            culling == other.culling &&
            depth_write == other.depth_write;
  }
};

struct vertex_t {
  float x, y, z;
  float nx, ny, nz;
  float tx, ty, tz;
  float u0, v0;
  int bones[4];
  float weights[4];
  vertex_t(float x, float y, float z, float nx, float ny, float nz, float u0, float v0)
    : x(x), y(y), z(z), nx(nx), ny(ny), nz(nz), tx(0), ty(0), tz(0), u0(u0), v0(v0) {
      bones[0] = bones[1] = bones[2] = bones[3] = -1;
      weights[0] = weights[1] = weights[2] = weights[3] = 0;
    }
};

struct surface_t {
  material_t                  material;
  std::vector<unsigned short> indices;
  std::vector<vertex_t>       vertices;
};

struct bone_t {
  std::string                           name;
  int                                   parent_index;
  float                                 inv_pose[16];
  std::vector<std::pair<int, vec3_t> >  positions;
  std::vector<std::pair<int, quat_t> >  rotations;
  std::vector<std::pair<int, vec3_t> >  scales;
};

struct mesh_t {
  std::vector<surface_t>  surfaces;
  std::vector<bone_t>     bones;
  int                     num_frames;
};

extern "C" {
  mesh_t* LoadMesh(const char* filename);
  void DeleteMesh(mesh_t* mesh);
}

#endif
