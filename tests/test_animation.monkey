Strict

#GLFW_WINDOW_TITLE="Vortex2 Animation Test"
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
		mSwatModel = Mat4.Create()
		mDwarfModel = Mat4.Create()
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Load SWAT model, create matrices for animation data, and add mesh to RenderBatch
		mSwatMesh = Cache.GetMesh("swat.msh.xml")
		mSwatAnimMatrices = New Mat4[mSwatMesh.GetNumBones()]
		For Local i:Int = 0 Until mSwatAnimMatrices.Length()
			mSwatAnimMatrices[i] = Mat4.Create()
		Next
		mSwatModel.SetTransform(-32, 0, 0, 0, -15, 0, 35, 35, 35)
		mBatch.AddMesh(mSwatMesh, mSwatModel, mSwatAnimMatrices)
		
		'Load dwarf model, create matrices for animation data, and add mesh to RenderBatch
		mDwarfMesh = Cache.GetMesh("dwarf.msh.xml")
		mDwarfAnimMatrices = New Mat4[mDwarfMesh.GetNumBones()]
		For Local i:Int = 0 Until mDwarfAnimMatrices.Length()
			mDwarfAnimMatrices[i] = Mat4.Create()
		Next
		mDwarfModel.SetTransform(32, 0, 0, 0, 15, 0, 1, 1, 1)
		mBatch.AddMesh(mDwarfMesh, mDwarfModel, mDwarfAnimMatrices)
		
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
		
		mSwatCurrentFrame += 16 * mDeltaTime
		If mSwatCurrentFrame > mSwatMesh.GetLastFrame()+1 Then mSwatCurrentFrame = mSwatCurrentFrame - Int(mSwatCurrentFrame)
		mSwatMesh.Animate(mSwatAnimMatrices, mSwatCurrentFrame)
	
		mDwarfCurrentFrame += 16 * mDeltaTime
		If mDwarfCurrentFrame > mDwarfMesh.GetLastFrame()+1 Then mDwarfCurrentFrame = mDwarfCurrentFrame - Int(mDwarfCurrentFrame)
		mDwarfMesh.Animate(mDwarfAnimMatrices, mDwarfCurrentFrame)
		
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
		
		mProj.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAt(0, 64, -128, 0, 32, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.SetModelMatrix(mDwarfModel)
		Renderer.ClearColorBuffer(1, 1, 1)
		Renderer.ClearDepthBuffer()
		mNumRenderCalls = mBatch.Render()
		
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetColor(0, 0, 0)
		mFont.Draw(4, DeviceHeight() - 20, "Frame: " + Int(mDwarfCurrentFrame))
		
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

	Field mProj					: Mat4
	Field mView					: Mat4
	Field mSwatModel			: Mat4
	Field mDwarfModel			: Mat4
	Field mSwatMesh				: Mesh
	Field mDwarfMesh			: Mesh
	Field mSwatAnimMatrices		: Mat4[]
	Field mDwarfAnimMatrices	: Mat4[]
	Field mSwatCurrentFrame		: Float
	Field mDwarfCurrentFrame	: Float
	Field mBatch				: RenderBatch
End

Function Main:Int()
	New TestApp()
	Return False
End
