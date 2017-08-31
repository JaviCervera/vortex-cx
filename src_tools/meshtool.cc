#include "mesh.h"
#include "stringutils.h"
#include <iostream>

using namespace std;

std::string GenXML(const mesh_t* mesh);

int main(int argc, char* argv[]) {
  // check command line
  if ( argc != 2 ) {
    cout << "Usage: meshtool meshfile" << endl;
    return -1;
  }
  
  // load mesh
  mesh_t* mesh = LoadMesh(argv[1]);
  if ( !mesh ) {
    cout << "ERROR: Could not load mesh '" << argv[1] << "'" << endl;
    return -1;
  }
  
  // generate xml description of mesh
  string meshXML = GenXML(mesh);
  
  // writes the mesh to a file
  WriteString(meshXML, StripExt(argv[1]) + ".msh.xml", false);
  //cout << meshXML << endl;
  
  // deletes mesh from memory
  DeleteMesh(mesh);

  return 0;
}
