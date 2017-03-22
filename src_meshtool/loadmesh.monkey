Strict

Private

Import brl.filesystem
Import brl.process
Import vortex

Public

Function LoadMesh:Mesh(filename:String)
	Local path:String = CurrentDir() + "/data/meshtool.bin"
	If FileType(path) <> FILETYPE_FILE Then path = CurrentDir() + "/meshtool.data/meshtool.bin"
	Print Process.Execute(path + " ~q" + filename + "~q")
	Return Null
End