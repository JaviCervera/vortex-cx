Strict

Private

Import brl.filepath
Import brl.filesystem
Import brl.process
Import mojo.app
Import vortex

Public

Function LoadMesh:Mesh(filename:String)
	'Directly load native XML meshes
	If ExtractExt(filename).ToLower() = "xml" Then Return Mesh.Load(filename)

	'Use external tool to load other mesh formats
#If HOST="winnt"
	Local ext:String = ".exe"
#Else
	Local ext:String = ".bin"
#End
	Local path:String = CurrentDir() + "/data/meshtool" + ext
	If FileType(path) <> FILETYPE_FILE
		path = CurrentDir() + "/meshtool.data/meshtool" + ext
	Else
		'Make sure that file is given execution permissions on Linux
		Process.Execute("chmod +x ~q" + path + "~q")
	End
	Local command:String = "~q" + path + "~q ~q" + filename + "~q"
	Local output:String = Process.Execute(command).Trim()
	Local findIndex:Int = output.Find("<mesh>")
	If findIndex > -1 Then output = output[findIndex ..]
	Return Mesh.LoadString(output, "")
End