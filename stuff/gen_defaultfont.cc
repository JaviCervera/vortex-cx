#include "../lib/base64/base64.h"
#include <fstream>
#include <string>
#include <vector>

int main(int, char**)
{
  // read font file
  std::ifstream ifs("LiberationMono-Regular.ttf", std::ios_base::ate | std::ios_base::binary);
  if ( !ifs.is_open() ) return -1;
  std::vector<unsigned char> data(ifs.tellg());
  ifs.seekg(0);
  ifs.read(reinterpret_cast<char*>(&data[0]), data.size());
  ifs.close();

  // base64 encode
  size_t encoded_size = BASE64_ENCODE_OUT_SIZE(data.size());
  char* encoded = new char[encoded_size + 1];
  encoded[encoded_size] = 0;
  base64_encode(&data[0], data.size(), encoded);
  
  // write output
  std::ofstream fs("../src/default_font.h", std::ios_base::binary | std::ios_base::trunc);
  fs << "#define DEFAULT_FONT \"" << encoded << "\"\n";
  fs << "#define DEFAULT_FONT_BLOCKSIZE " << encoded_size << "\n";
  fs.close();

  delete[] encoded;
}

