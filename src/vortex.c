#include "platform.h"
#include "screen.h"
#include "vortex_config.h"
#define LITE_ASSBIN_USE_GFX
#define LITE_MD2_USE_GFX
#define LITE_ASSBIN_IMPLEMENTATION
#include "../lib/litelibs/liteassbin.h"
#undef LITE_ASSBIN_IMPLEMENTATION
#define LITE_COL_IMPLEMENTATION
#include "../lib/litelibs/litecol.h"
#undef LITE_COL_IMPLEMENTATION
#define LITE_GFX_IMPLEMENTATION
#include "../lib/litelibs/litegfx.h"
#undef LITE_GFX_IMPLEMENTATION
#define LITE_MATH3D_IMPLEMENTATION
#include "../lib/litelibs/litemath3d.h"
#undef LITE_MATH3D_IMPLEMENTATION
#define LITE_MD2_IMPLEMENTATION
#include "../lib/litelibs/litemd2.h"
#undef LITE_MD2_IMPLEMENTATION
#define STB_IMAGE_IMPLEMENTATION
#include "../lib/stb/stb_image.h"
#undef STB_IMAGE_IMPLEMENTATION
#define STB_TRUETYPE_IMPLEMENTATION
#include "../lib/stb/stb_truetype.h"
#undef STB_TRUETYPE_IMPLEMENTATION
#include "../lib/stb/stb_vorbis.c"

EXPORT bool_t CALL InitVortex()
{
    bool_t ret;
    ret = p_Init();
    if (!ret) return FALSE;
    /*ret = InitAudio();*/
    return ret != FALSE;
}

EXPORT void CALL FinishVortex()
{
    CloseScreen();
    /*FinishAudio();*/
    p_Shutdown();
}
