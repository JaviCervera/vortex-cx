#include "mesh.h"
#include "stringutils.h"
#include <iostream>

using namespace std;

void SaveMSH(const mesh_t* mesh, const std::string& filename);
void SaveSKL(const mesh_t* mesh, const std::string& filename);
void SaveANM(const mesh_t* mesh, const std::string& filename);

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

  // save mesh
  SaveMSH(mesh, StripExt(argv[1]) + ".msh.dat");
  SaveSKL(mesh, StripExt(argv[1]) + ".skl.dat");
  SaveANM(mesh, StripExt(argv[1]) + ".anm.dat");
  
  // deletes mesh from memory
  DeleteMesh(mesh);

  return 0;
}
