// TODO:
// - Export vertex colors

#define _IRR_STATIC_LIB_
#include "irrlicht/irrlicht.h"
//#include <iostream>
#include <string>
#include <vector>

// Export mode and call convention
#if defined(_WIN32)
#define EXPORT __declspec(dllexport)
#define CALL __stdcall
#else
#define EXPORT
#define CALL
#endif

using namespace irr;

// Forward declaration of functions
scene::ISkinnedMesh::SJoint* FindParent(scene::ISkinnedMesh* mesh, const scene::ISkinnedMesh::SJoint* joint);;
std::vector<int> BoneIndicesForSurface(scene::ISkinnedMesh* mesh, u32 surface);
std::vector<float> BoneWeightsForSurface(scene::ISkinnedMesh* mesh, u32 surface);

struct vec3_t {
  float x;
  float y;
  float z;
  vec3_t() : x(0), y(0), z(0) {}
  vec3_t(float x, float y, float z) : x(x), y(y), z(z) {}
};

struct quat_t {
  float w;
  float x;
  float y;
  float z;
  quat_t() : w(1), x(0), y(0), z(0) {}
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
  std::string             name;
  int                     parent_index;
  float                   inv_pose[16];
  std::pair<int, vec3_t>  positions;
  std::pair<int, quat_t>  rotations;
  std::pair<int, vec3_t>  scales;
};

struct mesh_t {
  std::vector<surface_t> surfaces;
  int num_frames;
};

