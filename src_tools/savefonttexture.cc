#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"
#include "stringutils.h"
#include <iostream>
#include <stdlib.h>

using namespace std;

int main(int argc, char* argv[]) {
  // check command line
  if ( argc != 4 ) {
    cout << "Usage: savefonttexture fontfile fontsize texfile" << endl;
    return -1;
  }

  // get arguments
  string fontfile = argv[1];
  int fontsize = NumberFromString<int>(argv[2]);
  string texfile = argv[3];

  // read file
  FILE* handle = fopen(fontfile.c_str(), "rb");
  if ( !handle ) {
    cout << "Error: fontfile does not exist" << endl;
    return -1;
  }
  fseek(handle, 0, SEEK_END);
  long size = ftell(handle);
  fseek(handle, 0, SEEK_SET);
  unsigned char* buf = (unsigned char*)malloc(size);
  fread(buf, sizeof(unsigned char), size, handle);
  fclose(handle);

  // bake font into temp alpha buffer
  stbtt_bakedchar charData[224];
  bool imgPacked = false;
  int imgsize = 32;
  unsigned char* alphaBuffer = NULL;
  while ( !imgPacked ) {
    alphaBuffer = (unsigned char*)malloc(imgsize * imgsize);
    if ( stbtt_BakeFontBitmap(buf, 0, fontsize, alphaBuffer, imgsize, imgsize, 32, 224, charData) > 0 ) {
      imgPacked = true;
    } else {
      free(alphaBuffer);
      imgsize *= 2;
    }
  }
  free(buf);

  // copy alpha buffer into color buffer
  unsigned char* colorBuffer = (unsigned char*)malloc(imgsize * imgsize * 4);
  for ( int i = 0; i < imgsize*imgsize; i++ ) {
    colorBuffer[i*4 + 0] = 255;
    colorBuffer[i*4 + 1] = 255;
    colorBuffer[i*4 + 2] = 255;
    colorBuffer[i*4 + 3] = alphaBuffer[i];
  }
  free(alphaBuffer);

  // write image
  stbi_write_png(texfile.c_str(), imgsize, imgsize, 4, colorBuffer, 0);
  free(colorBuffer);

  return 0;
}
