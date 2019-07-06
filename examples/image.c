#include "../src/vortex.h"
#include <stdio.h>

int main() {
    /* Data */
    struct Texture* image;
    float angle = 0;
    char str[32];
    
    /* Setup */
    InitVortex();
    OpenScreen(800, 600, FALSE, FALSE);

    /* Load image */
    image = LoadTexture("data/smile.png");
    
    /* Main loop */
    while (IsScreenOpened() && !IsKeyDown(KEY_ESC)) {
        /* Increase angle */
        angle += 32 * GetDeltaTime();

        /* Draw image */
        Setup2D();
        ClearScreen(COLOR_BLACK);
        DrawTextureRot(image, GetScreenWidth()/2, GetScreenHeight()/2, angle);

        /* Draw FPS */
        sprintf(str, "%i FPS", GetScreenFPS());
        DrawText(str, 2, 2);

        /* Make changes visible on screen */
        RefreshScreen();
    }
    
    FinishVortex();
    return 0;
}