extern "C" {

EXPORT mesh_t* CALL LoadMesh(const char* filename) {
  mesh_t* mesh = NULL;

  // create irrlicht device
  IrrlichtDevice* device = createDevice(video::EDT_NULL);

  // load mesh
  scene::IAnimatedMesh* anim_mesh = device->getSceneManager()->getMesh(filename);
  if ( anim_mesh ) {
    scene::ISkinnedMesh* skinned_mesh = ( anim_mesh->getMeshType() == scene::EAMT_SKINNED && anim_mesh->getFrameCount() > 1 ) ? static_cast<scene::ISkinnedMesh*>(anim_mesh) : 0;
    scene::IMesh* irr_mesh = anim_mesh->getMesh(0);

    mesh = new mesh_t;

    // surfaces
    for ( size_t i = 0; i < irr_mesh->getMeshBufferCount(); ++i ) {
      scene::IMeshBuffer* mesh_buffer = irr_mesh->getMeshBuffer(i);
      const video::SMaterial& mat = mesh_buffer->getMaterial();

      surface_t surf;

      // material
      std::string base_tex = mat.getTexture(0) ? mat.getTexture(0)->getName().getPath().c_str() : "";
      float r = mat.DiffuseColor.getRed() / 255.0f;
      float g = mat.DiffuseColor.getGreen() / 255.0f;
      float b = mat.DiffuseColor.getBlue() / 255.0f;
      float a = mat.DiffuseColor.getAlpha() / 255.0f;
      float shininess = mat.Shininess;
      int culling = mat.BackfaceCulling;
      int depth_write = mat.ZWriteEnable;
      surf.material = material_t(0, base_tex, r, g, b, a, shininess, culling, depth_write);

      // indices
      for (size_t j = 0; j < mesh_buffer->getIndexCount(); ++j) {
        surf.indices.push_back(mesh_buffer->getIndices()[j]);
      }

      // vertices
      for ( size_t v = 0; v < mesh_buffer->getVertexCount(); ++v ) {
        float x = mesh_buffer->getPosition(v).X;
        float y = mesh_buffer->getPosition(v).Y;
        float z = mesh_buffer->getPosition(v).Z;
        float nx = mesh_buffer->getNormal(v).X;
        float ny = mesh_buffer->getNormal(v).Y;
        float nz = mesh_buffer->getNormal(v).Z;
        float u0 = mesh_buffer->getTCoords(v).X;
        float v0 = mesh_buffer->getTCoords(v).Y;
        surf.vertices.push_back(vertex_t(x, y, z, nx, ny, nz, u0, v0));
      }

      // bone indices and weights
      if ( skinned_mesh ) {
        std::vector<int> indices = BoneIndicesForSurface(skinned_mesh, i);
        std::vector<float> weights = BoneWeightsForSurface(skinned_mesh, i);
        for ( size_t b = 0; b < indices.size(); b += 4 ) {
          surf.vertices.back().bones[0] = indices[b];
          surf.vertices.back().bones[1] = indices[b+1];
          surf.vertices.back().bones[2] = indices[b+2];
          surf.vertices.back().bones[3] = indices[b+3];
          surf.vertices.back().weights[0] = weights[b];
          surf.vertices.back().weights[1] = weights[b+1];
          surf.vertices.back().weights[2] = weights[b+2];
          surf.vertices.back().weights[3] = weights[b+3];
        }
      }

      mesh->surfaces.push_back(surf);
    }

    // bones
    if ( skinned_mesh ) {
      const core::array<scene::ISkinnedMesh::SJoint*>& joints = skinned_mesh->getAllJoints();
      for ( size_t b = 0; b < joints.size(); ++b ) {
        /*
        buffer += std::string("\t\t\t<name>") + joints[i]->Name.c_str() + "</name>\n";

        scene::ISkinnedMesh::SJoint* parent = FindParent(skinnedMesh, joints[i]);
        if (parent) buffer += std::string("\t\t\t<parent>") + parent->Name.c_str() + "</parent>\n";

        irr::core::matrix4 invPose = joints[i]->GlobalInversedMatrix;
        buffer += "\t\t\t<inv_pose>";
        for (u32 m = 0; m < 16; ++m) {
          buffer += StringFromNumber(invPose[m]);
          if ( m < 15 ) buffer + ",";
        }
        buffer += "</inv_pose>\n";
        /*
        core::vector3df irrPosition = joints[i]->LocalMatrix.getTranslation();
        core::vector3df irrRotation = joints[i]->LocalMatrix.getRotationDegrees();
        core::vector3df irrScale = joints[i]->LocalMatrix.getScale();
        glm::quat rotation(glm::radians(glm::vec3(irrRotation.X, irrRotation.Y, irrRotation.Z)));
        if (VORTEX_HANDEDNESS == VORTEX_LH) {
          buffer += "\t\t\t<def_position>" + StringFromNumber(irrPosition.X) + "," + StringFromNumber(irrPosition.Y) + "," + StringFromNumber(irrPosition.Z) + "</def_position>\n";
          buffer += "\t\t\t<def_rotation>" + StringFromNumber(rotation.w) + "," + StringFromNumber(rotation.x) + "," + StringFromNumber(rotation.y) + "," + StringFromNumber(rotation.z) + "</def_rotation>\n";
          buffer += "\t\t\t<def_scale>" + StringFromNumber(irrScale.X) + "," + StringFromNumber(irrScale.Y) + "," + StringFromNumber(irrScale.Z) + "</def_scale>\n";
        } else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
          rotation = glm::quat(glm::radians(glm::vec3(-irrRotation.X, -irrRotation.Y, -irrRotation.Z)));
          buffer += "\t\t\t<def_position>" + StringFromNumber(irrPosition.X) + "," + StringFromNumber(irrPosition.Y) + "," + StringFromNumber(-irrPosition.Z) + "</def_position>\n";
          buffer += "\t\t\t<def_rotation>" + StringFromNumber(rotation.w) + "," + StringFromNumber(rotation.x) + "," + StringFromNumber(rotation.y) + "," + StringFromNumber(rotation.z) + "</def_rotation>\n";
          buffer += "\t\t\t<def_scale>" + StringFromNumber(irrScale.X) + "," + StringFromNumber(irrScale.Y) + "," + StringFromNumber(irrScale.Z) + "</def_scale>\n";
        } else {
          buffer += "\t\t\t<def_position>" + StringFromNumber(irrPosition.X) + "," + StringFromNumber(irrPosition.Z) + "," + StringFromNumber(irrPosition.Y) + "</def_position>\n";
          buffer += "\t\t\t<def_rotation>" + StringFromNumber(-rotation.w) + "," + StringFromNumber(rotation.x) + "," + StringFromNumber(rotation.y) + "," + StringFromNumber(rotation.z) + "</def_rotation>\n";
          buffer += "\t\t\t<def_scale>" + StringFromNumber(irrScale.X) + "," + StringFromNumber(irrScale.Z) + "," + StringFromNumber(irrScale.Y) + "</def_scale>\n";
        }
        * /

        if (joints[i]->AttachedMeshes.size() > 0) {
          buffer += "\t\t\t<surfaces>";
          for (u32 j = 0; j < joints[i]->AttachedMeshes.size(); ++j) {
            buffer += StringFromNumber(joints[i]->AttachedMeshes[j]);
            if (j < joints[i]->AttachedMeshes.size() - 1) buffer + ",";
          }
          buffer += "</surfaces>\n";
        }

        if (joints[i]->PositionKeys.size() > 0) {
          buffer += "\t\t\t<positions>";
          for (u32 j = 0; j < joints[i]->PositionKeys.size(); ++j) {
            if (VORTEX_HANDEDNESS == VORTEX_LH) {
              buffer += StringFromNumber(int(joints[i]->PositionKeys[j].frame)) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.X) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Y) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Z);
            } else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
              buffer += StringFromNumber(int(joints[i]->PositionKeys[j].frame)) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.X) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Y) + "," + StringFromNumber(-joints[i]->PositionKeys[j].position.Z);
            } else {
              buffer += StringFromNumber(int(joints[i]->PositionKeys[j].frame)) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.X) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Z) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Y);
            }
            if (j < joints[i]->PositionKeys.size() - 1) buffer += ",";
          }
          buffer += "</positions>\n";
        }
        else if (joints[i]->RotationKeys.size() > 0 || joints[i]->ScaleKeys.size() > 0) {
          buffer += "\t\t\t<positions>0,0,0,0</positions>\n";
        }

        if (joints[i]->RotationKeys.size() > 0) {
          buffer += "\t\t\t<rotations>";
          for (u32 j = 0; j < joints[i]->RotationKeys.size(); ++j) {
            if (VORTEX_HANDEDNESS == VORTEX_LH) {
              buffer += StringFromNumber(int(joints[i]->RotationKeys[j].frame)) + "," + StringFromNumber(-joints[i]->RotationKeys[j].rotation.W) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.X) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Y) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Z);
            } else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
              buffer += StringFromNumber(int(joints[i]->RotationKeys[j].frame)) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.W) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.X) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Y) + "," + StringFromNumber(-joints[i]->RotationKeys[j].rotation.Z);
            } else {
              buffer += StringFromNumber(int(joints[i]->RotationKeys[j].frame)) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.W) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.X) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Z) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Y);
            }
            if (j < joints[i]->RotationKeys.size() - 1) buffer += ",";
          }
          buffer += "</rotations>\n";
        }
        else if (joints[i]->PositionKeys.size() > 0 || joints[i]->ScaleKeys.size() > 0) {
          buffer += "\t\t\t<rotations>0,1,0,0,0</rotations>\n";
        }

        if (joints[i]->ScaleKeys.size() > 0) {
          buffer += "\t\t\t<scales>";
          for (u32 j = 0; j < joints[i]->ScaleKeys.size(); ++j) {
            if (VORTEX_HANDEDNESS == VORTEX_RH_Z) {
              buffer += StringFromNumber(int(joints[i]->ScaleKeys[j].frame)) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.X) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Z) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Y);
            } else {
              buffer += StringFromNumber(int(joints[i]->ScaleKeys[j].frame)) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.X) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Y) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Z);
            }
            if (j < joints[i]->ScaleKeys.size() - 1) buffer += ",";
          }
          buffer += "</scales>\n";
        }
        else if (joints[i]->PositionKeys.size() > 0 || joints[i]->RotationKeys.size() > 0) {
          buffer += "\t\t\t<scales>0,1,1,1</scales>\n";
        }

        buffer += "\t\t</bone>\n";
        */
      }
    }

    // num frames
    mesh->num_frames = anim_mesh->getFrameCount();
  }

  // drop irrlicht device
  device->drop();

  return mesh;
}

EXPORT void CALL DeleteMesh(mesh_t* mesh) {
  delete mesh;
}

EXPORT int CALL NumSurfaces(const mesh_t* mesh) {
  return static_cast<int>(mesh->surfaces.size());
}

EXPORT int CALL MaterialBlend(const mesh_t* mesh, int surf_index) {
  return mesh->surfaces[surf_index].material.blend;
}

EXPORT const char* CALL MaterialTextureName(const mesh_t* mesh, int surf_index) {
  return mesh->surfaces[surf_index].material.base_tex.c_str();
}

EXPORT float CALL MaterialRed(const mesh_t* mesh, int surf_index) {
  return mesh->surfaces[surf_index].material.red;
}

EXPORT float CALL MaterialGreen(const mesh_t* mesh, int surf_index) {
  return mesh->surfaces[surf_index].material.green;
}

EXPORT float CALL MaterialBlue(const mesh_t* mesh, int surf_index) {
  return mesh->surfaces[surf_index].material.blue;
}

EXPORT float CALL MaterialOpacity(const mesh_t* mesh, int surf_index) {
  return mesh->surfaces[surf_index].material.opacity;
}

EXPORT float CALL MaterialShininess(const mesh_t* mesh, int surf_index) {
  return mesh->surfaces[surf_index].material.shininess;
}

EXPORT int CALL MaterialCulling(const mesh_t* mesh, int surf_index) {
  return mesh->surfaces[surf_index].material.culling;
}

EXPORT int CALL MaterialDepthWrite(const mesh_t* mesh, int surf_index) {
  return mesh->surfaces[surf_index].material.depth_write;
}

EXPORT int CALL NumIndices(const mesh_t* mesh, int surf_index) {
  return static_cast<int>(mesh->surfaces[surf_index].indices.size());
}

EXPORT int CALL GetIndex(const mesh_t* mesh, int surf_index, int index_number) {
  return mesh->surfaces[surf_index].indices[index_number];
}

EXPORT int CALL NumVertices(const mesh_t* mesh, int surf_index) {
  return static_cast<int>(mesh->surfaces[surf_index].vertices.size());
}

EXPORT float CALL VertexX(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].x;
}

