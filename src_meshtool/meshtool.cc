#include "mesh.h"
#include "stringutils.h"

std::string GenXML(const mesh_t* mesh);

int main(int argc, char* argv[]) {
  if ( argc != 2 ) {
    printf("Usage: meshtool meshfile\n");
    return -1;
  }
  mesh_t* mesh = LoadMesh(argv[1]);
  if ( mesh ) {
    std::string meshXML = GenXML(mesh);
    printf("%s\n", meshXML.c_str());
    //WriteString(meshXML, argv[2], false);
    DeleteMesh(mesh);
  } else {
    printf("ERROR: Could not load mesh '%s'.\n", argv[1]);
  }
  return 0;
}
