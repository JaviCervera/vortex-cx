//#include "tinyfiledialogs.h"

void Notify(String title, String text, bool serious) {
  tinyfd_messageBox(title.ToCString<char>(), text.ToCString<char>(), "ok", serious ? "error" : "info", 1);
}

String RequestFile(String title, String filters, bool save, String file) {
  const char* fname = NULL;
  if ( !save ) {
    fname = tinyfd_openFileDialog(title.ToCString<char>(), file.ToCString<char>(), 0, NULL, NULL, 0);
  } else {
    fname = tinyfd_openFileDialog(title.ToCString<char>(), file.ToCString<char>(), 0, NULL, NULL, 0);
  }
  
  if ( fname != NULL) {
    return fname;
  } else {
    return "";
  }
}

int RequestColor(String title, int color) {
  unsigned char c[3];
  c[0] = (color >> 16) & 0xFF;
  c[1] = (color >> 8) & 0xFF;
  c[2] = color & 0xFF;
  
  if ( tinyfd_colorChooser(title.ToCString<char>(), NULL, c, c) ) {
    color = (c[0] << 16) | (c[1] << 8) | c[2];
  }
  
  return color;
}