EXPORT float CALL VertexY(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].y;
}

EXPORT float CALL VertexZ(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].z;
}

EXPORT float CALL VertexNX(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].nx;
}

EXPORT float CALL VertexNY(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].ny;
}

EXPORT float CALL VertexNZ(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].nz;
}

EXPORT float CALL VertexTX(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].tx;
}

EXPORT float CALL VertexTY(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].ty;
}

EXPORT float CALL VertexTZ(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].tz;
}

EXPORT float CALL VertexU0(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].u0;
}

EXPORT float CALL VertexV0(const mesh_t* mesh, int surf_index, int vertex_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].v0;
}

EXPORT int CALL VertexBone(const mesh_t* mesh, int surf_index, int vertex_index, int bone_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].bones[bone_index];
}

EXPORT float CALL VertexWeight(const mesh_t* mesh, int surf_index, int vertex_index, int weight_index) {
  return mesh->surfaces[surf_index].vertices[vertex_index].weights[weight_index];
}

EXPORT int CALL NumFrames(const mesh_t* mesh) {
  return mesh->num_frames;
}

} // extern "C"

std::vector<int> BoneIndicesForSurface(scene::ISkinnedMesh* mesh, u32 surface) {
  if ( !mesh ) return std::vector<int>();
  bool indicesFound = false;
  std::vector<int> indices(mesh->getMeshBuffer(surface)->getVertexCount() * 4, -1);
  for (u32 i = 0; i < mesh->getJointCount(); ++i) {
    for (u32 j = 0; j < mesh->getAllJoints()[i]->Weights.size(); ++j) {
      if (mesh->getAllJoints()[i]->Weights[j].buffer_id == surface) {
        indicesFound = true;
        u32 vertexId = mesh->getAllJoints()[i]->Weights[j].vertex_id;
        if ( indices[vertexId*4] == -1 ) indices[vertexId*4] = i;
        else if ( indices[vertexId*4 + 1] == -1 ) indices[vertexId*4 + 1] = i;
        else if ( indices[vertexId*4 + 2] == -1 ) indices[vertexId*4 + 2] = i;
        else if ( indices[vertexId*4 + 3] == -1 ) indices[vertexId*4 + 3] = i;
      }
    }
  }
  if ( indicesFound ) return indices;
  else return std::vector<int>();
}

