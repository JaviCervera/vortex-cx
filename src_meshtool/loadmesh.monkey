Strict

Private

Import brl.filepath
Import brl.filesystem
Import brl.process
Import mojo.app
Import vortex

Public

Function LoadMesh:Mesh(filename:String)
#If HOST="winnt"
	Local ext:String = ".exe"
#Else
	Local ext:String = ".bin"
#End
	Local path:String = CurrentDir() + "/data/meshtool" + ext
	If FileType(path) <> FILETYPE_FILE Then path = CurrentDir() + "/meshtool.data/meshtool" + ext
	Local command:String = path + " ~q" + filename + "~q"
	Local output:String = Process.Execute(command).Trim()
	Return Mesh.LoadString(output, "")
End