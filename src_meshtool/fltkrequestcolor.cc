#include <FL/Fl.H>
#include <FL/Fl_Color_Chooser.H>
#include "stringutils.h"

int main(int argc, char* argv[]) {
  // get args
  if ( argc != 5 ) {
    printf("Usage: fltkrequestcolor title r g b\n");
    return -1;
  }
  const char* title = argv[1];
  double r = NumberFromString<double>(argv[2]);
  double g = NumberFromString<double>(argv[3]);
  double b = NumberFromString<double>(argv[4]);

  // create file chooser
  if ( fl_color_chooser(title, r, g, b) ) {
    printf("%f %f %f\n", static_cast<float>(r), static_cast<float>(g), static_cast<float>(b));
  } else {
    printf("\n");
  }
}