std::vector<float> BoneWeightsForSurface(scene::ISkinnedMesh* mesh, u32 surface) {
  if ( !mesh ) return std::vector<float>();
  bool weightsFound = false;
  std::vector<float> weights(mesh->getMeshBuffer(surface)->getVertexCount() * 4, -1);
  for (u32 i = 0; i < mesh->getJointCount(); ++i) {
    for (u32 j = 0; j < mesh->getAllJoints()[i]->Weights.size(); ++j) {
      if (mesh->getAllJoints()[i]->Weights[j].buffer_id == surface) {
        weightsFound = true;
        u32 vertexId = mesh->getAllJoints()[i]->Weights[j].vertex_id;
        if ( weights[vertexId*4] == -1 ) weights[vertexId*4] = mesh->getAllJoints()[i]->Weights[j].strength;
        else if ( weights[vertexId*4 + 1] == -1 ) weights[vertexId*4 + 1] = mesh->getAllJoints()[i]->Weights[j].strength;
        else if ( weights[vertexId*4 + 2] == -1 ) weights[vertexId*4 + 2] = mesh->getAllJoints()[i]->Weights[j].strength;
        else if ( weights[vertexId*4 + 3] == -1 ) weights[vertexId*4 + 3] = mesh->getAllJoints()[i]->Weights[j].strength;
      }
    }
  }

  for ( size_t i = 0; i < weights.size(); ++i ) {
    if ( weights[i] == -1.0f ) weights[i] = 0.0f;
  }

  if ( weightsFound ) return weights;
  else return std::vector<float>();
}

