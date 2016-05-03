Strict

Private
Import vortex.src.bone
Import vortex.src.brush
Import vortex.src.math3d
Import vortex.src.mesh
Import vortex.src.renderer
Import vortex.src.surface

Public
Class Drawable Final
Public
	Const BILLBOARD_NONE% = 0
	Const BILLBOARD_SPHERICAL% = 1
	Const BILLBOARD_CYLINDRICAL% = 2

	Function Create:Drawable(mesh:Mesh)
		If mesh = Null Then Return Null
		Local d:Drawable = New Drawable
		d.mBillboardMode = BILLBOARD_NONE
		d.mMesh = mesh
		d.mSurface = Null
		d.mPosition = Vec3.Create(0,0,0)
		d.mEuler = Vec3.Create(0,0,0)
		d.mQuat = Quat.Create(1,0,0,0)
		d.mScale = Vec3.Create(1,1,1)
		d.mAnimMatrices = New Mat4[mesh.GetNumBones()]
		For Local i:Int = 0 Until d.mAnimMatrices.Length()
			d.mAnimMatrices[i] = Mat4.Create()
		Next
		Return d
	End

	Function Create:Drawable(surface:Surface)
		If surface = Null Then Return Null
		Local d:Drawable = New Drawable
		d.mBillboardMode = BILLBOARD_NONE
		d.mMesh = Null
		d.mSurface = surface
		d.mPosition = Vec3.Create(0,0,0)
		d.mEuler = Vec3.Create(0,0,0)
		d.mQuat = Quat.Create(1,0,0,0)
		d.mScale = Vec3.Create(1,1,1)
		Return d
	End

	Function Create:Drawable(brush:Brush, width:Float = 0, height:Float = 0, mode:Int = BILLBOARD_SPHERICAL)
		If brush <> Null And brush.GetBaseTexture() <> Null
			If width = 0 Then width = brush.GetBaseTexture().GetWidth()
			If height = 0 Then height = brush.GetBaseTexture().GetHeight()
		Else
			If width = 0 Then width = 1
			If height = 0 Then height = 1
		End

		'Create drawable
		Local d:Drawable = New Drawable
		d.mBillboardMode = mode
		d.mMesh = Null
		d.mPosition = Vec3.Create(0,0,0)
		d.mEuler = Vec3.Create(0,0,0)
		d.mQuat = Quat.Create(1,0,0,0)
		d.mScale = Vec3.Create(1,1,1)

		'Add surface
		d.mSurface = Surface.Create(brush)

		'Add vertices and indices
		Local x0# = -width/2
		Local x1# =  width/2
		Local z0# = -height/2
		Local z1# =  height/2
#If VORTEX_HANDEDNESS=VORTEX_LH
		'Add triangles
		d.mSurface.AddTriangle(0, 1, 2)
		d.mSurface.AddTriangle(2, 1, 3)

		d.mSurface.AddVertex(x0, z1, 0, 0, 0, -1, 1, 1, 1, 1, 0, 0)
		d.mSurface.AddVertex(x1, z1, 0, 0, 0, -1, 1, 1, 1, 1, 1, 0)
		d.mSurface.AddVertex(x0, z0, 0, 0, 0, -1, 1, 1, 1, 1, 0, 1)
		d.mSurface.AddVertex(x1, z0, 0, 0, 0, -1, 1, 1, 1, 1, 1, 1)
#Elseif VORTEX_HANDEDNESS=VORTEX_RH_Y
		'Add triangles
		d.mSurface.AddTriangle(0, 2, 1)
		d.mSurface.AddTriangle(2, 3, 1)

		d.mSurface.AddVertex(x0, z1, 0, 0, -1, 0, 1, 1, 1, 1, 0, 1)
		d.mSurface.AddVertex(x1, z1, 0, 0, -1, 0, 1, 1, 1, 1, 1, 1)
		d.mSurface.AddVertex(x0, z0, 0, 0, -1, 0, 1, 1, 1, 1, 0, 0)
		d.mSurface.AddVertex(x1, z0, 0, 0, -1, 0, 1, 1, 1, 1, 1, 0)
#Else
		'Add triangles
		d.mSurface.AddTriangle(0, 2, 1)
		d.mSurface.AddTriangle(2, 3, 1)

		d.mSurface.AddVertex(x0, 0, z1, 0, -1, 0, 1, 1, 1, 1, 0, 1)
		d.mSurface.AddVertex(x1, 0, z1, 0, -1, 0, 1, 1, 1, 1, 1, 1)
		d.mSurface.AddVertex(x0, 0, z0, 0, -1, 0, 1, 1, 1, 1, 0, 0)
		d.mSurface.AddVertex(x1, 0, z0, 0, -1, 0, 1, 1, 1, 1, 1, 0)
#End

		'Rebuild surface
		d.mSurface.Rebuild()

		Return d
	End

	Method Free:Void()
		If mSurface Then mSurface.Discard()
		mSurface = Null
	End
	
	Method Animate:Void(frame:Float, firstFrame:Int = 0, lastFrame:Int = 0)
		mMesh.Animate(mAnimMatrices, frame, firstFrame, lastFrame)
	End

	Method Draw:Void(animated:Bool = False)
		'Calculate transform matrix
		Select mBillboardMode
			Case BILLBOARD_NONE
				mQuat.CalcAxis()
				mTempMatrix.SetIdentity()
				mTempMatrix.Translate(GetX(), GetY(), GetZ())
				mTempMatrix.Rotate(mQuat.Angle(), mQuat.ResultVector().x, mQuat.ResultVector().y, mQuat.ResultVector().z)
				mTempMatrix.Scale(GetScaleX(), GetScaleY(), GetScaleZ())
			Case BILLBOARD_SPHERICAL
				FillTransformArray()
				mTempMatrix.Set(mTempArray)
