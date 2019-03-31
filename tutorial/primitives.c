#include "../src/vortex.h"

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
    
    /* Setup */
    InitVortex();
    OpenScreen(800, 600, FALSE, FALSE);
    
    /* Main loop */
    while (IsScreenOpened() && !IsKeyDown(KEY_ESC)) {
        /* Make changes visible on screen */
        RefreshScreen();
    }
    
    FinishVortex();
    return 0;
}
