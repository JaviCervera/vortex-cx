#define LITE_UNIT_IMPLEMENTATION
#include "../lib/litelibs/liteunit.h"
#include "../src/vortex.h"

void TestOpenScreen(ltestcase_t* testcase) {
    bool_t opened = OpenScreen(640, 480, FALSE, FALSE);
    ltest_assert(testcase, opened);
    ltest_assert(testcase, IsScreenOpened());
    CloseScreen();
}

void TestScreenSize(ltestcase_t* testcase) {
    OpenScreen(640, 480, FALSE, FALSE);
    ltest_assert(testcase, GetScreenWidth() == 640);
    ltest_assert(testcase, GetScreenHeight() == 480);
    CloseScreen();
}

void TestDesktop(ltestcase_t* testcase) {
    ltest_assert(testcase, GetDesktopWidth() > 0);
    ltest_assert(testcase, GetDesktopHeight() > 0);
}

int main() {
    ltestcase_t screen;
    
    InitVortex();
    
    ltestcase_init(&screen, "screen", NULL, NULL, NULL, NULL);
    ltestcase_addtest(&screen, TestOpenScreen, "Checking that OpenScreen works");
    ltestcase_addtest(&screen, TestScreenSize, "Checking that correct screen size is returned");
    ltestcase_addtest(&screen, TestDesktop, "Checking that desktop size can be obtained");
    
    ltestcase_run(&screen);
    
    FinishVortex();
    
    return 0;
}
