#include "mesh.h"
#include "stringutils.h"
#include <string>

std::string GenXML(const mesh_t* mesh) {
  std::string buffer = "<mesh>\n";

  // gen materials
  buffer += "\t<materials>\n";
  for ( size_t i = 0; i < mesh->surfaces.size(); ++i ) {
    const material_t& mat = mesh->surfaces[i].material;
    buffer += "\t\t<material>\n";
    buffer += "\t\t\t<name>Material #" + StringFromNumber(i) + "</name>\n";
    buffer += "\t\t\t<blend>";
    switch ( mat.blend ) {
    case 0:
      buffer += "alpha";
      break;
    case 1:
      buffer += "add";
      break;
    case 2:
      buffer += "mul";
      break;
    }
    buffer += "</blend>\n";
    if ( mat.base_tex != "" ) buffer += "\t\t\t<diffuse_tex>" + mat.base_tex + "</diffuse_tex>\n";
    if ( mat.lightmap != "" ) buffer += "\t\t\t<lightmap>" + mat.lightmap + "</lightmap>\n";
    buffer += "\t\t\t<diffuse_color>" + StringFromNumber(mat.red) + "," + StringFromNumber(mat.green) + "," + StringFromNumber(mat.blue) + "</diffuse_color>\n";
    buffer += "\t\t\t<opacity>" + StringFromNumber(mat.opacity) + "</opacity>\n";
    buffer += "\t\t\t<shininess>" + StringFromNumber(mat.shininess) + "</shininess>\n";
    buffer += "\t\t\t<culling>" + std::string(mat.culling ? "true" : "false") + "</culling>\n";
    buffer += "\t\t\t<depth_write>" + std::string(mat.depth_write ? "true" : "false") + "</depth_write>\n";
    buffer += "\t\t</material>\n";
  }
  buffer += "\t</materials>\n";

  // gen surfaces
  buffer += "\t<surfaces>\n";
  for ( size_t i = 0; i < mesh->surfaces.size(); ++i ) {
    const surface_t& surf = mesh->surfaces[i];
    buffer += "\t\t<surface>\n";
    buffer += "\t\t\t<material>Material #" + StringFromNumber(i) + "</material>\n";
    buffer += "\t\t\t<indices>";
    for ( size_t j = 0; j < surf.indices.size(); ++j ) {
      buffer += StringFromNumber(surf.indices[j]);
      if ( j < surf.indices.size() - 1 ) buffer += ",";
    }
    buffer += "</indices>\n";
    buffer += "\t\t\t<coords>";
    for ( size_t j = 0; j < surf.vertices.size(); ++j ) {
      buffer += StringFromNumber(surf.vertices[j].x) + "," + StringFromNumber(surf.vertices[j].y) + "," + StringFromNumber(surf.vertices[j].z);
      if ( j < surf.vertices.size() - 1 ) buffer += ",";
    }
    buffer += "</coords>\n";
    buffer += "\t\t\t<normals>";
    for ( size_t j = 0; j < surf.vertices.size(); ++j ) {
      buffer += StringFromNumber(surf.vertices[j].nx) + "," + StringFromNumber(surf.vertices[j].ny) + "," + StringFromNumber(surf.vertices[j].nz);
      if ( j < surf.vertices.size() - 1 ) buffer += ",";
    }
    buffer += "</normals>\n";
    buffer += "\t\t\t<texcoords>";
    for ( size_t j = 0; j < surf.vertices.size(); ++j ) {
      buffer += StringFromNumber(surf.vertices[j].u0) + "," + StringFromNumber(surf.vertices[j].v0);
      if ( j < surf.vertices.size() - 1 ) buffer += ",";
    }
    buffer += "</texcoords>\n";
    buffer += "\t\t\t<texcoords2>";
    for ( size_t j = 0; j < surf.vertices.size(); ++j ) {
      buffer += StringFromNumber(surf.vertices[j].u1) + "," + StringFromNumber(surf.vertices[j].v1);
      if ( j < surf.vertices.size() - 1 ) buffer += ",";
    }
    buffer += "</texcoords2>\n";
    buffer += "\t\t\t<bone_indices>";
    for ( size_t j = 0; j < surf.vertices.size(); ++j ) {
      buffer += StringFromNumber(surf.vertices[j].bones[0]) + "," + StringFromNumber(surf.vertices[j].bones[1]) + "," + StringFromNumber(surf.vertices[j].bones[2]) + "," + StringFromNumber(surf.vertices[j].bones[3]);
      if ( j < surf.vertices.size() - 1 ) buffer += ",";
    }
    buffer += "</bone_indices>\n";
    buffer += "\t\t\t<bone_weights>";
    for ( size_t j = 0; j < surf.vertices.size(); ++j ) {
      buffer += StringFromNumber(surf.vertices[j].weights[0]) + "," + StringFromNumber(surf.vertices[j].weights[1]) + "," + StringFromNumber(surf.vertices[j].weights[2]) + "," + StringFromNumber(surf.vertices[j].weights[3]);
      if ( j < surf.vertices.size() - 1 ) buffer += ",";
    }
    buffer += "</bone_weights>\n";
    buffer += "\t\t</surface>\n";
  }
  buffer += "\t</surfaces>\n";

  // gen last frame
  buffer += "\t<last_frame>" + StringFromNumber(mesh->num_frames) + "</last_frame>\n";

  // gen bones
  buffer += "\t<bones>\n";
  for ( size_t i = 0; i < mesh->bones.size(); ++i ) {
    const bone_t& bone = mesh->bones[i];
    buffer += "\t\t<bone>\n";
    buffer += "\t\t\t<name>" + bone.name + "</name>\n";
    if ( bone.parent_index != -1 ) buffer += "\t\t\t<parent>" + mesh->bones[bone.parent_index].name + "</parent>\n";
    buffer += "\t\t\t<inv_pose>";
    for ( size_t j = 0; j < 16; ++j ) {
      buffer += StringFromNumber(bone.inv_pose[j]);
      if ( j < 15 ) buffer += ",";
    }
    buffer += "</inv_pose>\n";
    if ( bone.positions.size() > 0 ) {
      buffer += "\t\t\t<positions>";
      for ( size_t j = 0; j < bone.positions.size(); ++j ) {
        buffer += StringFromNumber(bone.positions[j].first) + "," + StringFromNumber(bone.positions[j].second.x) + "," + StringFromNumber(bone.positions[j].second.y) + "," + StringFromNumber(bone.positions[j].second.z);
        if ( j < bone.positions.size() - 1 ) buffer += ",";
      }
      buffer += "</positions>\n";
    }
    if ( bone.positions.size() > 0 ) {
      buffer += "\t\t\t<rotations>";
      for ( size_t j = 0; j < bone.rotations.size(); ++j ) {
        buffer += StringFromNumber(bone.rotations[j].first) + "," + StringFromNumber(bone.rotations[j].second.w) + "," + StringFromNumber(bone.rotations[j].second.x) + "," + StringFromNumber(bone.rotations[j].second.y) + "," + StringFromNumber(bone.rotations[j].second.z);
        if ( j < bone.rotations.size() - 1 ) buffer += ",";
      }
      buffer += "</rotations>\n";
    }
    if ( bone.scales.size() > 0 ) {
      buffer += "\t\t\t<scales>";
      for ( size_t j = 0; j < bone.scales.size(); ++j ) {
        buffer += StringFromNumber(bone.scales[j].first) + "," + StringFromNumber(bone.scales[j].second.x) + "," + StringFromNumber(bone.scales[j].second.y) + "," + StringFromNumber(bone.scales[j].second.z);
        if ( j < bone.scales.size() - 1 ) buffer += ",";
      }
      buffer += "</scales>\n";
    }
    buffer += "\t\t</bone>\n";
  }
  buffer += "\t</bones>\n";

  buffer += "</mesh>\n";

  return buffer;
}
