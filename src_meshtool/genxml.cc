#include "mesh.h"
#include <string>

std::string GenXML(const mesh_t* mesh) {
  std::string buffer = "<mesh>\n";

  // gen materials
  buffer += "\t<materials>\n"
  for ( size_t i = 0; i < mesh->surfaces.size(); ++i ) {
    const material_t& mat = mesh->surfaces[i].material;
    buffer += "\t\t<material>\n";
    buffer += "\t\t\t<name>Material #" + i + "</name>\n";
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
    buffer += "\t\t</material>\n";
  }
  buffer += "\t</materials>\n"

  buffer += "</mesh>\n";

  return buffer;
}
