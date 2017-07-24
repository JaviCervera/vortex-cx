'NOTE: To build on Win32 GCC, you need to go to the Makefile (i.e. glfw3/gcc_winnt/Makefile)
'and add -lole32 to the LDLIBS property

Strict

'Config settings
#GLFW_WINDOW_TITLE="Vortex2 Mesh Tool"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#GLFW_WINDOW_SAMPLES=2
#OPENGL_DEPTH_BUFFER_ENABLED=True
'#GLFW_GCC_MSIZE_LINUX="32"
#If HOST = "winnt"
#BINARY_FILES += "*.exe|*.fnt"
#Else
#BINARY_FILES += "*.bin|*.fnt"
#End

'Imports
Import mojo.app
Import mojo.input
Import src_tools.dialog
Import src_tools.meshtool_gui
Import vortex

Class MeshToolApp Extends App Implements IMaterialDelegate Final
Public
	Method OnCreate:Int()
		'Setup update rate and swap to maximum FPS, and init random seed
		SetUpdateRate(30)
		SetSwapInterval(1)
		Seed = Millisecs()
		mLastMillisecs = Millisecs()
	
		'Init vortex
		If Not Vortex.Init()
			Notify "Error", Vortex.ShaderError(), True
			EndApp()
		End
		Print "Vendor name: " + Vortex.VendorName()
		Print "Renderer name: " + Vortex.RendererName()
		Print "API version name: " + Vortex.APIVersionName()
		Print "Shading version name: " + Vortex.ShadingVersionName()
		Print "Shader compilation: " + Vortex.ShaderError()
		
		'Create gui
		mGui = New Gui
		
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
		
		mCamPos = Vec3.Create(2, 2, -2)
		mCamRot = Vec3.Create(37, -45, 0)
		mLastMouseX = MouseX()
		mLastMouseY = MouseY()
		mFreeLook = False
		mAnimFrame = 0
		
		Return False
	End
	
	Method OnUpdate:Int()
		'Update delta time
		mDeltaTime = (Millisecs() - mLastMillisecs) / 1000.0
		mLastMillisecs = Millisecs()
		
		'Update GUI
		Local newMesh:Mesh = mGui.Update(mMesh)
		If newMesh <> Null
			If mMesh Then mRenderList.RemoveMesh(mMesh, mModel)
			mMesh = newMesh
			
			'Set material delegate
			For Local s:Int = 0 Until mMesh.NumSurfaces
				mMesh.Surface(s).Material.Delegate = Self
			Next
			
			'Add animation matrices
			mAnimMatrices = New Mat4[mMesh.NumBones]
			For Local m:Int = 0 Until mAnimMatrices.Length
				mAnimMatrices[m] = Mat4.Create()
				mAnimMatrices[m].Set(mMesh.Bone(m).InversePoseMatrix)
			Next
			mAnimFrame = 0
			
			If mAnimMatrices.Length = 0
				mRenderList.AddMesh(mMesh, mModel)
			Else
				mRenderList.AddMesh(mMesh, mModel, mAnimMatrices)
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
		mTempQuat.ResultVector().Sum(mCamPos)
		mView.LookAtLH(mCamPos.X, mCamPos.Y, mCamPos.Z, mTempQuat.ResultVector().X, mTempQuat.ResultVector().Y, mTempQuat.ResultVector().Z, 0, 1, 0)
		
		'Update light
		mTempQuat.ResultVector().Sub(mCamPos)
		mTempQuat.ResultVector().Normalize()
		mTempQuat.ResultVector().Mul(-1)
		Lighting.SetLightPosition(0, mTempQuat.ResultVector().X, mTempQuat.ResultVector().Y, mTempQuat.ResultVector().Z)
		
		'Update animations
		If mMesh And mMesh.NumFrames > 0
			mAnimFrame += 16 * mDeltaTime
			If mAnimFrame >= mMesh.NumFrames Then mAnimFrame -= Int(mAnimFrame)
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
		Lighting.Prepare(0, 0, 0)
		Renderer.ClearColorBuffer(0.4, 0.4, 0.4)
		Renderer.ClearDepthBuffer()
		mRenderList.Render()
		
		'Render GUI
		mGui.Render(mMesh)
	
		Return False
	End
	
	Method MaterialChanged:Void(mat:Material)
		mRenderList.RemoveMesh(mMesh, mModel)
		mRenderList.AddMesh(mMesh, mModel, mAnimMatrices)
	End
Private
	Global mLastMillisecs	: Int
	Global mDeltaTime		: Float
	Global mCurrentFPS		: Int
	Global mFpsCounter		: Int
	Global mFpsAccum		: Float
	
	'Resources
	Field mMesh				: Mesh
	
	'Matrices and other Vortex stuff
	Field mProj					: Mat4
	Field mView					: Mat4
	Field mModel				: Mat4
	Field mAnimMatrices			: Mat4[]
	Field mTempQuat				: Quat
	Field mRenderList			: RenderList
	
	'Misc
	Field mGui				: Gui
	Field mCamPos			: Vec3
	Field mCamRot			: Vec3
	Field mLastMouseX		: Float
	Field mLastMouseY		: Float
	Field mFreeLook			: Bool
	Field mAnimFrame		: Float
End

Function Main:Int()
	New MeshToolApp()
	Return False
End
