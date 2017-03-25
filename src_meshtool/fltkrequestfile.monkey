Strict

Private

Import brl.filepath
Import brl.filesystem
Import brl.process
Import mojo.app
Import vortex

Public

Function RequestFile:String(title:String, filter:String = "", save:Bool = False, file:String = "")
#If HOST="winnt"
	Local ext:String = ".exe"
#Else
	Local ext:String = ".bin"
#End
	Local path:String = CurrentDir() + "/data/fltkrequestfile" + ext
	If FileType(path) <> FILETYPE_FILE
		path = CurrentDir() + "/meshtool.data/fltkrequestfile" + ext
	Else
		'Make sure that file is given execution permissions on Linux
		Process.Execute("chmod +x ~q" + path + "~q")
	End
	Local saveStr:String = "false"
	If save Then saveStr = "true"
	Local command:String = "~q" + path + "~q ~q" + title + "~q" + " ~q" + filter + "~q " + saveStr + " ~q" + file + "~q"
	Return Process.Execute(command).Trim()
End