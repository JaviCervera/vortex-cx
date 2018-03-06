#include "mesh.h"
#include "stringutils.h"
#include <iostream>

using namespace std;

void SaveMSH(const mesh_t* mesh, const std::string& filename, bool exportWeights);
void SaveSKL(const mesh_t* mesh, const std::string& filename);
void SaveANM(const mesh_t* mesh, const std::string& filename);
void SaveVTA(const mesh_t* mesh, const std::string& filename);

int main(int argc, char* argv[]) {
  // check command line
  if ( argc != 2 && argc != 3 ) {
    cout << "Usage: meshtool [option] meshfile" << endl;
    cout << "Option (can be one of the following):" << endl;
    cout << "-vertexanim:\tExport vertex animation" << endl << endl;
    return -1;
  }

  // get arguments
  bool isVertexAnim = false;
  if ( argc > 2 ) {
    if ( string(argv[1]) == "-vertexanim" ) {
      isVertexAnim = true;
    }
  }
  string meshfile = argv[argc-1];
  
  // load mesh
  mesh_t* mesh = LoadMesh(meshfile.c_str());
  if ( !mesh ) {
    cout << "ERROR: Could not load mesh '" << meshfile << "'" << endl;
    return -1;
  }

  // save mesh
  SaveMSH(mesh, StripExt(meshfile) + ".msh.dat", !isVertexAnim);

  // save skeletal animations
  if ( !isVertexAnim ) {
    if ( mesh->bones.size() > 0 ) SaveSKL(mesh, StripExt(meshfile) + ".skl.dat");
    if ( mesh->num_frames > 1 ) SaveANM(mesh, StripExt(meshfile) + ".anm.dat");
  }

  // save vertex animations
  if ( isVertexAnim ) {
    SaveVTA(mesh, StripExt(meshfile) + ".vta.dat");
  }
  
  // delete mesh from memory
  DeleteMesh(mesh);

  return 0;
}
