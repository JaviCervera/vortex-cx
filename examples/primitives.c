#include "../src/vortex.h"
#include <stdio.h>

#define MAX_PRIMITIVES 1000

/* Types of primitives supported */
typedef enum {
    PRIM_POINT,
    PRIM_LINE,
    PRIM_RECT,
    PRIM_ELLIPSE
} PrimitiveType;

/* This containes the information of one primitive */
typedef struct {
    PrimitiveType type;
    int color;
    float x, y, w, h;
} Primitive;

int main() {
    /* Data */
    Primitive primitives[MAX_PRIMITIVES];
    size_t num_primitives = 0;
    int i;
    char str[32];
    
    /* Setup */
    InitVortex();
    OpenScreen(800, 600, FALSE, FALSE);
    
    /* Main loop */
    while (IsScreenOpened() && !IsKeyDown(KEY_ESC)) {
        /* Add new primitive if maximum has not been reach */
        if (num_primitives < MAX_PRIMITIVES) {
            primitives[num_primitives].type = rand() % 4;
            primitives[num_primitives].x = rand() % GetDesktopWidth();
            primitives[num_primitives].y = rand() % GetDesktopHeight();
            primitives[num_primitives].w = rand() % GetDesktopWidth();
            primitives[num_primitives].h = rand() % GetDesktopHeight();
            primitives[num_primitives].color = RGB(rand() % 256, rand() % 256, rand() % 256);
            ++num_primitives;
        }

        /* Draw primitives */
        Setup2D();
        ClearScreen(COLOR_BLACK);
        for (i = 0; i < num_primitives; ++i) {
            SetColor(primitives[i].color);
            switch (primitives[i].type) {
                case PRIM_POINT:
                    DrawPoint(primitives[i].x, primitives[i].y);
                    break;
                case PRIM_LINE:
                    DrawLine(primitives[i].x, primitives[i].y, primitives[i].w, primitives[i].h);
                    break;
                case PRIM_RECT:
                    DrawRect(primitives[i].x, primitives[i].y, primitives[i].w, primitives[i].h);
                    break;
                case PRIM_ELLIPSE:
                    DrawEllipse(primitives[i].x, primitives[i].y, primitives[i].w, primitives[i].h);
                    break;
            }
        }

        /* Draw FPS */
        SetColor(COLOR_WHITE);
        sprintf(str, "%i FPS", GetScreenFPS());
        DrawText(str, 2, 2);

        /* Make changes visible on screen */
        RefreshScreen();
    }
    
    FinishVortex();
    return 0;
}
