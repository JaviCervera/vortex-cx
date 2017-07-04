Strict

Private
#If LANG="cpp"
Import "native/tinyfiledialogs.h"
Import "native/tinyfiledialogs.cpp"
Import "native/dialog.cpp"
#If HOST="winnt"
'#GLFW_GCC_CC_OPTS+="-lole32"
#End
#Else
#Error "Only the C++ language is supported in Lib module"
#End

Extern Private
Function _ColorDialog:Int(title:String, color:Int) = "ColorDialog"

Extern
Function Notify:Void(title:String, text:String, serious:Bool = False)
Function RequestFile:String(title:String, filters:String = "", save:Bool = False, file:String = "")

Public

Function ColorDialog:Float[](title:String, red:Float, green:Float, blue:Float)
	Local col:Int = (Int(red * 255) Shl 16) | (Int(green * 255) Shl 8) | Int(blue * 255)
	col = _ColorDialog(title, col)
	Return [((col Shr 16) & $FF) / 255.0, ((col Shr 8) & $FF) / 255.0, (col & $FF) / 255.0]
End