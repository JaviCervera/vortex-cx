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
#If TARGET="glfw" And HOST="linux"
Import src_meshtool.fltkrequestfile
#End
Import mojo.app
Import mojo.input
Import src_meshtool.fltkrequestcolor
Import src_meshtool.gui
Import src_meshtool.loadmesh
Import src_meshtool.savemesh
Import vortex

Class MeshToolApp Extends App Final
Public
	Method OnCreate:Int()
		'Setup update rate and swap to maximum FPS, and init random seed
		SetUpdateRate(30)
		SetSwapInterval(1)
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
		mPitchRect = New Rect(230, 8, 96, 24)
		mYawRect = New Rect(330, 8, 96, 24)
		mRollRect = New Rect(430, 8, 96, 24)
		mMaterialRect = New Rect(0, 8, 108, 748)
		mSelMatRect = New Rect(4, 4, 100, 24)
		mDiffuseColorRect = New Rect(4, 32, 100, 24)
		mDiffuseTexRect = New Rect(4, 60, 100, 100)
		mNormalTexRect = New Rect(4, 164, 100, 100)
		mLightmapRect = New Rect(4, 268, 100, 100)
		mReflectionTexRect = New Rect(4, 372, 100, 100)
		mRefractionTexRect = New Rect (4, 476, 100, 100)
		mRefractionCoefRect = New Rect(4, 580, 100, 24)
		mOpacityRect = New Rect(4, 608, 100, 24)
		mShininessRect = New Rect(4, 636, 100, 24)
		mBlendModeRect = New Rect(4, 664, 100, 24)
		mCullingRect = New Rect(4, 692, 100, 24)
		mDepthWriteRect = New Rect(4, 720, 100, 24)
		
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
		mCamPos = Vec3.Create(2, 2, -2)
		mCamRot = Vec3.Create(37, -45, 0)
		mLastMouseX = MouseX()
		mLastMouseY = MouseY()
		mFreeLook = False
		mAnimFrame = 0
		mPitchFix = 0
		mYawFix = 0
		mRollFix = 0
		
		Return False
	End
	
	Method OnUpdate:Int()
		'Update delta time
		mDeltaTime = (Millisecs() - mLastMillisecs) / 1000.0
		mLastMillisecs = Millisecs()
		
		'Update material rect
		mMaterialRect.x = DeviceWidth() - 112
		
		'Update GUI controls
		If MouseHit(MOUSE_LEFT)
			'Create cube
			If mCubeRect.IsPointInside(MouseX(), MouseY())
				If mMesh Then mRenderList.RemoveMesh(mMesh, mModel)
				mMesh = CreateCube()
				mFilename = ""
				mRenderList.AddMesh(mMesh, mModel)
			'Load mesh
			Elseif mOpenRect.IsPointInside(MouseX(), MouseY())
				Local filename:String = RequestFile("Load mesh")', "Mesh Files:msh.xml;All Files:*", False)
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
						mExportAnimations = True
						mPitchFix = 0
						mYawFix = 0
						mRollFix = 0
						mAnimFrame = 0
						mSelMat = 0
						mRenderList.AddMesh(mesh, mModel, mAnimMatrices)
					End
				End
			'Save mesh
			Elseif mSaveRect.IsPointInside(MouseX(), MouseY())
				If mMesh
					Local filename:String = mFilename
					If filename = ""
#If HOST="linux"
						filename = RequestFile("Save mesh", "Mesh Files (*.msh.xml)~tAll Files (*)", True)
#Else
						filename = RequestFile("Save mesh", "Mesh Files:msh.xml;All Files:*", True)
