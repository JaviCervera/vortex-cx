#ifndef MESHTOOL_MESH_H
#define MESHTOOL_MESH_H

#include <string>

namespace irr {
  class IrrlichtDevice;
  namespace scene {
    class IAnimatedMesh;
  }
}

irr::scene::IAnimatedMesh* LoadMesh(irr::IrrlichtDevice* device, const std::string& filename);
void SaveMesh(irr::IrrlichtDevice* device, irr::scene::IAnimatedMesh* animMesh, const std::string& filename, bool exportMaterials, bool exportNormals, bool exportTangents, bool exportAnimations, bool exportLightmaps);

#endif // MESHTOOL_MESH_H
