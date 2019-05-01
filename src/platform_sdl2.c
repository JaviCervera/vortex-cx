#include "vortex_config.h"

#ifdef USE_SDL2

#include "../lib/sdl2/include/SDL.h"
#include "platform.h"
#include "util.h"

typedef struct {
    SDL_Window* window;
    SDL_GLContext context;
    bool_t closePressed;
} SDLData;

bool_t p_Init() {
    /*SDL_SetMainReady();*/
    return SDL_Init(SDL_INIT_AUDIO | SDL_INIT_EVENTS | SDL_INIT_TIMER | SDL_INIT_VIDEO ) == 0;
}

void p_Shutdown() {
    SDL_Quit();
}

float p_GetTime() {
    return SDL_GetTicks() / 1000.0f;
}

void p_SetCursorVisible(void* win, bool_t visible) {
    SDL_ShowCursor(visible);
}

void p_SetCursorPosition(void* win, int x, int y) {
    SDL_WarpMouseInWindow(((SDLData*)win)->window, x, y);
}

int p_GetCursorX(void* win) {
    int x;
    SDL_GetMouseState(&x, NULL);
    return x;
}

int p_GetCursorY(void* win) {
    int y;
    SDL_GetMouseState(NULL, &y);
    return y;
}

bool_t p_IsMouseButtonDown(void* win, int button) {
    if (button == 0) return SDL_GetMouseState(NULL, NULL) & SDL_BUTTON(1);
    else if (button == 1) return SDL_GetMouseState(NULL, NULL) & SDL_BUTTON(3);
    else if (button == 2) return SDL_GetMouseState(NULL, NULL) & SDL_BUTTON(2);
    else return 0;
}

bool_t p_IsKeyDown(void* win, int key) {
    return (bool_t)SDL_GetKeyboardState(NULL)[SDL_GetScancodeFromKey(key)];
}

int p_GetDesktopWidth() {
    SDL_DisplayMode mode;
    SDL_GetDesktopDisplayMode(0, &mode);
    return mode.w;
}

int p_GetDesktopHeight() {
    SDL_DisplayMode mode;
    SDL_GetDesktopDisplayMode(0, &mode);
    return mode.h;
}

void* p_OpenScreen(int width, int height, bool_t fullscreen, int samples, bool_t vsync, bool_t resizable) {
    Uint32 flags;
    SDLData* win;

    /* Gl attributes */
    SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 16);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, (samples > 0) ? 1 : 0);
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, samples);

    /* Flags */
    flags = SDL_WINDOW_OPENGL;
    if (fullscreen) flags |= SDL_WINDOW_FULLSCREEN;
    if (resizable) flags |= SDL_WINDOW_RESIZABLE;

    /* create window object */
    win = Alloc(SDLData);
    win->closePressed = FALSE;
    win->window = SDL_CreateWindow("", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, flags);
    win->context = SDL_GL_CreateContext(win->window);
    SDL_GL_MakeCurrent(win->window, win->context);

    /* set vsync */
    SDL_GL_SetSwapInterval(vsync);

    return win;
}

void p_CloseScreen(void* win) {
    SDLData* pwin;
    pwin = (SDLData*)win;
    SDL_GL_DeleteContext(pwin->context);
    SDL_DestroyWindow(pwin->window);
    free(pwin);
}

bool_t p_IsScreenOpened(void* win) {
    return win && !((SDLData*)win)->closePressed;
}

void p_RefreshScreen(void* win) {
    SDLData* pwin;
    SDL_Event event;

    pwin = (SDLData*)win;

    /* Poll events */
    while (SDL_PollEvent(&event)) {
        switch (event.type) {
        case SDL_WINDOWEVENT:
            if (event.window.event == SDL_WINDOWEVENT_CLOSE) pwin->closePressed = TRUE;
            break;
        case SDL_QUIT:
            break;
        }
    }

    /* Refresh screen */
    SDL_GL_SwapWindow(pwin->window);
}

void p_SetScreenTitle(void* win, const char* title) {
    SDL_SetWindowTitle(((SDLData*)win)->window, title);
}

int p_GetScreenWidth(void* win) {
    int w;
    SDL_GetWindowSize(((SDLData*)win)->window, &w, NULL);
    return w;
}

int p_GetScreenHeight(void* win) {
    int h;
    SDL_GetWindowSize(((SDLData*)win)->window, NULL, &h);
    return h;
}

void p_MessageBox(const char* title, const char* message) {
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, title, message, NULL);
}

#endif /* USE_SDL2 */