#End
						If filename <> "" Then mFilename = filename
					Else
						filename = StripExt(filename) + ".msh.xml"
					End
					If filename <> "" Then SaveMeshXML(mMesh, filename, mExportAnimations)
				End
			'Export animations
			Elseif mAnimationsRect.IsPointInside(MouseX(), MouseY()) And mMesh
				mExportAnimations = Not mExportAnimations
			'Pitch
			Elseif mPitchRect.IsPointInside(MouseX(), MouseY()) And mMesh
				mPitchFix = (mPitchFix + 90) Mod 360
				RotateMesh(mMesh, 90, 0, 0)
			'Yaw
			Elseif mYawRect.IsPointInside(MouseX(), MouseY()) And mMesh
				mYawFix = (mYawFix + 90) Mod 360
				RotateMesh(mMesh, 0, 90, 0)
			'Roll
			Elseif mRollRect.IsPointInside(MouseX(), MouseY()) And mMesh
				mRollFix = (mRollFix + 90) Mod 360
				RotateMesh(mMesh, 0, 0, 90)
			'Material
			Elseif mSelMatRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				mSelMat += 1
				If mSelMat = mMesh.NumSurfaces Then mSelMat = 0
			'Diffuse color
			Elseif mDiffuseColorRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				Local color:Float[] = RequestColor("Select diffuse color", mMesh.GetSurface(mSelMat).Material.DiffuseRed, mMesh.GetSurface(mSelMat).Material.DiffuseGreen, mMesh.GetSurface(mSelMat).Material.DiffuseBlue)
				If color.Length > 0 Then mMesh.GetSurface(mSelMat).Material.SetDiffuseColor(color[0], color[1], color[2])
			'Diffuse texture
			Elseif mDiffuseTexRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				Local filename:String = RequestFile("Select diffuse texture")
				If filename <> ""
					Local tex:Texture = Texture.Load(filename)
					If tex Then mMesh.GetSurface(mSelMat).Material.DiffuseTexture = tex
				End
			'Normal texture
			Elseif mNormalTexRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				Local filename:String = RequestFile("Select normal texture")
				If filename <> ""
					Local tex:Texture = Texture.Load(filename)
					If tex Then mMesh.GetSurface(mSelMat).Material.NormalTexture = tex
				End
			'Lightmap
			Elseif mLightmapRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				Local filename:String = RequestFile("Select lightmap")
				If filename <> ""
					Local tex:Texture = Texture.Load(filename)
					If tex Then mMesh.GetSurface(mSelMat).Material.Lightmap = tex
				End
			#Rem
			'Reflection texture
			Elseif mReflectionTexRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				Local filename:String = RequestFile("Select reflection texture")
				If filename <> ""
					Local tex:Texture = Texture.Load(filename)
					If tex Then mMesh.GetSurface(mSelMat).Material.ReflectionTexture = tex
				End
			'Refraction texture
			Elseif mRefractionTexRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				Local filename:String = RequestFile("Select refraction texture")
				If filename <> ""
					Local tex:Texture = Texture.Load(filename)
					If tex Then mMesh.GetSurface(mSelMat).Material.RefractionTexture = tex
				End
			#End
			'Refraction coef
			Else If mRefractionCoefRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				Local iCoef:Int = Int(mMesh.GetSurface(mSelMat).Material.RefractionCoef * 100)
				iCoef += 10
				If iCoef > 100 Then iCoef = 0
				mMesh.GetSurface(mSelMat).Material.RefractionCoef = iCoef / 100.0
			'Opacity
			Else If mOpacityRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				Local iOp:Int = Int(mMesh.GetSurface(mSelMat).Material.Opacity * 100)
				iOp += 10
				If iOp > 100 Then iOp = 0
				mMesh.GetSurface(mSelMat).Material.Opacity = iOp / 100.0
			'Shininess
			Else If mShininessRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				Local iShininess:Int = Int(mMesh.GetSurface(mSelMat).Material.Shininess * 100)
				iShininess += 10
				If iShininess > 100 Then iShininess = 0
				mMesh.GetSurface(mSelMat).Material.Shininess = iShininess / 100.0
			'Blend
			Else If mBlendModeRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				mMesh.GetSurface(mSelMat).Material.BlendMode += 1
				If mMesh.GetSurface(mSelMat).Material.BlendMode > Renderer.BLEND_MUL Then mMesh.GetSurface(mSelMat).Material.BlendMode = 0
			'Culling
			Else If mCullingRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				mMesh.GetSurface(mSelMat).Material.Culling = Not mMesh.GetSurface(mSelMat).Material.Culling
			'Depth write
			Else If mDepthWriteRect.IsPointInside(MouseX() - mMaterialRect.x, MouseY() - mMaterialRect.y) And mMesh
				mMesh.GetSurface(mSelMat).Material.DepthWrite = Not mMesh.GetSurface(mSelMat).Material.DepthWrite
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
		Lighting.Prepare(0, 0, 0)
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
		If mMesh
			DrawCheckbox(mAnimationsRect, "Export Animations", mFont, mExportAnimations)
			DrawPanel(mPitchRect, "Pitch: " + mPitchFix, mFont)
			DrawPanel(mYawRect, "Yaw: " + mYawFix, mFont)
			DrawPanel(mRollRect, "Roll: " + mRollFix, mFont)
			Renderer.SetColor(1, 1, 1)
			mFont.Draw(8, 34, "Num Surfaces: " + mMesh.NumSurfaces)
			mFont.Draw(8, 50, "Num Frames: " + mMesh.LastFrame)
			mFont.Draw(8, 66, "Num Bones: " + mMesh.NumBones)
			DrawPanel(mMaterialRect)
			DrawPanel(mMaterialRect.x + mSelMatRect.x, mMaterialRect.y + mSelMatRect.y, mSelMatRect.width, mSelMatRect.height, "Material #" + mSelMat, mFont)
			DrawPanel(mMaterialRect.x + mDiffuseColorRect.x, mMaterialRect.y + mDiffuseColorRect.y, mDiffuseColorRect.width, mDiffuseColorRect.height, "Diffuse Color", mFont, mMesh.GetSurface(mSelMat).Material.DiffuseRed, mMesh.GetSurface(mSelMat).Material.DiffuseGreen, mMesh.GetSurface(mSelMat).Material.DiffuseBlue)
			
			'Diffuse
			If mMesh.GetSurface(mSelMat).Material.DiffuseTexture
				Renderer.SetColor(1, 1, 1)
				mMesh.GetSurface(mSelMat).Material.DiffuseTexture.Draw(mMaterialRect.x + mDiffuseTexRect.x, mMaterialRect.y + mDiffuseTexRect.y, mDiffuseTexRect.width, mDiffuseTexRect.height)
			Else
				DrawPanel(mMaterialRect.x + mDiffuseTexRect.x, mMaterialRect.y + mDiffuseTexRect.y, mDiffuseTexRect.width, mDiffuseTexRect.height)
			End
			
			'Normal
			If mMesh.GetSurface(mSelMat).Material.NormalTexture
				Renderer.SetColor(1, 1, 1)
				mMesh.GetSurface(mSelMat).Material.NormalTexture.Draw(mMaterialRect.x + mNormalTexRect.x, mMaterialRect.y + mNormalTexRect.y, mNormalTexRect.width, mNormalTexRect.height)
			Else
				DrawPanel(mMaterialRect.x + mNormalTexRect.x, mMaterialRect.y + mNormalTexRect.y, mNormalTexRect.width, mNormalTexRect.height)
			End
			
			'Lightmap
			If mMesh.GetSurface(mSelMat).Material.Lightmap
				Renderer.SetColor(1, 1, 1)
				mMesh.GetSurface(mSelMat).Material.Lightmap.Draw(mMaterialRect.x + mLightmapRect.x, mMaterialRect.y + mLightmapRect.y, mLightmapRect.width, mLightmapRect.height)
			Else
				DrawPanel(mMaterialRect.x + mLightmapRect.x, mMaterialRect.y + mLightmapRect.y, mLightmapRect.width, mLightmapRect.height)
			End
			
			'Reflection
			If mMesh.GetSurface(mSelMat).Material.ReflectionTexture
				Renderer.SetColor(1, 1, 1)
				mMesh.GetSurface(mSelMat).Material.ReflectionTexture.Draw(mMaterialRect.x + mReflectionTexRect.x, mMaterialRect.y + mReflectionTexRect.y, mReflectionTexRect.width, mReflectionTexRect.height)
			Else
				DrawPanel(mMaterialRect.x + mReflectionTexRect.x, mMaterialRect.y + mReflectionTexRect.y, mReflectionTexRect.width, mReflectionTexRect.height)
			End
			
			'Refraction
			If mMesh.GetSurface(mSelMat).Material.RefractionTexture
				Renderer.SetColor(1, 1, 1)
				mMesh.GetSurface(mSelMat).Material.RefractionTexture.Draw(mMaterialRect.x + mRefractionTexRect.x, mMaterialRect.y + mRefractionTexRect.y, mRefractionTexRect.width, mRefractionTexRect.height)
			Else
				DrawPanel(mMaterialRect.x + mRefractionTexRect.x, mMaterialRect.y + mRefractionTexRect.y, mRefractionTexRect.width, mRefractionTexRect.height)
			End
	
			DrawPanel(mMaterialRect.x + mRefractionCoefRect.x, mMaterialRect.y + mRefractionCoefRect.y, mRefractionCoefRect.width, mRefractionCoefRect.height, "Refr. Coef: " + String(mMesh.GetSurface(mSelMat).Material.RefractionCoef)[..4], mFont)
			DrawPanel(mMaterialRect.x + mOpacityRect.x, mMaterialRect.y + mOpacityRect.y, mOpacityRect.width, mOpacityRect.height, "Opacity: " + String(mMesh.GetSurface(mSelMat).Material.Opacity)[..4], mFont)
			DrawPanel(mMaterialRect.x + mShininessRect.x, mMaterialRect.y + mShininessRect.y, mShininessRect.width, mShininessRect.height, "Shininess: " + String(mMesh.GetSurface(mSelMat).Material.Shininess)[..4], mFont)
			Local blendStr:String = ""
			Select mMesh.GetSurface(mSelMat).Material.BlendMode
			Case Renderer.BLEND_ALPHA
				blendStr = "Alpha"
			Case Renderer.BLEND_ADD
				blendStr = "Add"
			Case Renderer.BLEND_MUL
				blendStr = "Mul"
			End
			DrawPanel(mMaterialRect.x + mBlendModeRect.x, mMaterialRect.y + mBlendModeRect.y, mBlendModeRect.width, mBlendModeRect.height, "Blend: " + blendStr, mFont)
			DrawCheckbox(mMaterialRect.x + mCullingRect.x, mMaterialRect.y + mCullingRect.y, mCullingRect.width, mCullingRect.height, "Culling", mFont, mMesh.GetSurface(mSelMat).Material.Culling)
			DrawCheckbox(mMaterialRect.x + mDepthWriteRect.x, mMaterialRect.y + mDepthWriteRect.y, mDepthWriteRect.width, mDepthWriteRect.height, "Depth Write", mFont, mMesh.GetSurface(mSelMat).Material.DepthWrite)
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
	Field mPanelRect			: Rect
	Field mCubeRect				: Rect
	Field mOpenRect				: Rect
	Field mSaveRect				: Rect
	Field mAnimationsRect		: Rect
	Field mPitchRect			: Rect
	Field mYawRect				: Rect
	Field mRollRect				: Rect
	Field mMaterialRect			: Rect
	Field mSelMatRect			: Rect
	Field mDiffuseColorRect		: Rect
	Field mDiffuseTexRect		: Rect
	Field mNormalTexRect		: Rect
	Field mLightmapRect			: Rect
	Field mReflectionTexRect	: Rect
	Field mRefractionTexRect	: Rect
	Field mRefractionCoefRect	: Rect
	Field mOpacityRect			: Rect
	Field mShininessRect		: Rect
	Field mBlendModeRect		: Rect
	Field mCullingRect			: Rect
	Field mDepthWriteRect		: Rect
	
	'Misc
	Field mFilename			: String
	Field mExportAnimations	: Bool
	Field mCamPos			: Vec3
	Field mCamRot			: Vec3
	Field mLastMouseX		: Float
	Field mLastMouseY		: Float
	Field mFreeLook			: Bool
	Field mAnimFrame		: Float
	Field mPitchFix			: Int
	Field mYawFix			: Int
	Field mRollFix			: Int
	Field mSelMat			: Int
