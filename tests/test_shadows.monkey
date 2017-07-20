Strict

#GLFW_WINDOW_TITLE="Vortex2 Shadows Test"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#GLFW_WINDOW_SAMPLES=2
#OPENGL_DEPTH_BUFFER_ENABLED=True
#BINARY_FILES+="*.msh|*.skl|*.anm|*.fnt"

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
			Notify "Error", Vortex.ShaderError(), True
#Else
			Print "Error: " + Vortex.ShaderError()
#Endif
			EndApp()
		End
		Print "Vendor name: " + Vortex.VendorName()
		Print "Renderer name: " + Vortex.RendererName()
		Print "API version name: " + Vortex.APIVersionName()
		Print "Shading version name: " + Vortex.ShadingVersionName()
		Print "Shader compilation: " + Vortex.ShaderError()
		
		'Load font
		mFont = Font.Load("system.fnt")
		
		'Create matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mDepthProj = Mat4.Create()
		mDepthView = Mat4.Create()
		mModel = Mat4.Create()
		
		'Setup depth matrices
		mDepthProj.SetOrthoLH(250, Float(DeviceWidth()) / DeviceHeight(), 0, 500)
		'mDepthProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 500)	'It doesn't work with a perspective projection yet
		mDepthView.LookAtLH(256, 256, 256, 0, 0, 0, 0, 1, 0)
		
		'Create render list
		mRenderList = RenderList.Create()
		
		'Create framebuffer
		mFramebuffer = Framebuffer.Create(512, 512, True)
		
		'Load level
		mLevel = Mesh.Load("low-poly-mill.msh")
		mRenderList.AddMesh(mLevel, mModel)
		
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
		
		mEulerY -= 32 * mDeltaTime
		
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
		
		'Reset number of render calls
		mNumRenderCalls = 0
		
		'Set camera perspective and view
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 500)
		mView.LookAtLH(0, 100, -300, 0, 0, 0, 0, 1, 0)
		
		'Rotate model
		mModel.SetTransform(0, 0, 0, 0, mEulerY, 0, 1, 1, 1)
		
		'Render depth
		mFramebuffer.Set()
		Renderer.Setup3D(0, 0, mFramebuffer.ColorTexture.Width, mFramebuffer.ColorTexture.Height, True, mFramebuffer.ColorTexture.Height)
		Renderer.SetProjectionMatrix(mDepthProj)
		Renderer.SetViewMatrix(mDepthView)
		RenderScene(True)
		
		'Render scene
		Framebuffer.SetScreen()
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetDepthData(mDepthProj, mDepthView, mFramebuffer.ColorTexture.Handle, 0.005)
		Renderer.SetAmbient(0.6, 0.6, 0.6)
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		
		'Render thumbnail of depth view
		RenderScene()
		
		'Setup renderer for 2D graphics
		Framebuffer.SetScreen()
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		
		'Render thumbnail of depth view (the closer a fragment is to camera, the darker it looks)
		mFramebuffer.ColorTexture.Draw(DeviceWidth() - DeviceWidth()/3 - 4, DeviceHeight() - DeviceHeight()/3 - 4, DeviceWidth()/3, -DeviceHeight()/3)
		'mFramebuffer.ColorTexture.Draw(0, 0, DeviceWidth(), -DeviceHeight())
		
		'Draw FPS
		Renderer.SetColor(1, 1, 0)
		Local text$ = mCurrentFPS + " FPS"
		mFont.Draw(2, 2, text)
		
		'Draw RenderCalls
		text = "Render calls: " + mNumRenderCalls
		mFont.Draw(2, 18, text)
	
		Return False
	End
	
	Method RenderScene:Void(isDepthPass:Bool = False)
		Renderer.SetModelMatrix(mModel)
		Renderer.ClearDepthBuffer()
		If isDepthPass
			Renderer.ClearColorBuffer(1, 1, 1)
		Else
			Renderer.ClearColorBuffer(0.19, 0.10, 0.20)
		End
		mNumRenderCalls += mRenderList.Render()
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
	Field mDepthProj		: Mat4
	Field mDepthView		: Mat4
	Field mModel			: Mat4
	Field mFramebuffer		: Framebuffer
	Field mLevel			: Mesh
	Field mRenderList		: RenderList
	Field mEulerY			: Float
End

Function Main:Int()
	New TestApp()
	Return False
End
