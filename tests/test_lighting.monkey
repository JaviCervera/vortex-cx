Strict

#GLFW_WINDOW_TITLE="Vortex2 Lighting Test"
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
		mFont = Cache.GetFont("system_16.fnt.xml")
		
		'Create projection and view matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		
		'Create RenderList
		mRenderList = RenderList.Create()
		
		'Load sphere mesh
		mMesh = Cache.GetMesh("sphere.msh.xml")
		
		'Create sphere model matrices and add to RenderList
		mModels = New Mat4[81]
		Local x:Int = -32, z:Int = -32
		For Local i:Int = 0 Until mModels.Length()
			mModels[i] = Mat4.Create()
			mModels[i].SetTransform(x, 0, z, 0, 0, 0, 1, 1, 1)
			x += 8; If x > 32 Then x = -32; z += 8
			mRenderList.AddMesh(mMesh, mModels[i])
		Next
		
		'Prepare lights
		Lighting.SetLightEnabled(0, True)
		Lighting.SetLightEnabled(1, True)
		Lighting.SetLightEnabled(2, True)
		Lighting.SetLightType(0, Lighting.POINT)
		Lighting.SetLightType(1, Lighting.POINT)
		Lighting.SetLightType(2, Lighting.POINT)
		Lighting.SetLightAttenuation(0, 0.05)
		Lighting.SetLightAttenuation(1, 0.05)
		Lighting.SetLightAttenuation(2, 0.05)
		Lighting.SetLightColor(0, 1, 0, 0)
		Lighting.SetLightColor(1, 0, 1, 0)
		Lighting.SetLightColor(2, 0, 0, 1)
		mLightsEulerY[0] = 0
		mLightsEulerY[1] = 120
		mLightsEulerY[2] = 240
		
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
		
		For Local i:Int = 0 Until mLightsEulerY.Length()
			mLightsEulerY[i] += 32 * mDeltaTime
			Lighting.SetLightPosition(i, 48 * Cos(mLightsEulerY[i]), 0, 48 * Sin(mLightsEulerY[i]))
		Next
		
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
		
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAtLH(0, 32, -90, 0, 0, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Lighting.Prepare(0, 0, 0)
		Renderer.ClearColorBuffer(0, 0, 0)
		Renderer.ClearDepthBuffer()
	
		mNumRenderCalls = mRenderList.Render()
		
		'Setup renderer for 2D graphics
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		
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
	
	Field mProj				: Mat4
	Field mView				: Mat4
	Field mModels			: Mat4[]
	Field mMesh				: Mesh
	Field mRenderList		: RenderList
	Field mLightsEulerY		: Float[3]
End

Function Main:Int()
	New TestApp()
	Return False
End