/*
void SaveMesh(irr::IrrlichtDevice* device, scene::IAnimatedMesh* animMesh, const std::string& filename, bool exportMaterials, bool exportNormals, bool exportTangents, bool exportAnimations, bool exportLightmaps) {
  scene::IMesh* tangentMesh = NULL;
  if (exportTangents) tangentMesh = device->getSceneManager()->getMeshManipulator()->createMeshWithTangents(animMesh->getMesh(0));

  // Open mesh element
  std::string buffer = "<mesh>\n";

  // Materials
  if (exportMaterials) {
    buffer += "\t<materials>\n";

    // Diffuse
    for (u32 mb = 0; mb < animMesh->getMesh(0)->getMeshBufferCount(); ++mb) {
      const video::SMaterial& mat = animMesh->getMesh(0)->getMeshBuffer(mb)->getMaterial();
      buffer += "\t\t<material>\n";
      buffer += "\t\t\t<name>Material #" + StringFromNumber(mb) + "</name>\n";
      buffer += "\t\t\t<blend>alpha</blend>\n";
      if (mat.getTexture(0)) buffer += std::string("\t\t\t<base_tex>") + StripPath(mat.getTexture(0)->getName().getPath().c_str()) + "</base_tex>\n";
      buffer += "\t\t\t<base_color>" + StringFromNumber(mat.DiffuseColor.getRed() / 255.0f) + "," + StringFromNumber(mat.DiffuseColor.getGreen() / 255.0f) + "," + StringFromNumber(mat.DiffuseColor.getBlue() / 255.0f) + "</base_color>\n";
      buffer += "\t\t\t<opacity>" + StringFromNumber(mat.DiffuseColor.getAlpha() / 255.0f) + "</opacity>\n";
      buffer += "\t\t\t<shininess>" + StringFromNumber(mat.Shininess) + "</shininess>\n";
      buffer += std::string("\t\t\t<culling>") + (mat.BackfaceCulling ? "true" : "false") + "</culling>\n";
      buffer += std::string("\t\t\t<depth_write>") + (mat.ZWriteEnable ? "true" : "false") + "</depth_write>\n";
      buffer += "\t\t</material>\n";
    }

    // Lightmap
    for (u32 mb = 0; mb < animMesh->getMesh(0)->getMeshBufferCount(); ++mb) {
      const video::SMaterial& mat = animMesh->getMesh(0)->getMeshBuffer(mb)->getMaterial();
      if (mat.getTexture(1)) {
        buffer += "\t\t<material>\n";
        buffer += "\t\t\t<name>Material #" + StringFromNumber(animMesh->getMesh(0)->getMeshBufferCount() + mb) + "</name>\n";
        buffer += "\t\t\t<blend>mul</blend>\n";
        buffer += std::string("\t\t\t<base_tex>") + mat.getTexture(1)->getName().getPath().c_str() + ".png</base_tex>\n";
        buffer += "\t\t</material>\n";
      }
    }

    buffer += "\t</materials>\n";
  }

  // Surfaces
  buffer += "\t<surfaces>\n";

  // Diffuse surfaces
  for (u32 mb = 0; mb < animMesh->getMesh(0)->getMeshBufferCount(); ++mb) {
    scene::IMeshBuffer* meshBuffer = animMesh->getMesh(0)->getMeshBuffer(mb);

    buffer += "\t\t<surface>\n";

    // Material or texture
    if (exportMaterials) {
      buffer += "\t\t\t<material>Material #" + StringFromNumber(mb) + "</material>\n";
    }
    else {
      if (meshBuffer->getMaterial().getTexture(0)) buffer += std::string("\t\t\t<base_tex>") + StripPath(meshBuffer->getMaterial().getTexture(0)->getName().getPath().c_str()) + "</base_tex>\n";
    }

    // Indices
    buffer += "\t\t\t<indices>";
    for (u32 i = 0; i < meshBuffer->getIndexCount(); i += 3) {
      if (i > 0) buffer += ",";
      if (VORTEX_HANDEDNESS == VORTEX_LH) {
        buffer += StringFromNumber(meshBuffer->getIndices()[i]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 1]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 2]);
      } else {
        buffer += StringFromNumber(meshBuffer->getIndices()[i]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 2]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 1]);
      }
    }
    buffer += "</indices>\n";

    // Vertices
    std::string coords = "\t\t\t<coords>";
    std::string normals = "\t\t\t<normals>";
    std::string tangents = "\t\t\t<tangents>";
    std::string texcoords = "\t\t\t<texcoords>";
    video::S3DVertexTangents* verticesTangents = static_cast<video::S3DVertexTangents*>(tangentMesh->getMeshBuffer(mb)->getVertices());
    for (u32 v = 0; v < meshBuffer->getVertexCount(); ++v) {
      if (v > 0) {
        coords += ",";
        if (exportNormals) normals += ",";
        if (exportTangents) tangents += ",";
        texcoords += ",";
      }
      if (VORTEX_HANDEDNESS == VORTEX_LH) {
        coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Y) + "," + StringFromNumber(meshBuffer->getPosition(v).Z);
        if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Y) + "," + StringFromNumber(meshBuffer->getNormal(v).Z);
        if (exportTangents) tangents += StringFromNumber(verticesTangents[v].Tangent.X) + "," + StringFromNumber(verticesTangents[v].Tangent.Y) + "," + StringFromNumber(verticesTangents[v].Tangent.Z);
        texcoords += StringFromNumber(meshBuffer->getTCoords(v).X) + "," + StringFromNumber(meshBuffer->getTCoords(v).Y);
      } else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
        coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Y) + "," + StringFromNumber(-meshBuffer->getPosition(v).Z);
        if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Y) + "," + StringFromNumber(-meshBuffer->getNormal(v).Z);
        if (exportTangents) tangents += StringFromNumber(verticesTangents[v].Tangent.X) + "," + StringFromNumber(verticesTangents[v].Tangent.Y) + "," + StringFromNumber(-verticesTangents[v].Tangent.Z);
        texcoords += StringFromNumber(meshBuffer->getTCoords(v).X) + "," + StringFromNumber(-meshBuffer->getTCoords(v).Y);
      } else {
        coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Z) + "," + StringFromNumber(meshBuffer->getPosition(v).Y);
        if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Z) + "," + StringFromNumber(meshBuffer->getNormal(v).Y);
        if (exportTangents) tangents += StringFromNumber(verticesTangents[v].Tangent.X) + "," + StringFromNumber(verticesTangents[v].Tangent.Z) + "," + StringFromNumber(verticesTangents[v].Tangent.Y);
        texcoords += StringFromNumber(meshBuffer->getTCoords(v).X) + "," + StringFromNumber(-meshBuffer->getTCoords(v).Y);
      }
    }
    coords += "</coords>\n";
    normals += "</normals>\n";
    tangents += "</tangents>\n";
    texcoords += "</texcoords>\n";
    buffer += coords;
    if (exportNormals) buffer += normals;
    if (exportTangents) buffer += tangents;
    /*if (meshBuffer->getMaterial().getTexture(0))* / buffer += texcoords;
    std::vector<int> indices = BoneIndicesForSurface(static_cast<scene::ISkinnedMesh*>(animMesh), mb);
    std::vector<float> weights = BoneWeightsForSurface(static_cast<scene::ISkinnedMesh*>(animMesh), mb);
    if ( indices.size() > 0 && weights.size() > 0 ) {
      std::string indicesStr = "\t\t\t<bone_indices>";
      for ( size_t i = 0; i < indices.size(); ++i ) {
        if ( i > 0 ) indicesStr += ",";
        indicesStr += StringFromNumber(indices[i]);
      }
      indicesStr += "</bone_indices>\n";
      std::string weightsStr = "\t\t\t<bone_weights>";
      for ( size_t w = 0; w < weights.size(); ++w ) {
        if ( w > 0 ) weightsStr += ",";
        weightsStr += StringFromNumber(weights[w]);
      }
      weightsStr += "</bone_weights>\n";
      buffer += indicesStr;
      buffer += weightsStr;
    }

    buffer += "\t\t</surface>\n";
  }

  // Lightmap surfaces
  if (exportMaterials) {
    for (u32 mb = 0; mb < animMesh->getMesh(0)->getMeshBufferCount(); ++mb) {
      scene::IMeshBuffer* meshBuffer = animMesh->getMesh(0)->getMeshBuffer(mb);

      if (meshBuffer->getMaterial().getTexture(1)) {
        buffer += "\t\t<surface>\n";

        // Material or texture
        buffer += "\t\t\t<material>Material #" + StringFromNumber(animMesh->getMesh(0)->getMeshBufferCount() + mb) + "</material>\n";

        // Indices
        buffer += "\t\t\t<indices>";
        for (u32 i = 0; i < meshBuffer->getIndexCount(); i += 3) {
          if (i > 0) buffer += ",";
          if (VORTEX_HANDEDNESS == VORTEX_LH) {
            buffer += StringFromNumber(meshBuffer->getIndices()[i]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 1]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 2]);
          } else {
            buffer += StringFromNumber(meshBuffer->getIndices()[i]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 2]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 1]);
          }
        }
        buffer += "</indices>\n";

        // Vertices
        std::string coords = "\t\t\t<coords>";
        std::string normals = "\t\t\t<normals>";
        std::string texcoords = "\t\t\t<texcoords>";
        video::S3DVertex2TCoords* vertices2t = static_cast<video::S3DVertex2TCoords*>(meshBuffer->getVertices());
        for (u32 v = 0; v < meshBuffer->getVertexCount(); ++v) {
          if (v > 0) {
            coords += ",";
            if (exportNormals) normals += ",";
            texcoords += ",";
          }
          if (VORTEX_HANDEDNESS == VORTEX_LH) {
            coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Y) + "," + StringFromNumber(meshBuffer->getPosition(v).Z);
            if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Y) + "," + StringFromNumber(meshBuffer->getNormal(v).Z);
            texcoords += StringFromNumber(vertices2t[v].TCoords2.X) + "," + StringFromNumber(vertices2t[v].TCoords2.Y);
          } else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
            coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Y) + "," + StringFromNumber(-meshBuffer->getPosition(v).Z);
            if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Y) + "," + StringFromNumber(-meshBuffer->getNormal(v).Z);
            texcoords += StringFromNumber(vertices2t[v].TCoords2.X) + "," + StringFromNumber(-vertices2t[v].TCoords2.Y);
          } else {
            coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Z) + "," + StringFromNumber(-meshBuffer->getPosition(v).Y);
            if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Z) + "," + StringFromNumber(meshBuffer->getNormal(v).Y);
            texcoords += StringFromNumber(vertices2t[v].TCoords2.X) + "," + StringFromNumber(-vertices2t[v].TCoords2.Y);
          }
        }
        coords += "</coords>\n";
        normals += "</normals>\n";
        texcoords += "</texcoords>\n";
        buffer += coords;
        if (exportNormals) buffer += normals;
        buffer += texcoords;

        buffer += "\t\t</surface>\n";
      }
    }
  }

  buffer += "\t</surfaces>\n";

  // Export animations
  if (exportAnimations && animMesh->getMeshType() == scene::EAMT_SKINNED && animMesh->getFrameCount() > 1) {
    scene::ISkinnedMesh* skinnedMesh = static_cast<scene::ISkinnedMesh*>(animMesh);

    // Export last frame id
    buffer += "\t<last_frame>" + StringFromNumber(skinnedMesh->getFrameCount()) + "</last_frame>\n";

    // Export bones
    buffer += "\t<bones>\n";
    const core::array<scene::ISkinnedMesh::SJoint*>& joints = skinnedMesh->getAllJoints();
    for (u32 i = 0; i < joints.size(); ++i) {
      buffer += "\t\t<bone>\n";

      buffer += std::string("\t\t\t<name>") + joints[i]->Name.c_str() + "</name>\n";

      scene::ISkinnedMesh::SJoint* parent = FindParent(skinnedMesh, joints[i]);
      if (parent) buffer += std::string("\t\t\t<parent>") + parent->Name.c_str() + "</parent>\n";

      irr::core::matrix4 invPose = joints[i]->GlobalInversedMatrix;
      buffer += "\t\t\t<inv_pose>";
      for (u32 m = 0; m < 16; ++m) {
        buffer += StringFromNumber(invPose[m]);
        if ( m < 15 ) buffer + ",";
      }
      buffer += "</inv_pose>\n";
      /*
      core::vector3df irrPosition = joints[i]->LocalMatrix.getTranslation();
      core::vector3df irrRotation = joints[i]->LocalMatrix.getRotationDegrees();
      core::vector3df irrScale = joints[i]->LocalMatrix.getScale();
      glm::quat rotation(glm::radians(glm::vec3(irrRotation.X, irrRotation.Y, irrRotation.Z)));
      if (VORTEX_HANDEDNESS == VORTEX_LH) {
        buffer += "\t\t\t<def_position>" + StringFromNumber(irrPosition.X) + "," + StringFromNumber(irrPosition.Y) + "," + StringFromNumber(irrPosition.Z) + "</def_position>\n";
        buffer += "\t\t\t<def_rotation>" + StringFromNumber(rotation.w) + "," + StringFromNumber(rotation.x) + "," + StringFromNumber(rotation.y) + "," + StringFromNumber(rotation.z) + "</def_rotation>\n";
        buffer += "\t\t\t<def_scale>" + StringFromNumber(irrScale.X) + "," + StringFromNumber(irrScale.Y) + "," + StringFromNumber(irrScale.Z) + "</def_scale>\n";
      } else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
        rotation = glm::quat(glm::radians(glm::vec3(-irrRotation.X, -irrRotation.Y, -irrRotation.Z)));
        buffer += "\t\t\t<def_position>" + StringFromNumber(irrPosition.X) + "," + StringFromNumber(irrPosition.Y) + "," + StringFromNumber(-irrPosition.Z) + "</def_position>\n";
        buffer += "\t\t\t<def_rotation>" + StringFromNumber(rotation.w) + "," + StringFromNumber(rotation.x) + "," + StringFromNumber(rotation.y) + "," + StringFromNumber(rotation.z) + "</def_rotation>\n";
        buffer += "\t\t\t<def_scale>" + StringFromNumber(irrScale.X) + "," + StringFromNumber(irrScale.Y) + "," + StringFromNumber(irrScale.Z) + "</def_scale>\n";
      } else {
        buffer += "\t\t\t<def_position>" + StringFromNumber(irrPosition.X) + "," + StringFromNumber(irrPosition.Z) + "," + StringFromNumber(irrPosition.Y) + "</def_position>\n";
        buffer += "\t\t\t<def_rotation>" + StringFromNumber(-rotation.w) + "," + StringFromNumber(rotation.x) + "," + StringFromNumber(rotation.y) + "," + StringFromNumber(rotation.z) + "</def_rotation>\n";
        buffer += "\t\t\t<def_scale>" + StringFromNumber(irrScale.X) + "," + StringFromNumber(irrScale.Z) + "," + StringFromNumber(irrScale.Y) + "</def_scale>\n";
      }
      * /

      if (joints[i]->AttachedMeshes.size() > 0) {
        buffer += "\t\t\t<surfaces>";
        for (u32 j = 0; j < joints[i]->AttachedMeshes.size(); ++j) {
          buffer += StringFromNumber(joints[i]->AttachedMeshes[j]);
          if (j < joints[i]->AttachedMeshes.size() - 1) buffer + ",";
        }
        buffer += "</surfaces>\n";
      }

      if (joints[i]->PositionKeys.size() > 0) {
        buffer += "\t\t\t<positions>";
        for (u32 j = 0; j < joints[i]->PositionKeys.size(); ++j) {
          if (VORTEX_HANDEDNESS == VORTEX_LH) {
            buffer += StringFromNumber(int(joints[i]->PositionKeys[j].frame)) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.X) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Y) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Z);
          } else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
            buffer += StringFromNumber(int(joints[i]->PositionKeys[j].frame)) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.X) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Y) + "," + StringFromNumber(-joints[i]->PositionKeys[j].position.Z);
          } else {
            buffer += StringFromNumber(int(joints[i]->PositionKeys[j].frame)) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.X) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Z) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Y);
          }
          if (j < joints[i]->PositionKeys.size() - 1) buffer += ",";
        }
        buffer += "</positions>\n";
      }
      else if (joints[i]->RotationKeys.size() > 0 || joints[i]->ScaleKeys.size() > 0) {
        buffer += "\t\t\t<positions>0,0,0,0</positions>\n";
      }

      if (joints[i]->RotationKeys.size() > 0) {
        buffer += "\t\t\t<rotations>";
        for (u32 j = 0; j < joints[i]->RotationKeys.size(); ++j) {
          if (VORTEX_HANDEDNESS == VORTEX_LH) {
            buffer += StringFromNumber(int(joints[i]->RotationKeys[j].frame)) + "," + StringFromNumber(-joints[i]->RotationKeys[j].rotation.W) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.X) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Y) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Z);
          } else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
            buffer += StringFromNumber(int(joints[i]->RotationKeys[j].frame)) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.W) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.X) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Y) + "," + StringFromNumber(-joints[i]->RotationKeys[j].rotation.Z);
          } else {
            buffer += StringFromNumber(int(joints[i]->RotationKeys[j].frame)) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.W) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.X) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Z) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Y);
          }
          if (j < joints[i]->RotationKeys.size() - 1) buffer += ",";
        }
        buffer += "</rotations>\n";
      }
      else if (joints[i]->PositionKeys.size() > 0 || joints[i]->ScaleKeys.size() > 0) {
        buffer += "\t\t\t<rotations>0,1,0,0,0</rotations>\n";
      }

      if (joints[i]->ScaleKeys.size() > 0) {
        buffer += "\t\t\t<scales>";
        for (u32 j = 0; j < joints[i]->ScaleKeys.size(); ++j) {
          if (VORTEX_HANDEDNESS == VORTEX_RH_Z) {
            buffer += StringFromNumber(int(joints[i]->ScaleKeys[j].frame)) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.X) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Z) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Y);
          } else {
            buffer += StringFromNumber(int(joints[i]->ScaleKeys[j].frame)) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.X) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Y) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Z);
          }
          if (j < joints[i]->ScaleKeys.size() - 1) buffer += ",";
        }
        buffer += "</scales>\n";
      }
      else if (joints[i]->PositionKeys.size() > 0 || joints[i]->RotationKeys.size() > 0) {
        buffer += "\t\t\t<scales>0,1,1,1</scales>\n";
      }

      buffer += "\t\t</bone>\n";
    }
    buffer += "\t</bones>\n";
  }

  // Close mesh element and save
  buffer += "</mesh>\n";
  WriteString(buffer, filename, false);

  // Save lightmaps
  if (exportLightmaps) SaveLightmaps(animMesh->getMesh(0));
}

void SaveLightmaps(scene::IMesh* mesh) {
  for (u32 mb = 0; mb < mesh->getMeshBufferCount(); ++mb) {
    scene::IMeshBuffer* meshBuffer = mesh->getMeshBuffer(mb);
    video::ITexture* tex = meshBuffer->getMaterial().getTexture(1);
    if (tex) {
      // Copy buffer of pixels and swap red and blue
      u32 size = tex->getSize().Width * tex->getSize().Height * 4;
      u8* pixels = static_cast<u8*>(malloc(size));
      memcpy(pixels, tex->lock(video::ETLM_READ_ONLY), size);
      tex->unlock();
      for (u32 y = 0; y < tex->getSize().Height; ++y) {
        for (u32 x = 0; x < tex->getSize().Width; ++x) {
          u8 c = pixels[(y*tex->getSize().Width + x) * 4 + 0];
          pixels[(y*tex->getSize().Width + x) * 4 + 0] = pixels[(y*tex->getSize().Width + x) * 4 + 2];
          pixels[(y*tex->getSize().Width + x) * 4 + 2] = c;
        }
      }

      // Write lightmap
      stbi_write_png((std::string(tex->getName().getPath().c_str()) + ".png").c_str(), tex->getSize().Width, tex->getSize().Height, 4, pixels, 0);

      // Free buffer
      free(pixels);
    }
  }
}

scene::ISkinnedMesh::SJoint* FindParent(scene::ISkinnedMesh* mesh, const scene::ISkinnedMesh::SJoint* joint) {
  for (u32 i = 0; i < mesh->getJointCount(); ++i) {
    for (u32 j = 0; j < mesh->getAllJoints()[i]->Children.size(); ++j) {
      if (mesh->getAllJoints()[i]->Children[j]->Name == joint->Name) {
        return mesh->getAllJoints()[i];
      }
    }
  }
  return NULL;
}
*/
