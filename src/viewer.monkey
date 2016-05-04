#rem
Strict

Private
Import vortex.src.math3d
Import vortex.src.renderer

Public
Class Viewer Final
Public
	Function Create:Viewer(vx:Int, vy:Int, vw:Int, vh:Int)
		Local v:Viewer = New Viewer
		v.mProjMatrix = Mat4.Create()
		v.mViewMatrix = Mat4.Create()
		v.mRed = 0
		v.mGreen = 0
		v.mBlue = 0.5
		v.mVX = vx
		v.mVY = vy
		v.mVWidth = vw
		v.mVHeight = vh
		v.mPosition = Vec3.Create(0,0,0)
		v.mEuler = Vec3.Create(0,0,0)
		v.mQuat = Quat.Create(1,0,0,0)
		Return v
	End

	Method SetPerspective:Void(fovy:Float, ratio:Float, near:Float, far:Float)
		mProjMatrix.SetIdentity()
#If VORTEX_HANDEDNESS=VORTEX_LH
		mProjMatrix.SetPerspectiveLH(fovy, ratio, near, far)
#Else
		mProjMatrix.SetPerspectiveRH(fovy, ratio, near, far)
#End
	End

	Method SetFrustum:Void(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float)
		mProjMatrix.SetIdentity()
#If VORTEX_HANDEDNESS=VORTEX_LH
		mProjMatrix.SetFrustumLH(left, right, bottom, top, near, far)
#Else
		mProjMatrix.SetFrustumRH(left, right, bottom, top, near, far)
#End
	End

	Method SetOrtho:Void(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float)
		mProjMatrix.SetIdentity()
#If VORTEX_HANDEDNESS=VORTEX_LH
		mProjMatrix.SetOrthoLH(left, right, bottom, top, near, far)
#Else
		mProjMatrix.SetOrthoRH(left, right, bottom, top, near, far)
#End
	End

	Method SetClearColor:Void(r:Float, g:Float, b:Float)
		mRed = r
		mGreen = g
		mBlue = b
	End

	Method GetClearRed:Float()
		Return mRed
	End

	Method GetClearGreen:Float()
		Return mGreen
	End

	Method GetClearBlue:Float()
		Return mBlue
	End
	
	Method SetFog:Void(enable:Bool, minDist:Float = 0, maxDist:Float = 0, r:Float = 0, g:Float = 0, b:Float = 0)
		mFogEnabled = enable
		mFogMinDist = minDist
		mFogMaxDist = maxDist
		mFogRed = r
		mFogGreen = g
		mFogBlue = b
	End

	Method SetViewport:Void(x:Int, y:Int, w:Int, h:Int)
		mVX = x
		mVY = y
		mVWidth = w
		mVHeight = h
	End

	Method GetViewportX:Float()
		Return mVX
	End

	Method GetViewportY:Float()
		Return mVY
	End

	Method GetViewportWidth:Float()
		Return mVWidth
	End

	Method GetViewportHeight:Float()
		Return mVHeight
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

	Method Move:Void(x:Float, y:Float, z:Float)
		mTempVec.Set(x, y, z)
		mQuat.Mul(mTempVec)
		mPosition.Sum(Quat.ResultVector())
	End

	Method Prepare:Void()
		'Get view matrix
#If VORTEX_HANDEDNESS=VORTEX_LH
		'Calculate look direction
		mQuat.Mul(0, 0, 1)
		mViewMatrix.LookAtLH(GetX(), GetY(), GetZ(), GetX() + Quat.ResultVector().x, GetY() + Quat.ResultVector().y, GetZ() + Quat.ResultVector().z, 0, 1, 0)
#Elseif VORTEX_HANDEDNESS=VORTEX_RH_Y
		'Calculate look direction
		mQuat.Mul(0, 0, -1)
		mViewMatrix.LookAtRH(GetX(), GetY(), GetZ(), GetX() + Quat.ResultVector().x, GetY() + Quat.ResultVector().y, GetZ() + Quat.ResultVector().z, 0, 1, 0)
#Elseif VORTEX_HANDEDNESS=VORTEX_RH_Z
		'Calculate look direction
		mQuat.Mul(0, 1, 0)
		mViewMatrix.LookAtRH(GetX(), GetY(), GetZ(), GetX() + Quat.ResultVector().x, GetY() + Quat.ResultVector().y, GetZ() + Quat.ResultVector().z, 0, 0, 1)
#End

		'Setup for 3D rendering
		Renderer.Setup3D(mVX, mVY, mVWidth, mVHeight)

		'Setup matrices
		Renderer.SetProjectionMatrix(mProjMatrix)
		Renderer.SetViewMatrix(mViewMatrix)
		
		'Setup fog
		Renderer.SetFog(mFogEnabled, mFogMinDist, mFogMaxDist, mFogRed, mFogGreen, mFogBlue)

		'Clear buffers
		Renderer.ClearColorBuffer(mRed, mGreen, mBlue)
		Renderer.ClearDepthBuffer()
	End
Private
	Method New()
	End

	Field mProjMatrix	: Mat4
	Field mViewMatrix	: Mat4
	Field mRed			: Float
	Field mGreen		: Float
	Field mBlue			: Float
	Field mFogEnabled	: Bool
	Field mFogMinDist	: Float
	Field mFogMaxDist	: Float
	Field mFogRed		: Float
	Field mFogGreen		: Float
	Field mFogBlue		: Float
	Field mVX			: Int
	Field mVY			: Int
	Field mVWidth		: Int
	Field mVHeight		: Int
	Field mPosition		: Vec3
	Field mEuler		: Vec3
	Field mQuat			: Quat
	Global mTempVec		: Vec3 = Vec3.Create()
End
#end
