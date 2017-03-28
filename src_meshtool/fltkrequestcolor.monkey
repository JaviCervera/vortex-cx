Strict

Private

Import brl.filepath
Import brl.filesystem
Import brl.process
Import mojo.app
Import vortex

Public

Function RequestColor:Float[](title:String, r:Float = 1.0, g:Float = 1.0, b:Float = 1.0)
#If HOST="winnt"
	Local ext:String = ".exe"
#Else
	Local ext:String = ".bin"
#End
	Local path:String = CurrentDir() + "/data/fltkrequestcolor" + ext
	If FileType(path) <> FILETYPE_FILE
		path = CurrentDir() + "/meshtool.data/fltkrequestcolor" + ext
	Else
		'Make sure that file is given execution permissions on Linux
		Process.Execute("chmod +x ~q" + path + "~q")
	End
	Local command:String = "~q" + path + "~q ~q" + title + "~q " + r + " " + g + " " + b
	Local retStr:String = Process.Execute(command).Trim()
	If retStr = ""
		Return New Float[0]
	Else
		Local retArr:String[] = retStr.Split(" ")
		Return [Float(retArr[0]), Float(retArr[1]), Float(retArr[2])]
	End
End