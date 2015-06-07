SuperStrict

Local std_vertex$ = Replace(Replace(Replace(Replace(LoadString("std_vertex.glsl"), "~t", " "), "~r~n", "~n"), "~r", "~n"), "~n", "~~n")
Local std_fragment$ = Replace(Replace(Replace(Replace(LoadString("std_fragment.glsl"), "~t", " "), "~r~n", "~n"), "~r", "~n"), "~n", "~~n")
Local _2d_vertex$ = Replace(Replace(Replace(Replace(LoadString("2d_vertex.glsl"), "~t", " "), "~r~n", "~n"), "~r", "~n"), "~n", "~~n")
Local _2d_fragment$ = Replace(Replace(Replace(Replace(LoadString("2d_fragment.glsl"), "~t", " "), "~r~n", "~n"), "~r", "~n"), "~n", "~~n")

Local finalStr$ = "Strict~n~n"
finalStr :+ "Const STD_VERTEX_SHADER$ = ~q" + std_vertex + "~q~n"
finalStr :+ "Const STD_FRAGMENT_SHADER$ = ~q" + std_fragment + "~q~n"
finalStr :+ "Const _2D_VERTEX_SHADER$ = ~q" + _2d_vertex + "~q~n"
finalStr :+ "Const _2D_FRAGMENT_SHADER$ = ~q" + _2d_fragment + "~q~n"

If FileType("../vortex/core/renderer_gles20_shaders.monkey") = FILETYPE_FILE Then DeleteFile "../vortex/core/renderer_gles20_shaders.monkey"
SaveString(finalStr, "../vortex/core/renderer_gles20_shaders.monkey")
