#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"
#include "stringutils.h"
#include <fstream>
#include <iostream>
#include <vector>

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
  ifstream file(fontfile.c_str(), std::ios::binary | std::ios::ate);
  if ( !file.is_open() ) {
    cout << "Error: Could not load file '" << fontfile << "'" << endl;
    return -1;
  }
  std::vector<unsigned char> buf(file.tellg());
  file.seekg(0);
  file.read(reinterpret_cast<char*>(&buf[0]), buf.size());

  // bake font into temp alpha buffer
  stbtt_bakedchar charData[224];
  int imgWidth = 128, imgHeight = 128;
  std::vector<unsigned char> alphaBuffer(imgWidth * imgHeight);
  while ( stbtt_BakeFontBitmap(&buf[0], 0, fontsize, &alphaBuffer[0], imgWidth, imgHeight, 32, 224, charData) <= 0 ) {
    if ( imgWidth == imgHeight ) imgWidth *= 2;
    else imgHeight *= 2;
    alphaBuffer.resize(imgWidth * imgHeight);
  }
  
  // copy alpha buffer into color buffer
  std::vector<unsigned char> colorBuffer(imgWidth * imgHeight * 4, 255);
  for ( int i = 0; i < imgWidth*imgHeight; i++ ) {
    colorBuffer[i*4 + 3] = alphaBuffer[i];
  }
  
  // write image to a png file
  string texName = StripExt(fontfile) + "_" + StringFromNumber(fontsize) + ".png";
  stbi_write_png(texName.c_str(), imgWidth, imgHeight, 4, &colorBuffer[0], 0);

  // write glyph data to fnt.dat file
  ofstream dat((StripExt(fontfile) + "_" + StringFromNumber(fontsize) + ".fnt.dat").c_str(), std::ios::binary | std::ios::trunc);

  // id & version
  string id = "FN01";
  dat.write(id.c_str(), id.size());

  // texture name
  texName = StripPath(texName);
  int texLen = static_cast<int>(texName.size());
  dat.write(reinterpret_cast<const char*>(&texLen), sizeof(texLen));
  dat.write(reinterpret_cast<const char*>(texName.c_str()), texLen);

  // font height
  unsigned short fontHeight = static_cast<unsigned short>(fontsize);
  dat.write(reinterpret_cast<const char*>(&fontHeight), sizeof(fontHeight));

  // num glyphs
  int numGlyphs = 224;
  dat.write(reinterpret_cast<const char*>(&numGlyphs), sizeof(numGlyphs));

  // first char
  int firstChar = 32;
  dat.write(reinterpret_cast<const char*>(&firstChar), sizeof(firstChar));

  // glyphs
  for ( size_t i = 0; i < numGlyphs; ++i ) {
    float x = charData[i].x0;
    float y = charData[i].y0;
    float width = charData[i].x1 - charData[i].x0;
    float height = charData[i].y1 - charData[i].y0;
    float xoffset = charData[i].xoff;
    float yoffset = height + charData[i].yoff;
    dat.write(reinterpret_cast<const char*>(&x), sizeof(x));
    dat.write(reinterpret_cast<const char*>(&y), sizeof(y));
    dat.write(reinterpret_cast<const char*>(&width), sizeof(width));
    dat.write(reinterpret_cast<const char*>(&height), sizeof(height));
    dat.write(reinterpret_cast<const char*>(&xoffset), sizeof(xoffset));
    dat.write(reinterpret_cast<const char*>(&yoffset), sizeof(yoffset));
  }

  return 0;
}
