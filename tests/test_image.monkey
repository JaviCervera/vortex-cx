Strict

#GLFW_WINDOW_TITLE="Vortex2 Image Test"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#GLFW_WINDOW_SAMPLES=2
#OPENGL_DEPTH_BUFFER_ENABLED=True
#BINARY_FILES+="*.msh|*.skl|*.anm"

#If TARGET="glfw" And HOST<>"linux"
Import brl.requesters
#Endif
Import mojo.app
Import mojo.input
Import vortex

Const PRIM_POINT% = 0
Const PRIM_LINE% = 1
Const PRIM_RECT% = 2
Const PRIM_ELLIPSE% = 3

Class Prim Final
	Field type%
	Field x#, y#, z#, w#
	Field r#, g#, b#
End

Class TestApp Extends App Final
Public
	Method OnCreate:Int()
		'Setup update rate and swap to maximum FPS, and init random seed
		SetUpdateRate(0)
		SetSwapInterval(0)
		Seed = Millisecs()
		mLastMillisecs = Millisecs()
	
		'Init vortex
		If Not Vortex.Init()
#If TARGET="glfw" And HOST<>"linux"
			Notify "Error", Vortex.GetShaderError(), True
#Else
			Print "Error: " + Vortex.GetShaderError()
#Endif
			EndApp()
		End
		Print "Vendor name: " + Vortex.GetVendorName()
		Print "Renderer name: " + Vortex.GetRendererName()
		Print "API version name: " + Vortex.GetAPIVersionName()
		Print "Shading version name: " + Vortex.GetShadingVersionName()
		Print "Shader compilation: " + Vortex.GetShaderError()
		
		'Load font
		mFont = Font.Load("system_16.fnt.xml")
		
		'Load image
		mImage = Texture.Load("smile.png")
		
		Return False
	End
	
	Method OnUpdate:Int()
		'Update delta time
		mDeltaTime = (Millisecs() - mLastMillisecs) / 1000.0
		mLastMillisecs = Millisecs()
	
		'End with escape key
		#If TARGET<>"html5"
		If KeyHit(KEY_ESCAPE) Then EndApp()
		#End
		
		Return False
	End
	
	Method OnRender:Int()
		'Update FPS
		mFpsCounter += 1
		mFpsAccum += mDeltaTime
		If mFpsAccum >= 1
			mCurrentFPS = mFpsCounter
			mFpsCounter = 0
			mFpsAccum = 0
		End
		
		'Draw image
		mNumRenderCalls = 1
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.ClearColorBuffer()
		mImage.Draw((DeviceWidth() - mImage.Width)/2, (DeviceHeight() - mImage.Height)/2)
		
		'Draw FPS
		Renderer.SetColor(1, 1, 1)
		Local text$ = mCurrentFPS + " FPS"
		mFont.Draw(2, 2, text)
		
		'Draw RenderCalls
		text = "Render calls: " + mNumRenderCalls
		mFont.Draw(2, 18, text)
	
		Return False
	End
Private
	Global mLastMillisecs	: Int
	Global mDeltaTime		: Float
	Global mCurrentFPS		: Int
	Global mFpsCounter		: Int
	Global mFpsAccum		: Float
	
	Field mNumRenderCalls	: Int
	Field mFont				: Font
	
	Field mImage			: Texture
End

Function Main:Int()
	New TestApp()
	Return False
End
