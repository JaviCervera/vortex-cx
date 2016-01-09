'NOTE: Should be built using the stdcpp target

Strict

Import os

Function Main:Int()
	'Move out of the build dir
	ChangeDir("../..")
	If FileType("std_vertex.glsl") = FILETYPE_NONE Then ChangeDir("../..")
	Print CurrentDir()
	
	Local std_vertex:String = LoadString("std_vertex.glsl").Replace("~t", " ").Replace("~r~n", "~n").Replace("~r", "~n").Replace("~n", "~~n")
	Local std_fragment:String = LoadString("std_fragment.glsl").Replace("~t", " ").Replace("~r~n", "~n").Replace("~r", "~n").Replace("~n", "~~n")
	Local _2d_vertex:String = LoadString("2d_vertex.glsl").Replace("~t", " ").Replace("~r~n", "~n").Replace("~r", "~n").Replace("~n", "~~n")
	Local _2d_fragment:String = LoadString("2d_fragment.glsl").Replace("~t", " ").Replace("~r~n", "~n").Replace("~r", "~n").Replace("~n", "~~n")

	Local finalStr:String = "Strict~n~n"
	finalStr += "Const STD_VERTEX_SHADER:String = ~q" + std_vertex + "~q~n"
	finalStr += "Const STD_FRAGMENT_SHADER:String = ~q" + std_fragment + "~q~n"
	finalStr += "Const _2D_VERTEX_SHADER:String = ~q" + _2d_vertex + "~q~n"
	finalStr += "Const _2D_FRAGMENT_SHADER:String = ~q" + _2d_fragment + "~q~n"

	If FileType("../src/renderer_gles20_shaders.monkey") = FILETYPE_FILE Then DeleteFile("../src/renderer_gles20_shaders.monkey")
	SaveString(finalStr, "../src/renderer_gles20_shaders.monkey")

	Return 0
End
