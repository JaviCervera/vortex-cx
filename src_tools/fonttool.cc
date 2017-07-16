#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"
#include "stringutils.h"
#include <iostream>
#include <stdlib.h>

using namespace std;

int main(int argc, char* argv[]) {
  // check command line
  if ( argc != 3 ) {
    cout << "Usage: fonttool fontfile fontsize" << endl;
    return -1;
  }

  // get arguments
  string fontfile = argv[1];
  int fontsize = NumberFromString<int>(argv[2]);

  // read file
  FILE* handle = fopen(fontfile.c_str(), "rb");
  if ( !handle ) {
    cout << "Error: Could not load file '" << fontfile << "'" << endl;
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

  // gen xml
  string fnt = "<font>\n";
  //fnt += "\t<image>" + StripPath(pngfile) + "</image>\n";
  fnt += "\t<alphas>";
  for ( int i = 0; i < imgsize*imgsize; ++i ) {
    fnt += StringFromNumber((int)alphaBuffer[i]);
    if ( i < imgsize*imgsize - 1) fnt += ",";
  }
  fnt += "</alphas>\n";
  fnt += "\t<buffer_width>" + StringFromNumber(imgsize) + "</buffer_width>\n";
  fnt += "\t<font_size>" + StringFromNumber(fontsize) + "</font_size>\n";
  fnt += "\t<glyphs>\n";
  for ( unsigned int i = 0; i < 224; i++ ) {
    float width = charData[i].x1 - charData[i].x0;
    float height = charData[i].y1 - charData[i].y0;
    float x = charData[i].x0;
    float y = charData[i].y0; //imgsize - charData[i].y0 - height;
    //float xoffset = charData[i].xoff;
    float yoffset = height + charData[i].yoff;
    fnt += "\t\t<glyph ";
    fnt += "x=\"" + StringFromNumber(x) + "\" ";
    fnt += "y=\"" + StringFromNumber(y) + "\" ";
    fnt += "width=\"" + StringFromNumber(width) + "\" ";
    fnt += "height=\"" + StringFromNumber(height) + "\" ";
    //fnt += "xoffset=\"" + StringFromNumber(xoffset) + "\" ";
    fnt += "yoffset=\"" + StringFromNumber(yoffset) + "\" ";
    fnt += "/>\n";
  }
  fnt += "\t</glyphs>\n";
  fnt += "</font>";
  cout << fnt << endl;
  //WriteString(fnt, StripExt(fontfile) + "_" + StringFromNumber(fontsize) + ".fnt.xml", false);
  
  free(alphaBuffer);

  return 0;
}
