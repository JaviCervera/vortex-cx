Strict

#GLFW_WINDOW_TITLE="Vortex2 Primitives Test"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#GLFW_WINDOW_SAMPLES=2
#OPENGL_DEPTH_BUFFER_ENABLED=True

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
		
		'Init primitives
		mNumPrimitives = 0
		For Local i:Int = 0 Until mPrimitives.Length()
			mPrimitives[i] = New Prim
		Next
		
		'Load font
		mFont = Cache.GetFont("system_16.fnt.xml")
		
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
		
		mNumPrimitives += 1
		If mNumPrimitives > mPrimitives.Length() Then mNumPrimitives = mPrimitives.Length()
		mPrimitives[mNumPrimitives-1].type =Int(Rnd(0, 4))
		mPrimitives[mNumPrimitives-1].x = Rnd(DeviceWidth())
		mPrimitives[mNumPrimitives-1].y = Rnd(DeviceHeight())
		mPrimitives[mNumPrimitives-1].z = Rnd(DeviceWidth())
		mPrimitives[mNumPrimitives-1].w = Rnd(DeviceHeight())
		mPrimitives[mNumPrimitives-1].r = Rnd()
		mPrimitives[mNumPrimitives-1].g = Rnd()
		mPrimitives[mNumPrimitives-1].b = Rnd()
		
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
		
		'Setup renderer for 2D graphics
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.ClearColorBuffer()
		For Local i:Int = 0 Until mNumPrimitives
			Local prim:Prim = mPrimitives[i]
			Renderer.SetColor(prim.r, prim.g, prim.b)
			Select prim.type
				Case PRIM_POINT
					Renderer.DrawPoint(prim.x, prim.y, 0)
				Case PRIM_LINE
					Renderer.DrawLine(prim.x, prim.y, 0, prim.z, prim.w, 0)
				Case PRIM_RECT
					Renderer.DrawRect(prim.x, prim.y, 0, prim.z, prim.w)
				Case PRIM_ELLIPSE
					Renderer.DrawEllipse(prim.x, prim.y, 0, prim.z, prim.w)
			End
		Next
		mNumRenderCalls = mNumPrimitives
		
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
	
	Field mNumPrimitives	: Int
	Field mPrimitives		: Prim[1000]
End

Function Main:Int()
	New TestApp()
	Return False
End