#If VORTEX_HANDEDNESS=VORTEX_LH Or VORTEX_HANDEDNESS=VORTEX_RH_Y
				mTempMatrix.Rotate(mEuler.z, 0, 0, 1)
#Else
				mTempMatrix.Rotate(mEuler.y, 0, 1, 0)
#End
				mTempMatrix.Scale(GetScaleX(), GetScaleY(), GetScaleZ())
			Case BILLBOARD_CYLINDRICAL
				FillTransformArray()
				mTempMatrix.Set(mTempArray)
#If VORTEX_HANDEDNESS=VORTEX_LH Or VORTEX_HANDEDNESS=VORTEX_RH_Y
				mTempMatrix.Rotate(mEuler.z, 0, 0, 1)
#Else
				mTempMatrix.Rotate(mEuler.y, 0, 1, 0)
#End
				mTempMatrix.Scale(GetScaleX(), GetScaleY(), GetScaleZ())
		End
		Renderer.SetModelMatrix(mTempMatrix)
		
		'Disable skinning (it will be reenabled by the mesh if it is skinned)
		Renderer.SetSkinned(False)

		'Draw
		If mMesh <> Null
			mMesh.Draw(animated, mAnimMatrices)
		Elseif mSurface <> Null
			mSurface.Draw()
		End
	End

	Method GetBillboardMode:Int()
		Return mBillboardMode
	End

	Method GetMesh:Mesh()
		Return mMesh
	End

	Method GetSurface:Surface()
		Return mSurface
	End

	Method SetPosition:Void(x:Float, y:Float, z:Float)
		mPosition.Set(x, y, z)
	End

	Method GetX:Float()
		Return mPosition.x
	End

	Method GetY:Float()
		Return mPosition.y
	End

	Method GetZ:Float()
		Return mPosition.z
	End

	Method SetEuler:Void(x:Float, y:Float, z:Float)
		mEuler.Set(x, y, z)
		mQuat.SetEuler(x, y, z)
	End

	Method GetEulerX:Float()
		Return mEuler.x
	End

	Method GetEulerY:Float()
		Return mEuler.y
	End

	Method GetEulerZ:Float()
		Return mEuler.z
	End

	Method SetQuat:Void(w:Float, x:Float, y:Float, z:Float)
		mQuat.Set(w, x, y, z)
		mQuat.CalcEuler()
		mEuler.Set(mQuat.ResultVector())
	End

	Method GetQuatW:Float()
		Return mQuat.w
	End

	Method GetQuatX:Float()
		Return mQuat.x
	End

	Method GetQuatY:Float()
		Return mQuat.y
	End

	Method GetQuatZ:Float()
		Return mQuat.z
	End

	Method SetScale:Void(x:Float, y:Float, z:Float)
		mScale.Set(x, y, z)
	End

	Method GetScaleX:Float()
		Return mScale.x
	End

	Method GetScaleY:Float()
		Return mScale.y
	End

	Method GetScaleZ:Float()
		Return mScale.z
	End

	Method Move:Void(x:Float, y:Float, z:Float)
		mQuat.Mul(x, y, z)
		mPosition.Sum(Quat.ResultVector())
	End

	Method _GetQuat:Quat()
		Return mQuat
	End
Private
	Method New()
	End

	Method FillTransformArray:Void()
		mTempArray[0] = Renderer.GetViewMatrix().m[0]
		mTempArray[1] = Renderer.GetViewMatrix().m[4]
		mTempArray[2] = Renderer.GetViewMatrix().m[8]
		mTempArray[3] = 0
#If VORTEX_HANDEDNESS=VORTEX_LH Or VORTEX_HANDEDNESS=VORTEX_RH_Y
		If mBillboardMode = BILLBOARD_SPHERICAL
			mTempArray[4] = Renderer.GetViewMatrix().m[1]
			mTempArray[5] = Renderer.GetViewMatrix().m[5]
			mTempArray[6] = Renderer.GetViewMatrix().m[9]
		Else
			mTempArray[4] = 0
			mTempArray[5] = 1
			mTempArray[6] = 0
		End
		mTempArray[7] = 0
		mTempArray[8] = Renderer.GetViewMatrix().m[2]
		mTempArray[9] = Renderer.GetViewMatrix().m[6]
		mTempArray[10] = Renderer.GetViewMatrix().m[10]
#Else
		mTempArray[4] = Renderer.GetViewMatrix().m[2]
		mTempArray[5] = Renderer.GetViewMatrix().m[6]
		mTempArray[6] = Renderer.GetViewMatrix().m[10]
		mTempArray[7] = 0
		If mBillboardMode = BILLBOARD_SPHERICAL
			mTempArray[8] = Renderer.GetViewMatrix().m[1]
			mTempArray[9] = Renderer.GetViewMatrix().m[5]
			mTempArray[10] = Renderer.GetViewMatrix().m[9]
		Else
			mTempArray[8] = 0
			mTempArray[9] = 0
			mTempArray[10] = 1
		End
#End
		mTempArray[11] = 0
		mTempArray[12] = GetX()
		mTempArray[13] = GetY()
		mTempArray[14] = GetZ()
		mTempArray[15] = 1
	End

	Field mBillboardMode	: Int
	Field mMesh				: Mesh		'For mesh drawables
	Field mSurface			: Surface	'For billboard drawables
	Field mPosition			: Vec3
	Field mEuler			: Vec3
	Field mQuat				: Quat
	Field mScale			: Vec3
	Field mAnimMatrices		: Mat4[]
	Global mTempMatrix		: Mat4 = Mat4.Create()
	Global mTempArray		: Float[16]
End
