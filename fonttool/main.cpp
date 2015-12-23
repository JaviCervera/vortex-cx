#include "stb_truetype.h"
#include "stb_image_write.h"
#include "../meshtool/stringutils.h"
#include <iostream>
#include <stdlib.h>

using namespace std;

int main(int argc, char* argv[]) {
  // Check command line
    if ( argc != 3 ) {
        cout << "Usage: fonttool fontfile fontsize" << endl;
    return -1;
  }

  // Get arguments
  string fontfile = argv[1];
  int fontsize = NumberFromString<int>(argv[2]);

  // Read file
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

  // Bake font into temp alpha buffer
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

  // Copy alpha buffer into color buffer
  unsigned char* colorBuffer = (unsigned char*)malloc(imgsize * imgsize * 4);
  for ( int i = 0; i < imgsize*imgsize; i++ ) {
    colorBuffer[i*4 + 0] = 255;
    colorBuffer[i*4 + 1] = 255;
    colorBuffer[i*4 + 2] = 255;
    colorBuffer[i*4 + 3] = alphaBuffer[i];
  }
  free(alphaBuffer);

  // Write image
  string pngfile = StripExt(fontfile) + "_" + StringFromNumber(fontsize) + ".png";
  stbi_write_png(pngfile.c_str(), imgsize, imgsize, 4, colorBuffer, 0);
  free(colorBuffer);

  // Write glyphs
  string fnt = "<font>\n";
  fnt += "\t<image>" + StripPath(pngfile) + "</image>\n";
  fnt += "\t<height>" + StringFromNumber(fontsize) + "</height>\n";
  fnt += "\t<glyphs>\n";
  for ( unsigned int i = 0; i < 224; i++ ) {
    float width = charData[i].x1 - charData[i].x0;
    float height = charData[i].y1 - charData[i].y0;
    float x = charData[i].x0;
    float y = imgsize - charData[i].y0 - height;
    //float xoffset = charData[i].xoff;
    float yoffset = - (height + charData[i].yoff);
    fnt += "\t\t<glyph>\n";
    fnt += "\t\t\t<x>" + StringFromNumber(x) + "</x>\n";
    fnt += "\t\t\t<y>" + StringFromNumber(y) + "</y>\n";
    fnt += "\t\t\t<width>" + StringFromNumber(width) + "</width>\n";
    fnt += "\t\t\t<height>" + StringFromNumber(height) + "</height>\n";
    //fnt += "\t\t\t<xoffset>" + StringFromNumber(xoffset) + "</xoffset>\n";
    fnt += "\t\t\t<yoffset>" + StringFromNumber(yoffset) + "</yoffset>\n";
    fnt += "\t\t</glyph>\n";
  }
  fnt += "\t</glyphs>\n";
  fnt += "</font>\n";
  WriteString(fnt, StripExt(fontfile) + "_" + StringFromNumber(fontsize) + ".fnt.xml", false);

  return 0;
}
