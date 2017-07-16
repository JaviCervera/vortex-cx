#include "mesh.h"
#include "stringutils.h"
#include <iostream>

using namespace std;

std::string GenXML(const mesh_t* mesh);

int main(int argc, char* argv[]) {
  if ( argc != 2 ) {
    cout << "Usage: meshtool meshfile" << endl;
    return -1;
  }
  mesh_t* mesh = LoadMesh(argv[1]);
  if ( mesh ) {
    string meshXML = GenXML(mesh);
    cout << meshXML << endl;
    //WriteString(meshXML, argv[2], false);
    DeleteMesh(mesh);
  } else {
    cout << "ERROR: Could not load mesh '" << argv[1] << "'." << endl;
  }
  return 0;
}
