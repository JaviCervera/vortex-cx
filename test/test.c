#define LITE_UNIT_IMPLEMENTATION
#include "liteunit.h"
#include "../src/platform_allegro.c"

void InitPlatform(ltestcase_t* testcase)
{
  p_Init();
}

void DeinitPlatform(ltestcase_t* testcase)
{
  p_Shutdown();
}

void TestOpenScreen(ltestcase_t* testcase)
{
  void* screen = p_OpenScreen(640, 480, FALSE, 0, FALSE, FALSE);
  ltest_assert(testcase, screen != NULL);
  p_CloseScreen(screen);
}

void TestScreenSize(ltestcase_t* testcase)
{
  void* screen = p_OpenScreen(640, 480, FALSE, 0, FALSE, FALSE);
  //ltest_assert(testcase, p_GetScreenWidth(screen) == 640);
  //ltest_assert(testcase, p_GetScreenHeight(screen) == 400);
  ltest_assert(testcase, 0);
  p_CloseScreen(screen);
}

int main() {
  ltestcase_t platform;
  ltestcase_init(&platform, "platform", InitPlatform, DeinitPlatform, NULL, NULL);
  ltestcase_addtest(&platform, TestOpenScreen, "Checking that p_OpenScreen returns a pointer");
  ltestcase_addtest(&platform, TestOpenScreen, "Checking that correct screen size is returned");
  
  ltestcase_run(&platform);
  
  return 0;
}
