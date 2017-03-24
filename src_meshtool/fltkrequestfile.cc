#include <FL/Fl.H>
#include <FL/Fl_File_Chooser.H>

int main(int argc, char* argv[]) {
  // get args
  if ( argc != 5 ) {
    printf("Usage: fltkrequestfile title filters save file");
    return -1;
  }
  const char* title = argv[1];
  const char* filter = argv[2];
  bool save = strcmp(argv[3], "true") == 0 ? true : false;
  const char* file = strcmp(argv[4], "") != 0 ? argv[4] : ".";

  // create file chooser
  int type = save ? (Fl_File_Chooser::SINGLE | Fl_File_Chooser::CREATE) : Fl_File_Chooser::SINGLE;
  Fl_File_Chooser chooser(file, filter, type, title);

  // show
  chooser.show();
  while( chooser.shown() ) { Fl::wait(); }

  // print selected file
  printf("%s\n", chooser.value() ? chooser.value() : "");
}
