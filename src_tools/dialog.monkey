Strict

Private
Import brl.process
#If LANG="cpp"
Import "native/tinyfiledialogs.h"
Import "native/tinyfiledialogs.cpp"
Import "native/dialog.cpp"
'#If HOST="winnt"
'#GLFW_GCC_CC_OPTS+="-lole32"
'#End
#Else
#Error "Only the C++ language is supported in Dialog module"
#End

Extern Private
Function _RequestColor:Int(title:String, color:Int) = "RequestColor"

Extern
Function Notify:Void(title:String, text:String, serious:Bool = False)
Function RequestFile:String(title:String, filters:String = "", save:Bool = False, file:String = "")

Private
Global _requestedRed:Int
Global _requestedGreen:Int
Global _requestedBlue:Int

Public

Function RequestColor:Bool(title:String, red:Int, green:Int, blue:Int)
	Local col:Int = (red & $FF Shl 16) | (green & $FF Shl 8) | (blue & $FF)
	Local newCol:Int = _RequestColor(title, col)
	If newCol = col Then Return False
	_requestedRed = (newCol Shr 16) & $FF
	_requestedGreen = (newCol Shr 8) & $FF
	_requestedBlue = newCol & $FF
	Return True
End

Function RequestedRed:Int()
	Return _requestedRed
End

Function RequestedGreen:Int()
	Return _requestedGreen
End

Function RequestedBlue:Int()
	Return _requestedBlue
End