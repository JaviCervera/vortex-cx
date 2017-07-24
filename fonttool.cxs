'NOTE: To build on Win32 GCC, you need to go to the Makefile (i.e. glfw3/gcc_winnt/Makefile)
'and add -lole32 to the LDLIBS property

Strict

'Config settings
#GLFW_WINDOW_TITLE="Vortex2 Font Tool"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#GLFW_WINDOW_SAMPLES=2
#OPENGL_DEPTH_BUFFER_ENABLED=True
'#GLFW_GCC_MSIZE_LINUX="32"
#If HOST = "winnt"
#BINARY_FILES += "*.exe|*.fnt"
#Else
#BINARY_FILES += "*.bin|*.fnt"
#End

'Imports
Import mojo.app
Import mojo.input
Import src_tools.dialog
Import src_tools.fonttool_gui
Import vortex

Class FontToolApp Extends App Final
Public
	Method OnCreate:Int()
		'Setup update rate and swap to maximum FPS, and init random seed
		SetUpdateRate(30)
		SetSwapInterval(1)
		Seed = Millisecs()
	
		'Init vortex
		If Not Vortex.Init()
			Notify "Error", Vortex.ShaderError(), True
			EndApp()
		End
		Print "Vendor name: " + Vortex.VendorName()
		Print "Renderer name: " + Vortex.RendererName()
		Print "API version name: " + Vortex.APIVersionName()
		Print "Shading version name: " + Vortex.ShadingVersionName()
		Print "Shader compilation: " + Vortex.ShaderError()
		
		'Create gui
		mGui = New Gui
		
		Return False
	End
	
	Method OnUpdate:Int()
		'Update GUI
		Local newFont:Font = mGui.Update(mFont)
		If newFont <> Null
			If mFont Then mFont.Free()
			mFont = newFont
		End
		Return False
	End
	
	Method OnRender:Int()
		mGui.Render(mFont)
		Return False
	End
Private
	Field mFont	: Font
	Field mGui	: Gui
End

Function Main:Int()
	New FontToolApp()
	Return False
End
