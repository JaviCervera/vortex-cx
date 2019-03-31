#include <algorithm>
#include <fstream>
#include <sstream>
#include <vector>

inline std::string string_read(const std::string& filename)
{
  std::ifstream istream(filename.c_str(), std::ios_base::binary);
  std::stringstream sstream;
  sstream << istream.rdbuf();
  return sstream.str();
}

inline void string_write(const std::string& str, const std::string& filename, bool append = true)
{
  std::ofstream ostream(filename.c_str(), std::ios_base::binary | (append ? std::ios_base::app : std::ios_base::trunc));
  ostream << str;
  ostream.close();
}

inline std::vector<std::string> string_split(const std::string& str, char delim)
{
  std::vector<std::string> elems;
  std::stringstream sstream(str);
  std::string item;
  if (str != "")
  {
    while (std::getline(sstream, item, delim))
    {
      elems.push_back(item);
    }
  }
  return elems;
}

inline std::string string_replace(const std::string& str, const std::string& find, const std::string& rep)
{
  std::string strcopy = str;
  while ( strcopy.find(find) != std::string::npos )
  {
    strcopy.replace(strcopy.find(find), find.length(), rep);
  }
  return strcopy;
}

int main(int, char**)
{
  // read file and normalize line ends
  std::string file = string_read("inputcodes.txt");
  file = string_replace(file, "\r\n", "\n");
  file = string_replace(file, "\r", "\n");
  
  // get lines
  std::vector<std::string> lines = string_split(file, '\n');
  
  // create output strings
  std::string out;

  // write out main function
  out += "#include \"../lib/allegro/include/allegro5/keycodes.h\"\n";
  out += "#include <cstdio>\n";
  out += "#include <fstream>\n\n";
  out += "int main(int, char**)\n{\n";
  out += "\tstd::string out;\n";
  out += "\tchar msg[128];\n";
  
  // export lines
  for ( std::vector<std::string>::const_iterator it = lines.begin();
        it != lines.end();
        ++it )
  {
    const std::string& line = *it;
    if ( line == "" ) continue;
    std::string outname = string_replace(line, "ALLEGRO_KEY_", "KEY_");
    outname = string_replace(outname, "_ESCAPE", "_ESC");
    std::transform(outname.begin(), outname.end(), outname.begin(), ::toupper);
    
    out += "\tsprintf(msg, \"#define " + outname + " %i\\n\", " + line + "); out += msg;\n";
  }

  // close main function
  out += "\tstd::ofstream fs(\"inputcodes_out.txt\", std::ios_base::binary | std::ios_base::trunc);\n";
  out += "\tfs << out;\n";
  out += "\tfs.close();\n";
  out += "}\n";
  
  // save files
  string_write(out, "gen_inputcodes2.cc", false);
}

