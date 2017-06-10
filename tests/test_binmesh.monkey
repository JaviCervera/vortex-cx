Strict

#GLFW_WINDOW_TITLE="Vortex2 Binary Mesh Test"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#GLFW_WINDOW_SAMPLES=2
#OPENGL_DEPTH_BUFFER_ENABLED=True
#BINARY_FILES="*.bin|*.dat|*.msh"

#If TARGET="glfw" And HOST<>"linux"
Import brl.requesters
#Endif
Import mojo.app
Import mojo.input
Import vortex

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
		
		'Create matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mModel = Mat4.Create()
		
		'Create RenderList
		mRenderList = RenderList.Create()
		
		'Load mesh
		mMesh = Mesh.Load("dwarf.msh")
		
		'Add mesh to RenderList
		mRenderList.AddMesh(mMesh, mModel)
		
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
		
		mEulerY += 64 * mDeltaTime
		
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
		
		'Setup matrices
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAtLH(0, 64, -128, 0, 32, 0, 0, 1, 0)
		mModel.SetTransform(0, 0, 0, 0, mEulerY, 0, 1, 1, 1)
		
		'Draw triangles
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.ClearColorBuffer(0, 0, 0)
		Renderer.ClearDepthBuffer()
		mNumRenderCalls = mRenderList.Render()
		
		'Setup renderer for 2D graphics
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		
		'Draw FPS
		Renderer.SetColor(1, 1, 0)
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
	
	Field mProj				: Mat4
	Field mView				: Mat4
	Field mModel			: Mat4
	Field mMesh				: Mesh
	Field mRenderList		: RenderList
	Field mEulerY			: Float
End

Function Main:Int()
	New TestApp()
	Return False
End
