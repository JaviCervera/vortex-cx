#include "mesh.h"

std::string GenXML(const mesh_t* mesh);

int main(int argc, char* argv[]) {
  mesh_t* mesh = LoadMesh(argv[1]);
  if ( mesh ) {
    printf("%s\n", GenXML(mesh).c_str());
    DeleteMesh(mesh);
  } else {
    printf("ERROR: Could not load mesh '%s'.\n", argv[1]);
  }
}
