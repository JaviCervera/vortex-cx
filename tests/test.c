#define LITE_UNIT_IMPLEMENTATION
#include "../lib/litelibs/liteunit.h"
#include "../src/vortex.h"
#include "../src/vortex_config.h"

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

void TestPak(ltestcase_t* testcase) {
#ifdef USE_PAK
    char msg[1024];
    memset(msg, 0, 1024);
    ltest_assert(testcase, AddPak("test.pak") == TRUE);
    ltest_assert(testcase, IsFileInPak("hello.txt") == TRUE);
    ltest_assert(testcase, GetFileSize("hello.txt") == 13);
    GetFileContents("hello.txt", msg);
    ltest_assert(testcase, strcmp(msg, "Hello, world!") == 0);
#endif
}

int main() {
    ltestcase_t screen;
    ltestcase_t file_manager;
    
    InitVortex();
    
    ltestcase_init(&screen, "screen", NULL, NULL, NULL, NULL);
    ltestcase_addtest(&screen, TestOpenScreen, "Checking that OpenScreen works");
    ltestcase_addtest(&screen, TestScreenSize, "Checking that correct screen size is returned");
    ltestcase_addtest(&screen, TestDesktop, "Checking that desktop size can be obtained");

    ltestcase_init(&file_manager, "file_manager", NULL, NULL, NULL, NULL);
    ltestcase_addtest(&file_manager, TestPak, "Checking that Pak support works");
    
    ltestcase_run(&screen);
    ltestcase_run(&file_manager);
    
    FinishVortex();
    
    return 0;
}
