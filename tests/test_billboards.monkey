Strict

#GLFW_WINDOW_TITLE="Vortex2 Billboards Test"
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
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Create billboard surface
		mBillboard = Surface.Create(Material.Create(Cache.GetTexture("smile.png")))

		'Add vertices and indices
		Local x0# = -0.5
		Local x1# =  0.5
		Local z0# = -0.5
		Local z1# =  0.5
		mBillboard.AddTriangle(0, 1, 2)
		mBillboard.AddTriangle(2, 1, 3)
		mBillboard.AddVertex(x0, z1, 0, 0, 0, -1, 1, 1, 1, 1, 0, 0)
		mBillboard.AddVertex(x1, z1, 0, 0, 0, -1, 1, 1, 1, 1, 1, 0)
		mBillboard.AddVertex(x0, z0, 0, 0, 0, -1, 1, 1, 1, 1, 0, 1)
		mBillboard.AddVertex(x1, z0, 0, 0, 0, -1, 1, 1, 1, 1, 1, 1)
		mBillboard.Rebuild()
		
		'Create billboard matrices, positions and surfaces
		mModels = New Mat4[64]
		mPositions = New Float[64][]
		mMaterials = New Material[64]
		Local x:Float = -8, z:Float = -8
		For Local i:Int = 0 Until mModels.Length()
			mModels[i] = Mat4.Create()
			mPositions[i] = [x, z]
			mMaterials[i] = Material.Create(Cache.GetTexture("smile.png"))
			mMaterials[i].SetDiffuseColor(Rnd(0, 1), Rnd(0, 1), Rnd(0, 1))
			mBatch.AddSurface(mBillboard, mModels[i], mMaterials[i])
			
			x += 2; If x >= 8 Then x = -8; z += 2
		Next
		
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
		
		mProj.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 100)
		mView.LookAt(Cos(mEulerY) * 8, Sin(45) * 8, Sin(mEulerY) * 8, 0, 0, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.ClearColorBuffer(1, 1, 1)
		Renderer.ClearDepthBuffer()
	
		For Local i:Int = 0 Until mPositions.Length()
			mModels[i].SetBillboardTransform(mView, mPositions[i][0], 0, mPositions[i][1], 0, 1, 1)
		Next
		
		mNumRenderCalls = mBatch.Render()
		
		'Setup renderer for 2D graphics
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		
		'Draw FPS
		Renderer.SetColor(0, 0, 0)
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
	Field mPositions		: Float[][]
	Field mMaterials		: Material[]
	Field mBillboard		: Surface
	Field mBatch			: RenderBatch
	Field mEulerY			: Float
End

Function Main:Int()
	New TestApp()
	Return False
End
