// TODO:
// - export vertex colors

#define _IRR_STATIC_LIB_
#include "irrlicht/irrlicht.h"
#include "mesh.h"
#include <set>

using namespace irr;

// forward declaration of functions
std::set<int> KeyframeSet(irr::scene::ISkinnedMesh* skinned_mesh);
int FindParentIndex(scene::ISkinnedMesh* mesh, const scene::ISkinnedMesh::SJoint* joint);
std::vector<int> BoneIndicesForSurface(scene::ISkinnedMesh* mesh, u32 surface);
std::vector<float> BoneWeightsForSurface(scene::ISkinnedMesh* mesh, u32 surface);

extern "C" {

EXPORT mesh_t* CALL LoadMesh(const char* filename) {
  mesh_t* mesh = NULL;

  // create irrlicht device
  SIrrlichtCreationParameters params;
  params.DeviceType = EIDT_CONSOLE;
  params.DriverType = video::EDT_NULL;
  params.LoggingLevel = ELL_NONE;
  IrrlichtDevice* device = createDeviceEx(params);

  // load mesh
  scene::IAnimatedMesh* anim_mesh = device->getSceneManager()->getMesh(filename);
  if ( !anim_mesh ) return NULL;

  // recalculate normals
  device->getVideoDriver()->getMeshManipulator()->recalculateNormals(anim_mesh);

  // get different versions of the mesh (animated, static, with tangents)
  scene::ISkinnedMesh* skinned_mesh = ( anim_mesh->getMeshType() == scene::EAMT_SKINNED && anim_mesh->getFrameCount() > 1 ) ? static_cast<scene::ISkinnedMesh*>(anim_mesh) : 0;
  scene::IMesh* irr_mesh = anim_mesh->getMesh(0);
  scene::IMesh* tangent_mesh = device->getVideoDriver()->getMeshManipulator()->createMeshWithTangents(irr_mesh);

  // get keyframes set (used for vertex animation)
  std::set<int> keyframes = KeyframeSet(skinned_mesh);

  // create mesh object
  mesh = new mesh_t;

  // surfaces
  for ( size_t i = 0; i < irr_mesh->getMeshBufferCount(); ++i ) {
    scene::IMeshBuffer* mesh_buffer = irr_mesh->getMeshBuffer(i);
    const video::SMaterial& mat = mesh_buffer->getMaterial();

    surface_t surf;

    // material
    std::string base_tex = mat.getTexture(0) ? mat.getTexture(0)->getName().getPath().c_str() : "";
    std::string lightmap = mat.getTexture(1) ? mat.getTexture(1)->getName().getPath().c_str() : "";
    unsigned char r = mat.DiffuseColor.getRed();
    unsigned char g = mat.DiffuseColor.getGreen();
    unsigned char b = mat.DiffuseColor.getBlue();
    unsigned char a = mat.DiffuseColor.getAlpha();
    float shininess = mat.Shininess;
    int culling = mat.BackfaceCulling;
    int depth_write = mat.ZWriteEnable;
    surf.material = material_t(0, base_tex, lightmap, r, g, b, a, shininess, culling, depth_write);

    // indices
    for (size_t j = 0; j < mesh_buffer->getIndexCount(); ++j) {
      surf.indices.push_back(mesh_buffer->getIndices()[j]);
    }

    // vertices
    video::S3DVertex2TCoords* vertices2t = mesh_buffer->getVertexType() == video::EVT_2TCOORDS ? static_cast<video::S3DVertex2TCoords*>(mesh_buffer->getVertices()) : 0;
    video::S3DVertexTangents* verticesTangents = tangent_mesh->getMeshBuffer(i)->getVertexType() == video::EVT_TANGENTS ? static_cast<video::S3DVertexTangents*>(tangent_mesh->getMeshBuffer(i)->getVertices()) : 0;
    for ( size_t v = 0; v < mesh_buffer->getVertexCount(); ++v ) {
      float x = mesh_buffer->getPosition(v).X;
      float y = mesh_buffer->getPosition(v).Y;
      float z = mesh_buffer->getPosition(v).Z;
      float nx = mesh_buffer->getNormal(v).X;
      float ny = mesh_buffer->getNormal(v).Y;
      float nz = mesh_buffer->getNormal(v).Z;
      float u0 = mesh_buffer->getTCoords(v).X;
      float v0 = mesh_buffer->getTCoords(v).Y;
      float u1 = vertices2t ? vertices2t[v].TCoords2.X : u0;
      float v1 = vertices2t ? vertices2t[v].TCoords2.Y : v0;
      float tx = verticesTangents ? verticesTangents[v].Tangent.X : 0;
      float ty = verticesTangents ? verticesTangents[v].Tangent.Y : 0;
      float tz = verticesTangents ? verticesTangents[v].Tangent.Z : 0;
      surf.vertices.push_back(vertex_t(x, y, z, nx, ny, nz, u0, v0, u1, v1));
      surf.vertices.back().tx = tx;
      surf.vertices.back().ty = ty;
      surf.vertices.back().tz = tz;
    }

    // vertex animation frames
    if ( skinned_mesh && keyframes.size() > 0 ) {
      for ( std::set<int>::const_iterator it = keyframes.begin(); it != keyframes.end(); ++it ) {
        scene::IMeshBuffer* mesh_buffer = anim_mesh->getMesh(*it)->getMeshBuffer(i);
        vertexframe_t frame;
        frame.frame = *it;
        frame.positions.resize(mesh_buffer->getVertexCount(), vec3_t(0, 0, 0));
        frame.normals.resize(mesh_buffer->getVertexCount(), vec3_t(0, 0, 0));
        for ( size_t v = 0; v < mesh_buffer->getVertexCount(); ++v ) {
          frame.positions[v] = vec3_t(mesh_buffer->getPosition(v).X, mesh_buffer->getPosition(v).Y, mesh_buffer->getPosition(v).Z);
          frame.normals[v] = vec3_t(mesh_buffer->getNormal(v).X, mesh_buffer->getNormal(v).Y, mesh_buffer->getNormal(v).Z);
        }
        surf.vertex_frames.push_back(frame);
      }
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

    // add surface
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
        
      // pose matrix
      core::matrix4 pose = joint->LocalMatrix;
      for ( size_t m = 0; m < 16; ++m ) {
        bone.transform[m] = pose[m];
      }

      // inverse pose matrix
      core::matrix4 inv_pose = joint->GlobalInversedMatrix;
      for ( size_t m = 0; m < 16; ++m ) {
        bone.inv_pose[m] = inv_pose[m];
      }

      // surfaces
      for ( size_t i = 0; i < joint->AttachedMeshes.size(); ++i ) {
        bone.surfaces.push_back(joint->AttachedMeshes[i]);
      }

      // convert non-skeletal meshes
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
            vec3_t(joint->ScaleKeys[s].scale.X, joint->ScaleKeys[s].scale.Y, joint->ScaleKeys[s].scale.Z)
          ));
        }
      } else if ( joint->PositionKeys.size() > 0 || joint->RotationKeys.size() > 0 ) {
        bone.scales.push_back(std::pair<int, vec3_t>(0, vec3_t(1, 1, 1)));
      }

      mesh->bones.push_back(bone);
    }

    // num frames
    mesh->num_frames = skinned_mesh ? anim_mesh->getFrameCount() : 0;
    
    // anim duration
    mesh->anim_speed = skinned_mesh ? anim_mesh->getAnimationSpeed() : 0;
  }

  // optimize mesh
  size_t s = 1;
  while ( s < mesh->surfaces.size() ) {
    // look for a previous surface with same material
    int same_mat_surf_index = -1;
    for ( size_t i = 0; i < s; ++i ) {
      if ( mesh->surfaces[s].material == mesh->surfaces[i].material && mesh->surfaces[s].vertices.size() + mesh->surfaces[i].vertices.size() <= 65535 ) {
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

      // add vertex frames
      for ( size_t i = 0; i < mesh->surfaces[s].vertex_frames.size(); ++i ) {
        for ( size_t j = 0; j < mesh->surfaces[s].vertices.size(); ++j ) {
          mesh->surfaces[same_mat_surf_index].vertex_frames[i].positions.push_back(mesh->surfaces[s].vertex_frames[i].positions[j]);
          mesh->surfaces[same_mat_surf_index].vertex_frames[i].normals.push_back(mesh->surfaces[s].vertex_frames[i].normals[j]);
        }
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

} // extern "C"

std::set<int> KeyframeSet(irr::scene::ISkinnedMesh* skinned_mesh) {
  // make sure that it has frames
  if ( !skinned_mesh || skinned_mesh->getFrameCount() == 0 ) return std::set<int>();

  // create set and add all keyframes to it
  std::set<int> keyframe_set;
  for ( size_t j = 0; j < skinned_mesh->getAllJoints().size(); ++j ) {
    for ( size_t p = 0; p < skinned_mesh->getAllJoints()[j]->PositionKeys.size(); ++p ) {
      keyframe_set.insert(static_cast<int>(skinned_mesh->getAllJoints()[j]->PositionKeys[p].frame));
    }
    for ( size_t r = 0; r < skinned_mesh->getAllJoints()[j]->RotationKeys.size(); ++r ) {
      keyframe_set.insert(static_cast<int>(skinned_mesh->getAllJoints()[j]->RotationKeys[r].frame));
    }
    for ( size_t s = 0; s < skinned_mesh->getAllJoints()[j]->ScaleKeys.size(); ++s ) {
      keyframe_set.insert(static_cast<int>(skinned_mesh->getAllJoints()[j]->ScaleKeys[s].frame));
    }
  }

  // return set
  return keyframe_set;
}

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
