Strict

#GLFW_WINDOW_TITLE="Vortex2 Mesh Tool"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#GLFW_WINDOW_SAMPLES=2
#OPENGL_DEPTH_BUFFER_ENABLED=True
#If HOST="winnt"
#BINARY_FILES="*.bin|*.dat|*.dll"
#Elseif HOST="macos"
#BINARY_FILES="*.bin|*.dat|*.dylib"
#Elseif HOST="linux"
#BINARY_FILES="*.bin|*.dat|*.so"
#End

#If TARGET="glfw" And HOST<>"linux"
Import brl.requesters
#Endif
Import mojo.app
Import mojo.input
Import src_meshtool.gui
Import src_meshtool.loadmesh
Import vortex

Class TestApp Extends App Final
Public
	Method OnCreate:Int()
		'Setup update rate and swap to maximum FPS, and init random seed
		SetUpdateRate(0)
		SetSwapInterval(0)
		Seed = Millisecs()
		mLastMillisecs = Millisecs()
		
		'Init LoadMesh dll
		If Not InitMeshLoader("loadmesh") Then Error "Could not load mesh loader library"
	
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
		
		'Load resources
		mFont = Cache.GetFont("system_16.fnt.xml")
		mCubeTex = Cache.GetTexture("cube.png", Renderer.FILTER_NONE)
		mOpenTex = Cache.GetTexture("folder.png", Renderer.FILTER_NONE)
		mSaveTex = Cache.GetTexture("xhtml.png", Renderer.FILTER_NONE)
		
		'Define gui elements rectangles
		mPanelRect = New Rect(8, 8, 64, 24)
		mCubeRect = New Rect(8 + 4, 8 + 4, 16, 16)
		mOpenRect = New Rect(8 + 24, 8 + 4, 16, 16)
		mSaveRect = New Rect(8 + 44, 8 + 4, 16, 16)
		mAnimationsRect = New Rect(76, 8, 150, 24)
		
		'Create matrices and quaternions
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mModel = Mat4.Create()
		mTempQuat = Quat.Create()
		
		'Create RenderList
		mRenderList = RenderList.Create()
		
		'Setup lighting
		Lighting.SetLightEnabled(0, True)
		Lighting.SetLightType(0, Lighting.DIRECTIONAL)
		
		mExportAnimations = True
		mPitch = 45
		mYaw = -45
		mDistance = 16
		mLastMouseX = MouseX()
		mLastMouseY = MouseY()
		mClickGUI = False
		
		#Rem
		'Load SWAT model, create matrices for animation data, and add mesh to RenderList
		mSwatMesh = Cache.GetMesh("swat.msh.xml")
		mSwatAnimMatrices = New Mat4[mSwatMesh.NumBones]
		For Local i:Int = 0 Until mSwatAnimMatrices.Length()
			mSwatAnimMatrices[i] = Mat4.Create()
		Next
		mSwatModel.SetTransform(-32, 0, 0, 0, -15, 0, 35, 35, 35)
		mRenderList.AddMesh(mSwatMesh, mSwatModel, mSwatAnimMatrices)
		
		'Load dwarf model, create matrices for animation data, and add mesh to RenderList
		mDwarfMesh = Cache.GetMesh("dwarf.msh.xml")
		mDwarfAnimMatrices = New Mat4[mDwarfMesh.NumBones]
		For Local i:Int = 0 Until mDwarfAnimMatrices.Length()
			mDwarfAnimMatrices[i] = Mat4.Create()
		Next
		mDwarfModel.SetTransform(32, 0, 0, 0, 15, 0, 1, 1, 1)
		mRenderList.AddMesh(mDwarfMesh, mDwarfModel, mDwarfAnimMatrices)
		#End
		
		Return False
	End
	
	Method OnUpdate:Int()
		'Update delta time
		mDeltaTime = (Millisecs() - mLastMillisecs) / 1000.0
		mLastMillisecs = Millisecs()
		
		'Update GUI controls
		If MouseHit(MOUSE_LEFT)
			'Load mesh
			If mOpenRect.IsPointInside(MouseX(), MouseY())
				Local filename:String = RequestFile("Select mesh")', "Mesh Files:msh.xml;All Files:*", False)
				If filename <> ""
					filename = filename.Replace("\", "/")
					Local mesh:Mesh = LoadMesh(filename)
					If mesh <> Null
						If mMesh Then mRenderList.RemoveMesh(mMesh, mModel)
						mRenderList.AddMesh(mesh, mModel)
						mMesh = mesh
					End
				End
				mClickGUI = True
			'Check export animations
			Elseif mAnimationsRect.IsPointInside(MouseX(), MouseY())
				mExportAnimations = Not mExportAnimations
				mClickGUI = True
			End
		End
		
		'Update camera controls
		If MouseDown(MOUSE_LEFT)
			If Not mClickGUI
				mPitch += (MouseY() - mLastMouseY) * 360 * mDeltaTime
				mYaw += (MouseX() - mLastMouseX) * 360 * mDeltaTime
				If mPitch > 89 Then mPitch = 89
				If mPitch < -89 Then mPitch = -89
			End
		Else
			mClickGUI = False
		End
		If MouseDown(MOUSE_RIGHT)
			mDistance += (MouseY() - mLastMouseY) * 32 * mDeltaTime
		End
		
		'Update mouse
		mLastMouseX = MouseX()
		mLastMouseY = MouseY()
		
		'Update camera projection
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 5000)
		
		'Update camera view
		mTempQuat.SetEuler(mPitch, mYaw, 0)
		mTempQuat.Mul(0, 0, -mDistance)
		mView.LookAtLH(mTempQuat.ResultVector().X, mTempQuat.ResultVector().Y, mTempQuat.ResultVector().Z, 0, 0, 0, 0, 1, 0)
		
		'Update light
		mTempQuat.ResultVector().Normalize()
		Lighting.SetLightPosition(0, mTempQuat.ResultVector().X, mTempQuat.ResultVector().Y, mTempQuat.ResultVector().Z)
		
		#Rem
		mSwatCurrentFrame += 16 * mDeltaTime
		If mSwatCurrentFrame > mSwatMesh.LastFrame+1 Then mSwatCurrentFrame = mSwatCurrentFrame - Int(mSwatCurrentFrame)
		mSwatMesh.Animate(mSwatAnimMatrices, mSwatCurrentFrame)
	
		mDwarfCurrentFrame += 16 * mDeltaTime
		If mDwarfCurrentFrame > mDwarfMesh.LastFrame+1 Then mDwarfCurrentFrame = mDwarfCurrentFrame - Int(mDwarfCurrentFrame)
		mDwarfMesh.Animate(mDwarfAnimMatrices, mDwarfCurrentFrame)
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
		
		'Render world
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Lighting.Prepare(0.3, 0.3, 0.3)
		Renderer.ClearColorBuffer(0.4, 0.4, 0.4)
		Renderer.ClearDepthBuffer()
		mRenderList.Render()
		
		'Render GUI
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetBlendMode(Renderer.BLEND_ALPHA)
		DrawPanel(mPanelRect)
		Renderer.SetColor(1, 1, 1)
		mCubeTex.Draw(mCubeRect.x, mCubeRect.y)
		mOpenTex.Draw(mOpenRect.x, mOpenRect.y)
		mSaveTex.Draw(mSaveRect.x, mSaveRect.y)
		DrawCheckbox(mAnimationsRect, "Export Animations", mFont, mExportAnimations)
	
		Return False
	End
Private
	Global mLastMillisecs	: Int
	Global mDeltaTime		: Float
	Global mCurrentFPS		: Int
	Global mFpsCounter		: Int
	Global mFpsAccum		: Float
	
	'Resources
	Field mFont				: Font
	Field mCubeTex			: Texture
	Field mOpenTex			: Texture
	Field mSaveTex			: Texture
	Field mMesh				: Mesh
	
	'Matrices and other Vortex stuff
	Field mProj					: Mat4
	Field mView					: Mat4
	Field mModel				: Mat4
	Field mTempQuat				: Quat
	Field mRenderList			: RenderList
	
	'GUI
	Field mPanelRect		: Rect
	Field mCubeRect			: Rect
	Field mOpenRect			: Rect
	Field mSaveRect			: Rect
	Field mAnimationsRect	: Rect
	
	'Misc
	Field mExportAnimations	: Bool
	Field mPitch			: Float
	Field mYaw				: Float
	Field mDistance			: Float
	Field mLastMouseX		: Float
	Field mLastMouseY		: Float
	Field mClickGUI			: Bool
End

Function Main:Int()
	New TestApp()
	Return False
End
