#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"
#include "stringutils.h"
#include <fstream>
#include <iostream>
#include <vector>

#define FIRST_CHAR 32
#define NUM_CHARS 224

using namespace std;

int main(int argc, char* argv[]) {
  // check command line
  if (argc != 3) {
    cout << "Usage: fonttool fontfile fontsize" << endl;
    return -1;
  }

  // get arguments
  string fontfile = argv[1];
  int fontsize = NumberFromString<int>(argv[2]);

  // read file
  ifstream file(fontfile.c_str(), std::ios::binary | std::ios::ate);
  if (!file.is_open()) {
    cout << "Error: Could not load file '" << fontfile << "'" << endl;
    return -1;
  }
  std::vector<unsigned char> buf(file.tellg());
  file.seekg(0);
  file.read(reinterpret_cast<char*>(&buf[0]), buf.size());

  // bake font into temp alpha buffer
  stbtt_bakedchar charData[NUM_CHARS];
  int imgWidth = 128, imgHeight = 128;
  std::vector<unsigned char> alphaBuffer(imgWidth * imgHeight);
  while (stbtt_BakeFontBitmap(&buf[0], 0, fontsize, &alphaBuffer[0], imgWidth, imgHeight, FIRST_CHAR, NUM_CHARS, charData) <= 0) {
    if (imgWidth == imgHeight) imgWidth *= 2;
    else imgHeight *= 2;
    alphaBuffer.resize(imgWidth * imgHeight);
  }
  
  // copy alpha buffer into color buffer
  std::vector<unsigned char> colorBuffer(imgWidth * imgHeight * 4, 255);
  for (int i = 0; i < imgWidth*imgHeight; i++) {
    colorBuffer[i*4 + 3] = alphaBuffer[i];
  }
  
  // write image to a png file
  string texName = StripExt(fontfile) + "_" + StringFromNumber(fontsize) + ".png";
  stbi_write_png(texName.c_str(), imgWidth, imgHeight, 4, &colorBuffer[0], 0);

  // create fnt.dat file for glyph data
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
  int numGlyphs = NUM_CHARS;
  dat.write(reinterpret_cast<const char*>(&numGlyphs), sizeof(numGlyphs));

  // first char
  int firstChar = FIRST_CHAR;
  dat.write(reinterpret_cast<const char*>(&firstChar), sizeof(firstChar));

  // glyphs
  for (size_t i = 0; i < NUM_CHARS; ++i) {
    float px = 0, py = 0;
    stbtt_aligned_quad q;
    stbtt_GetBakedQuad(charData, imgWidth, imgHeight, i, &px, &py, &q, true);
    float x = q.s0 * imgWidth;
    float y = q.t0 * imgHeight;
    float width = q.x1 - q.x0;
    float height = q.y1 - q.y0;
    float xoffset = q.x0;
    float yoffset = q.y0;
    dat.write(reinterpret_cast<const char*>(&x), sizeof(x));
    dat.write(reinterpret_cast<const char*>(&y), sizeof(y));
    dat.write(reinterpret_cast<const char*>(&width), sizeof(width));
    dat.write(reinterpret_cast<const char*>(&height), sizeof(height));
    dat.write(reinterpret_cast<const char*>(&xoffset), sizeof(xoffset));
    dat.write(reinterpret_cast<const char*>(&yoffset), sizeof(yoffset));
  }

  return 0;
}
