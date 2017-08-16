//#include "tinyfiledialogs.h"

bool Confirm(String title, String text, bool serious) {
  return tinyfd_messageBox(title.ToCString<char>(), text.ToCString<char>(), "yesno", serious ? "error" : "question", 1) == 1;
}

void Notify(String title, String text, bool serious) {
  tinyfd_messageBox(title.ToCString<char>(), text.ToCString<char>(), "ok", serious ? "error" : "info", 0);
}

int Proceed(String title, String text, bool serious) {
  return tinyfd_messageBox(title.ToCString<char>(), text.ToCString<char>(), "yesnocancel", serious ? "error" : "question", 0);
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

String RequestDir(String title, String dir) {
  const char* selDir = tinyfd_selectFolderDialog(title.ToCString<char>(), dir.ToCString<char>());
  if ( selDir != NULL ) {
    return selDir;
  } else {
    return "";
  }
}

String RequestFile(String title, String filters, bool save, String file) {
  const char* fname = NULL;
  if ( !save ) {
    fname = tinyfd_openFileDialog(title.ToCString<char>(), file.ToCString<char>(), 0, NULL, NULL, 0);
  } else {
    fname = tinyfd_saveFileDialog(title.ToCString<char>(), file.ToCString<char>(), 0, NULL, NULL);
  }
  
  if ( fname != NULL) {
    return fname;
  } else {
    return "";
  }
}

String RequestInput(String title, String text, String def, bool password) {
  const char* input = tinyfd_inputBox(title.ToCString<char>(), text.ToCString<char>(), password ? (const char*)NULL : def.ToCString<char>());
  if ( input != NULL ) {
    return input;
  } else {
    return "";
  }
}
