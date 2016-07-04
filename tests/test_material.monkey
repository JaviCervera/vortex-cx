Strict

#GLFW_WINDOW_TITLE="Vortex2 Material Test"
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
		
		'Create matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mModel = Mat4.Create()
		mSkyModel = Mat4.Create()
		mModel.SetTransform(0, 0, 0, 0, 0, 0, 1, 1, 1)
		mSkyModel.SetTransform(0, 0, 0, 0, 0, 0, -40, -40, -40)
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Load cubic texture
		mTexture = Cache.GetTexture("left.jpg", "right.jpg", "front.jpg", "back.jpg", "top.jpg", "bottom.jpg")
		
		'Load normal texture
		mNormalTex = Cache.GetTexture("t3_NORMALS.png")
		
		'Load box mesh
		mMesh = Cache.GetMesh("cube.msh.xml")
		Local mat:Material = mMesh.GetSurface(0).Material
		'mat.DiffuseTexture = Null
		mat.NormalTexture = mNormalTex
		'mat.ReflectionTexture = mTexture
		'mat.RefractionTexture = mTexture
		'mat.RefractionCoef = 0.98
		
		'Create skybox
		mSkybox = Mesh.Create(mMesh)
		mat = mSkybox.GetSurface(0).Material
		mat.Set(Material.Create(mTexture))
		mat.DepthWrite = False
		
		'Add meshes to RenderBatch
		mBatch.AddMesh(mSkybox, mSkyModel)
		mBatch.AddMesh(mMesh, mModel)
		
		'Prepare light
		Lighting.SetLightEnabled(0, True)
		Lighting.SetLightType(0, Lighting.POINT)
		Lighting.SetLightAttenuation(0, 0.05)
		Lighting.SetLightColor(0, 1, 1, 1)
		
		mEulerY = 0
			
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
		
		mEulerY += 32 * mDeltaTime

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
		
		Local posX:Float = Cos(mEulerY) * 2
		Local posZ:Float = -Sin(mEulerY) * 2
	
		mProj.SetPerspective(75, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAt(posX, 0, posZ, 0, 0, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Lighting.SetLightPosition(0, posX, 0, posZ)
		Lighting.Prepare(1, 1, 1)
		Renderer.ClearColorBuffer(0, 0, 0)
		Renderer.ClearDepthBuffer()
		mNumRenderCalls = mBatch.Render()
		
		'Setup painter for 2D graphics
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetColor(1, 1, 1)
		
		'Draw FPS
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
	Field mSkyModel			: Mat4
	Field mMesh				: Mesh
	Field mSkybox			: Mesh
	Field mTexture			: Texture
	Field mNormalTex		: Texture
	Field mBatch			: RenderBatch
	Field mEulerY			: Float
End

Function Main:Int()
	New TestApp()
	Return False
End