Strict

#GLFW_WINDOW_TITLE="Vortex2 Mesh Tool"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#GLFW_WINDOW_SAMPLES=2
#OPENGL_DEPTH_BUFFER_ENABLED=True
'#GLFW_GCC_MSIZE_LINUX="32"
#If HOST="winnt"
#BINARY_FILES="*.bin|*.dat|*.exe"
#End

Import brl.filepath
#If TARGET="glfw" And HOST<>"linux"
Import brl.requesters
#Endif
Import mojo.app
Import mojo.input
Import src_meshtool.gui
Import src_meshtool.loadmesh
Import src_meshtool.savemesh
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
		'If Not InitMeshLoader("loadmesh") Then Error "Could not load mesh loader library"
	
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
		mFont = Font.Load("system_16.fnt.xml")
		mCubeTex = Texture.Load("cube.png", Renderer.FILTER_NONE)
		mOpenTex = Texture.Load("folder.png", Renderer.FILTER_NONE)
		mSaveTex = Texture.Load("disk.png", Renderer.FILTER_NONE)
		
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
		mCamPos = Vec3.Create(0, 16, -16)
		mCamRot = Vec3.Create()
		mLastMouseX = MouseX()
		mLastMouseY = MouseY()
		mFreeLook = False
		
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
				Local filename:String = RequestFile("Open mesh")', "Mesh Files:msh.xml;All Files:*", False)
				If filename <> ""
					filename = filename.Replace("\", "/")
					Local mesh:Mesh = LoadMesh(filename)
					If mesh <> Null
						mFilename = filename
						If mMesh Then mRenderList.RemoveMesh(mMesh, mModel)
						mMesh = mesh
						mAnimMatrices = New Mat4[mesh.NumBones]
						For Local m:Int = 0 Until mAnimMatrices.Length
							mAnimMatrices[m] = Mat4.Create()
							mAnimMatrices[m].Set(mesh.GetBone(m).InversePoseMatrix)
						Next
						mAnimFrame = 0
						mRenderList.AddMesh(mesh, mModel, mAnimMatrices)
					End
				End
			'Save mesh
			Elseif mSaveRect.IsPointInside(MouseX(), MouseY())
				If mMesh
					Local filename:String = mFilename
					If filename = ""
						filename = RequestFile("Save mesh", "Mesh Files:msh.xml;All Files:*", True)
						If filename <> "" Then mFilename = filename
					Else
						filename = StripExt(filename) + ".msh.xml"
					End
					If filename <> "" Then SaveMesh(mMesh, filename, mExportAnimations)
				End
			'Check export animations
			Elseif mAnimationsRect.IsPointInside(MouseX(), MouseY())
				mExportAnimations = Not mExportAnimations
			End
		End
		
		'Update camera controls
		If MouseHit(MOUSE_RIGHT)
			mFreeLook = Not mFreeLook
			'If mFreeLook Then HideMouse() Else ShowMouse()
		End
		If mFreeLook
			mCamRot.X += (MouseY() - mLastMouseY) * 90 * mDeltaTime
			mCamRot.Y += (MouseX() - mLastMouseX) * 90 * mDeltaTime
			If mCamRot.X > 89 Then mCamRot.X = 89
			If mCamRot.X < -89 Then mCamRot.X = -89
			mTempQuat.SetEuler(mCamRot.X, mCamRot.Y, mCamRot.Z)
			If KeyDown(KEY_W)
				mTempQuat.Mul(0, 0, 32 * mDeltaTime)
				mCamPos.Sum(mTempQuat.ResultVector())
			End
			If KeyDown(KEY_S)
				mTempQuat.Mul(0, 0, -32 * mDeltaTime)
				mCamPos.Sum(mTempQuat.ResultVector())
			End
			If KeyDown(KEY_A)
				mTempQuat.Mul(-32 * mDeltaTime, 0, 0)
				mCamPos.Sum(mTempQuat.ResultVector())
			End
			If KeyDown(KEY_D)
				mTempQuat.Mul(32 * mDeltaTime, 0, 0)
				mCamPos.Sum(mTempQuat.ResultVector())
			End
		End
		
		'Update mouse
		mLastMouseX = MouseX()
		mLastMouseY = MouseY()
		
		'Update camera projection
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 5000)
		
		'Update camera view
		mTempQuat.SetEuler(mCamRot.X, mCamRot.Y, mCamRot.Z)
		mTempQuat.Mul(0, 0, 1)
		mView.LookAtLH(mCamPos.X, mCamPos.Y, mCamPos.Z, mCamPos.X + mTempQuat.ResultVector().X, mCamPos.Y + mTempQuat.ResultVector().Y, mCamPos.Z + mTempQuat.ResultVector().Z, 0, 1, 0)
		
		'Update light
		mTempQuat.ResultVector().Sub(mCamPos)
		mTempQuat.ResultVector().Normalize()
		mTempQuat.ResultVector().Mul(-1)
		Lighting.SetLightPosition(0, mTempQuat.ResultVector().X, mTempQuat.ResultVector().Y, mTempQuat.ResultVector().Z)
		
		'Update animations
		If mMesh And mMesh.LastFrame > 0
			mAnimFrame += 16 * mDeltaTime
			If mAnimFrame > mMesh.LastFrame+1 Then mAnimFrame -= Int(mAnimFrame)
			mMesh.Animate(mAnimMatrices, mAnimFrame)
		End
		
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
		If mMesh
			Renderer.SetColor(1, 1, 1)
			mFont.Draw(8, 34, "Num Surfaces: " + mMesh.NumSurfaces)
			mFont.Draw(8, 50, "Num Frames: " + mMesh.LastFrame)
			mFont.Draw(8, 66, "Num Bones: " + mMesh.NumBones)
		End
	
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
	Field mAnimMatrices			: Mat4[]
	Field mTempQuat				: Quat
	Field mRenderList			: RenderList
	
	'GUI
	Field mPanelRect		: Rect
	Field mCubeRect			: Rect
	Field mOpenRect			: Rect
	Field mSaveRect			: Rect
	Field mAnimationsRect	: Rect
	
	'Misc
	Field mFilename			: String
	Field mExportAnimations	: Bool
	Field mCamPos			: Vec3
	Field mCamRot			: Vec3
	Field mLastMouseX		: Float
	Field mLastMouseY		: Float
	Field mFreeLook			: Bool
	Field mAnimFrame		: Float
End

Function Main:Int()
	New TestApp()
	Return False
End
