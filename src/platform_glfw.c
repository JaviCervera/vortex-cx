#include "vortex_config.h"

#ifdef USE_GLFW

#include "../lib/glfw/include/GLFW/glfw3.h"
#include "../lib/tinyfiledialogs/tinyfiledialogs.h"
#include "platform.h"
#include "util.h"
#include <math.h>

bool_t p_Init() {
  return glfwInit();
}

void p_Shutdown() {
  glfwTerminate();
}

float p_GetTime() {
  return (float)glfwGetTime();
}

void p_SetCursorVisible(void* win, bool_t visible) {
  glfwSetInputMode((GLFWwindow*)win, GLFW_CURSOR, visible ? GLFW_CURSOR_NORMAL : GLFW_CURSOR_HIDDEN);
}

void p_SetCursorPosition(void* win, int x, int y) {
  glfwSetCursorPos((GLFWwindow*)win, x, y);
}

int p_GetCursorX(void* win) {
  double x;
  glfwGetCursorPos((GLFWwindow*)win, &x, NULL);
  return (int)floor(x);
}

int p_GetCursorY(void* win) {
  double y;
  glfwGetCursorPos((GLFWwindow*)win, NULL, &y);
  return (int)floor(y);
}

bool_t p_IsMouseButtonDown(void* win, int button) {
  return glfwGetMouseButton((GLFWwindow*)win, button) == GLFW_PRESS;
}

bool_t p_IsKeyDown(void* win, int key) {
  return glfwGetKey((GLFWwindow*)win, key) == GLFW_PRESS;
}

int p_GetDesktopWidth() {
  return glfwGetVideoMode(glfwGetPrimaryMonitor())->width;
}

int p_GetDesktopHeight() {
  return glfwGetVideoMode(glfwGetPrimaryMonitor())->height;
}

void* p_OpenScreen(int width, int height, bool_t fullscreen, int samples, bool_t vsync, bool_t resizable) {
  GLFWwindow* win;

  /* set flags */
  glfwWindowHint(GLFW_SAMPLES, samples);
  glfwWindowHint(GLFW_RESIZABLE, resizable);
#ifdef USE_RETINA
  glfwWindowHint(GLFW_COCOA_RETINA_FRAMEBUFFER, GLFW_TRUE);
#else
  glfwWindowHint(GLFW_COCOA_RETINA_FRAMEBUFFER, GLFW_FALSE);
#endif

  /* create window */
  win = glfwCreateWindow(width, height, "", fullscreen ? glfwGetPrimaryMonitor() : NULL, NULL);
  glfwMakeContextCurrent(win);

  /* set vsync */
  glfwSwapInterval(vsync ? 1 : 0);

  return win;
}

void p_CloseScreen(void* win) {
  glfwDestroyWindow((GLFWwindow*)win);
}

bool_t p_IsScreenOpened(void* win) {
  return win && !glfwWindowShouldClose((GLFWwindow*)win);
}

void p_RefreshScreen(void* win) {
  glfwSwapBuffers((GLFWwindow*)win);
  glfwPollEvents();
}

void p_SetScreenTitle(void* win, const char* title) {
  glfwSetWindowTitle((GLFWwindow*)win, title);
}

int p_GetScreenWidth(void* win) {
  int w;
#ifdef USE_RETINA
  glfwGetFramebufferSize((GLFWwindow*)win, &w, NULL);
#else
  glfwGetWindowSize((GLFWwindow*)win, &w, NULL);
#endif
  return w;
}

int p_GetScreenHeight(void* win) {
  int h;
#ifdef USE_RETINA
  glfwGetFramebufferSize((GLFWwindow*)win, NULL, &h);
#else
  glfwGetWindowSize((GLFWwindow*)win, NULL, &h);
#endif
  return h;
}

void p_MessageBox(const char* title, const char* message) {
#ifdef USE_TINYFILEDIALOGS
  tinyfd_messageBox(title, message, "ok", "info", 0);
#else
  printf("[%s] %s\n", title, message);
#endif
}

#endif /* USE_GLFW */
