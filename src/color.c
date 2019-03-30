#include "color.h"
#include "util.h"

int RGB(int r, int g, int b) {
    r = Clamp(r, 0, 255);
    g = Clamp(g, 0, 255);
    b = Clamp(b, 0, 255);
    return 0xff000000 | (r << 16) | (g << 8) | b;
}

int RGBA(int r, int g, int b, int a) {
    r = Clamp(r, 0, 255);
    g = Clamp(g, 0, 255);
    b = Clamp(b, 0, 255);
    a = Clamp(a, 0, 255);
    return (a << 24) | (r << 16) | (g << 8) | b;
}

int Red(int color) {
    return (color >> 16) & 0xff;
}

int Green(int color) {
    return (color >> 8) & 0xff;
}

int Blue(int color) {
    return color & 0xff;
}

int Alpha(int color) {
    return (color >> 24) & 0xff;
}

int ChangeAlpha(int color, int new_alpha) {
    new_alpha = Clamp(new_alpha, 0, 255);
    return (new_alpha << 24) | (color & 0x00ffffff);
}

int MultiplyColor(int color, float factor) {
    return RGBA(
        (int)(Red(color) * factor),
        (int)(Green(color) * factor),
        (int)(Blue(color) * factor),
        Alpha(color)
    );
}
