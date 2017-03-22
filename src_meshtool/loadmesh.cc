// TODO:
// - Export vertex colors

#define _IRR_STATIC_LIB_
#include "irrlicht/irrlicht.h"
#include "mesh.h"

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
int FindParentIndex(scene::ISkinnedMesh* mesh, const scene::ISkinnedMesh::SJoint* joint);
std::vector<int> BoneIndicesForSurface(scene::ISkinnedMesh* mesh, u32 surface);
std::vector<float> BoneWeightsForSurface(scene::ISkinnedMesh* mesh, u32 surface);

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
          surf.vertices[b/4].bones[0] = indices[b];
          surf.vertices[b/4].bones[1] = indices[b+1];
          surf.vertices[b/4].bones[2] = indices[b+2];
          surf.vertices[b/4].bones[3] = indices[b+3];
          surf.vertices[b/4].weights[0] = weights[b];
          surf.vertices[b/4].weights[1] = weights[b+1];
          surf.vertices[b/4].weights[2] = weights[b+2];
          surf.vertices[b/4].weights[3] = weights[b+3];
        }
      }

      mesh->surfaces.push_back(surf);
    }

    // bones
    if ( skinned_mesh ) {
      const core::array<scene::ISkinnedMesh::SJoint*>& joints = skinned_mesh->getAllJoints();
      for ( size_t b = 0; b < joints.size(); ++b ) {
        scene::ISkinnedMesh::SJoint* joint = joints[b];

        bone_t bone;

        // name and parent index
        bone.name = joint->Name.c_str();
        bone.parent_index = FindParentIndex(skinned_mesh, joint);

        // inverse pose matrix
        core::matrix4 inv_pose = joint->GlobalInversedMatrix;
        for ( size_t m = 0; m < 16; ++m ) {
          bone.inv_pose[m] = inv_pose[m];
        }

        // Convert non-skeletal meshes
        for ( size_t i = 0; i < joint->AttachedMeshes.size(); ++i ) {
          int surf_index = joint->AttachedMeshes[i];
          scene::IMeshBuffer* mesh_buffer = irr_mesh->getMeshBuffer(surf_index);

          // update vertices
          for ( size_t v = 0; v < mesh->surfaces[surf_index].vertices.size(); ++v ) {
            // move vertex from bone to model space
            core::vector3df model_pos(mesh->surfaces[surf_index].vertices[v].x, mesh->surfaces[surf_index].vertices[v].y, mesh->surfaces[surf_index].vertices[v].z);
            joint->GlobalMatrix.transformVect(model_pos);
            mesh->surfaces[surf_index].vertices[v].x = model_pos.X;
            mesh->surfaces[surf_index].vertices[v].y = model_pos.Y;
            mesh->surfaces[surf_index].vertices[v].z = model_pos.Z;

            // set vertex bone and weight
            mesh->surfaces[surf_index].vertices[v].bones[0] = b;
            mesh->surfaces[surf_index].vertices[v].weights[0] = 1;
          }
        }

        // position keys
        if ( joint->PositionKeys.size() > 0 ) {
          for ( size_t p = 0; p < joint->PositionKeys.size(); ++p ) {
            bone.positions.push_back(std::pair<int, vec3_t>(
              static_cast<int>(joint->PositionKeys[p].frame),
              vec3_t(joint->PositionKeys[p].position.X, joint->PositionKeys[p].position.Y, joint->PositionKeys[p].position.Z)
            ));
          }
        } else if ( joint->RotationKeys.size() > 0 || joint->ScaleKeys.size() > 0 ) {
          bone.positions.push_back(std::pair<int, vec3_t>(0, vec3_t(0, 0, 0)));
        }

        // rotation keys
        if ( joint->RotationKeys.size() > 0 ) {
          for ( size_t r = 0; r < joint->RotationKeys.size(); ++r ) {
            bone.rotations.push_back(std::pair<int, quat_t>(
              static_cast<int>(joint->RotationKeys[r].frame),
              quat_t(-joint->RotationKeys[r].rotation.W, joint->RotationKeys[r].rotation.X, joint->RotationKeys[r].rotation.Y, joint->RotationKeys[r].rotation.Z)
            ));
          }
        } else if ( joint->PositionKeys.size() > 0 || joint->ScaleKeys.size() > 0 ) {
          bone.rotations.push_back(std::pair<int, quat_t>(0, quat_t(1, 0, 0, 0)));
        }

        // scale keys
        if ( joint->ScaleKeys.size() > 0 ) {
          for ( size_t s = 0; s < joint->ScaleKeys.size(); ++s ) {
            bone.scales.push_back(std::pair<int, vec3_t>(
              static_cast<int>(joint->ScaleKeys[s].frame),
              vec3_t(joint->ScaleKeys[s].scale.X, joint->ScaleKeys[s].scale.Z, joint->ScaleKeys[s].scale.Y)
            ));
          }
        } else if ( joint->PositionKeys.size() > 0 || joint->RotationKeys.size() > 0 ) {
          bone.scales.push_back(std::pair<int, vec3_t>(0, vec3_t(1, 1, 1)));
        }

        mesh->bones.push_back(bone);
      }
    }

    // num frames
    mesh->num_frames = anim_mesh->getFrameCount();
  }

  // optimize mesh
  size_t s = 1;
  while ( s < mesh->surfaces.size() ) {
    // look for a previous surface with same material
    int same_mat_surf_index = -1;
    for ( size_t i = 0; i < s; ++i ) {
      if ( mesh->surfaces[s].material == mesh->surfaces[i].material ) {
        same_mat_surf_index = i;
        break;
      }
    }

    // if it has been found, merge both surfaces
    if ( same_mat_surf_index > -1 ) {
      size_t new_first = mesh->surfaces[same_mat_surf_index].vertices.size();

      // add vertices
      for ( size_t i = 0; i < mesh->surfaces[s].vertices.size(); ++i ) {
        mesh->surfaces[same_mat_surf_index].vertices.push_back(mesh->surfaces[s].vertices[i]);
      }

      // add indices
      for ( size_t i = 0; i < mesh->surfaces[s].indices.size(); ++i ) {
        mesh->surfaces[same_mat_surf_index].indices.push_back(new_first + mesh->surfaces[s].indices[i]);
      }

      // remove second surface
      mesh->surfaces.erase(mesh->surfaces.begin() + s);
    // otherwise, go to next surface
    } else {
      ++s;
    }
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

EXPORT int CALL NumBones(const mesh_t* mesh) {
  return static_cast<int>(mesh->bones.size());
}

EXPORT const char* CALL BoneName(const mesh_t* mesh, int bone_index) {
  return mesh->bones[bone_index].name.c_str();
}

EXPORT int CALL BoneParentIndex(const mesh_t* mesh, int bone_index) {
  return mesh->bones[bone_index].parent_index;
}

EXPORT float CALL BoneInvPoseMatrixElem(const mesh_t* mesh, int bone_index, int elem_index) {
  return mesh->bones[bone_index].inv_pose[elem_index];
}

EXPORT int CALL BoneNumPositionKeys(const mesh_t* mesh, int bone_index) {
  return static_cast<int>(mesh->bones[bone_index].positions.size());
}

EXPORT int CALL BoneNumRotationKeys(const mesh_t* mesh, int bone_index) {
  return static_cast<int>(mesh->bones[bone_index].rotations.size());
}

EXPORT int CALL BoneNumScaleKeys(const mesh_t* mesh, int bone_index) {
  return static_cast<int>(mesh->bones[bone_index].scales.size());
}

EXPORT int CALL BonePositionKeyFrame(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].positions[key_index].first;
}

