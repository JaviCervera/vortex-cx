'NOTE: Should be built using the stdcpp or glfw targets

Strict

Import os

Function Main:Int()
	'Move out of the build dir
	ChangeDir("../..")
	If FileType("std_vertex.glsl") = FILETYPE_NONE Then ChangeDir("../..")
	If FileType("std_vertex.glsl") = FILETYPE_NONE Then ChangeDir("../../../..")
	Print CurrentDir()
	
	Local std_vertex:String[] = LoadString("std_vertex.glsl").Replace("~t", " ").Replace("~r~n", "~n").Replace("~r", "~n").Split("~n")
	Local std_fragment:String[] = LoadString("std_fragment.glsl").Replace("~t", " ").Replace("~r~n", "~n").Replace("~r", "~n").Split("~n")
	Local _2d_vertex:String[] = LoadString("2d_vertex.glsl").Replace("~t", " ").Replace("~r~n", "~n").Replace("~r", "~n").Split("~n")
	Local _2d_fragment:String[] = LoadString("2d_fragment.glsl").Replace("~t", " ").Replace("~r~n", "~n").Replace("~r", "~n").Split("~n")

	Local finalStr:String = "Strict~n~n"
	finalStr += "Const STD_VERTEX_SHADER:String = ~q~q +~n"
	For Local line:String = Eachin std_vertex
		finalStr += "~q" + line + "~~n~q +~n"
	Next
	finalStr += "~q~q~n"
	finalStr += "Const STD_FRAGMENT_SHADER:String = ~q~q +~n"
	For Local line:String = Eachin std_fragment
		finalStr += "~q" + line + "~~n~q +~n"
	Next
	finalStr += "~q~q~n"
	finalStr += "Const _2D_VERTEX_SHADER:String = ~q~q +~n"
	For Local line:String = Eachin _2d_vertex
		finalStr += "~q" + line + "~~n~q +~n"
	Next
	finalStr += "~q~q~n"
	finalStr += "Const _2D_FRAGMENT_SHADER:String = ~q~q +~n"
	For Local line:String = Eachin _2d_fragment
		finalStr += "~q" + line + "~~n~q +~n"
	Next
	finalStr += "~q~q~n"

	If FileType("../src/renderer_gles20_shaders.monkey") = FILETYPE_FILE Then DeleteFile("../src/renderer_gles20_shaders.monkey")
	SaveString(finalStr, "../src/renderer_gles20_shaders.monkey")

	Return 0
End
