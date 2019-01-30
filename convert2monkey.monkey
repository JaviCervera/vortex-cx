'NOTE: Should be built using the stdcpp or glfw targets
'This program automatically makes the needed modifications on Vortex so it can be used on Monkey-X

Strict

Import os

Function Main:Int()
	'Move to the root dir
	ChangeDir("../..")
	If FileType("vortex.cerberusdoc") = FILETYPE_NONE And FileType("vortex.monkeydoc") = FILETYPE_NONE Then ChangeDir("../..")
	If FileType("vortex.cerberusdoc") = FILETYPE_NONE And FileType("vortex.monkeydoc") = FILETYPE_NONE Then ChangeDir("../../../..")
	Print CurrentDir()
	
	'Rename doc file
	CopyFile("vortex.cerberusdoc", "vortex.monkeydoc")
	
	'Convert root dir
	ConvertDir(".")
	
	'Convert src dir
	ConvertDir("src")
	
	'Convert src_tools dir
	ConvertDir("src_tools")
	
	'Convert tests dir
	ConvertDir("tests")
	
	'Convert demos dir
	ConvertDir("demos")
	
	Return 0
End

Function ConvertDir:Void(path:String)
	Local prevPath:String = CurrentDir()
	ChangeDir(path)
	Local files:String[] = LoadDir(CurrentDir())
	For Local file:String = Eachin files
		If ExtractExt(file).ToLower() = "cxs"
			Local contents:String = LoadString(file).Replace("cerberus://data/", "monkey://data/").Replace("Import cerberus.", "Import monkey.")
			SaveString(contents, StripExt(file) + ".monkey")
		End
	Next
	ChangeDir(prevPath)
End