End

Function CreateCube:Mesh()
	Local surf:Surface = Surface.Create()
	
	'Front face
	surf.AddVertex(-0.5,  0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5,  0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex(-0.5, -0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, -0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddTriangle(0, 1, 2)
	surf.AddTriangle(3, 2, 1)
	
	'Back face
	surf.AddVertex( 0.5,  0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddVertex(-0.5,  0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddVertex( 0.5, -0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddVertex(-0.5, -0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddTriangle(4, 5, 6)
	surf.AddTriangle(7, 6, 5)
	
	'Left face
	surf.AddVertex(-0.5,  0.5,  0.5,  -1, 0, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddVertex(-0.5,  0.5, -0.5,  -1, 0, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddVertex(-0.5, -0.5,  0.5,  -1, 0, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddVertex(-0.5, -0.5, -0.5,  -1, 0, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddTriangle(8, 9, 10)
	surf.AddTriangle(11, 10, 9)
	
	'Right face
	surf.AddVertex(0.5,  0.5, -0.5,  1, 0, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddVertex(0.5,  0.5,  0.5,  1, 0, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddVertex(0.5, -0.5, -0.5,  1, 0, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddVertex(0.5, -0.5,  0.5,  1, 0, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddTriangle(12, 13, 14)
	surf.AddTriangle(15, 14, 13)
	
	'Top face
	surf.AddVertex(-0.5, 0.5,  0.5,  0, 1, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, 0.5,  0.5,  0, 1, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex(-0.5, 0.5, -0.5,  0, 1, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, 0.5, -0.5,  0, 1, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddTriangle(16, 17, 18)
	surf.AddTriangle(19, 18, 17)
	
	'Bottom face
	surf.AddVertex(-0.5, -0.5, -0.5,  0, -1, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, -0.5, -0.5,  0, -1, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex(-0.5, -0.5,  0.5,  0, -1, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, -0.5,  0.5,  0, -1, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddTriangle(20, 21, 22)
	surf.AddTriangle(23, 22, 21)

	'Create mesh with surface
	Local cube:Mesh = Mesh.Create()
	cube.AddSurface(surf)
	
	Return cube
End

Function RotateMesh:Void(mesh:Mesh, pitch:Float, yaw:Float, roll:Float)
	'Get rotation quaternion
	Local q:Quat = Quat.Create()
	q.SetEuler(pitch, yaw, roll)
	q.CalcAxis()
	
	'Define rotation matrix
	Local mat:Mat4 = Mat4.Create()
	mat.Rotate(q.Angle(), q.ResultVector().X, q.ResultVector().Y, q.ResultVector().Z)
	
	'Rotate all surfaces
	For Local i:Int = 0 Until mesh.NumSurfaces
		RotateSurface(mesh.GetSurface(i), mat)
	Next
	
	'Rotate all bones
	For Local i:Int = 0 Until mesh.NumBones
		RotateBone(mesh.GetBone(i), mat, q)
	Next
End

Function RotateSurface:Void(surf:Surface, mat:Mat4)	
	For Local i:Int = 0 Until surf.NumVertices
		mat.Mul(surf.GetVertexX(i), surf.GetVertexY(i), surf.GetVertexZ(i), 1)
		surf.SetVertexPosition(i, mat.ResultVector().X, mat.ResultVector().Y, mat.ResultVector().Z)
		mat.Mul(surf.GetVertexNX(i), surf.GetVertexNY(i), surf.GetVertexNZ(i), 1)
		surf.SetVertexNormal(i, mat.ResultVector().X, mat.ResultVector().Y, mat.ResultVector().Z)
		mat.Mul(surf.GetVertexTX(i), surf.GetVertexTY(i), surf.GetVertexTZ(i), 1)
		surf.SetVertexTangent(i, mat.ResultVector().X, mat.ResultVector().Y, mat.ResultVector().Z)
	Next
	
	surf.Rebuild()
End

Function RotateBone:Void(bone:Bone, mat:Mat4, q:Quat)
	'TODO
End

Function Main:Int()
	New MeshToolApp()
	Return False
End