EXPORT float CALL BonePositionKeyX(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].positions[key_index].second.x;
}

EXPORT float CALL BonePositionKeyY(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].positions[key_index].second.y;
}

EXPORT float CALL BonePositionKeyZ(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].positions[key_index].second.z;
}

EXPORT int CALL BoneRotationKeyFrame(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].rotations[key_index].first;
}

EXPORT float CALL BoneRotationKeyW(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].rotations[key_index].second.w;
}

EXPORT float CALL BoneRotationKeyX(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].rotations[key_index].second.x;
}

EXPORT float CALL BoneRotationKeyY(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].rotations[key_index].second.y;
}

EXPORT float CALL BoneRotationKeyZ(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].rotations[key_index].second.z;
}

EXPORT int CALL BoneScaleKeyFrame(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].scales[key_index].first;
}

EXPORT float CALL BoneScaleKeyX(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].scales[key_index].second.x;
}

EXPORT float CALL BoneScaleKeyY(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].scales[key_index].second.y;
}

EXPORT float CALL BoneScaleKeyZ(const mesh_t* mesh, int bone_index, int key_index) {
  return mesh->bones[bone_index].scales[key_index].second.z;
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

int FindParentIndex(scene::ISkinnedMesh* mesh, const scene::ISkinnedMesh::SJoint* joint) {
  for ( size_t i = 0; i < mesh->getJointCount(); ++i ) {
    for (size_t j = 0; j < mesh->getAllJoints()[i]->Children.size(); ++j ) {
      if ( mesh->getAllJoints()[i]->Children[j]->Name == joint->Name ) {
        return static_cast<int>(i);
      }
    }
  }
  return -1;
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
*/
