Strict

Private
#If LANG="cpp"
Import "native/lib.cpp"
#Else
#Error "Only the C++ language is supported in Lib module"
#End

Extern Private
Function _LoadLib:Int(libname:String) = "LoadLib"

Extern
Function FreeLib:Void(lib:Int)
Function LibFunction:Int(lib:Int, funcname:String)
Function PushLibInt:Void(val:Int)
Function PushLibFloat:Void(val:Float)
Function PushLibString:Void(str:String)
'Function PushLibObject:Void(obj:Object)
Function CallVoidFunction:Void(func:Int)
Function CallIntFunction:Int(func:Int)
Function CallFloatFunction:Float(func:Int)
Function CallStringFunction:String(func:Int)
'Function CallObjectFunction:Int(func:Int)
Function CallVoidCFunction:Void(func:Int)
Function CallIntCFunction:Int(func:Int)
Function CallFloatCFunction:Float(func:Int)
Function CallStringCFunction:String(func:Int)
'Function CallObjectCFunction:Object(func:Int)

Public

Function LoadLib:Int(libname:String)
#If HOST="winnt"
	libname += ".dll"
#Elseif HOST="macos"
	libname += ".dylib"
#Elseif HOST="linux"
	libname += ".so"
#End
	Return _LoadLib(libname)
End
