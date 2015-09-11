Strict

Private
Import vortex.core.math3d
Import vortex.core.renderer

Public
Class Viewer Final
Public
	Function Create:Viewer(vx%, vy%, vw%, vh%)
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
	
	Method SetPerspective:Void(fovy#, ratio#, near#, far#)
		mProjMatrix.SetIdentity()
		mProjMatrix.SetPerspective(fovy, ratio, near, far)
	End
	
	Method SetFrustum:Void(left#, right#, bottom#, top#, near#, far#)
		mProjMatrix.SetIdentity()
		mProjMatrix.SetFrustum(left, right, bottom, top, near, far)
	End
	
	Method SetOrtho:Void(left#, right#, bottom#, top#, near#, far#)
		mProjMatrix.SetIdentity()
		mProjMatrix.SetOrtho(left, right, bottom, top, near, far)
	End
	
	Method SetClearColor:Void(r#, g#, b#)
		mRed = r
		mGreen = g
		mBlue = b
	End
	
	Method GetClearRed#()
		Return mRed
	End
	
	Method GetClearGreen#()
		Return mGreen
	End
	
	Method GetClearBlue#()
		Return mBlue
	End
	
	Method SetViewport:Void(x%, y%, w%, h%)
		mVX = x
		mVY = y
		mVWidth = w
		mVHeight = h
	End
	
	Method GetViewportX#()
		Return mVX
	End
	
	Method GetViewportY#()
		Return mVY
	End
	
	Method GetViewportWidth#()
		Return mVWidth
	End
	
	Method GetViewportHeight#()
		Return mVHeight
	End
	
	Method SetPosition:Void(x#, y#, z#)
		mPosition.Set(x, y, z)
	End
	
	Method GetX#()
		Return mPosition.x
	End
	
	Method GetY#()
		Return mPosition.y
	End
	
	Method GetZ#()
		Return mPosition.z
	End
	
	Method SetEuler:Void(x#, y#, z#)
		mEuler.Set(x, y, z)
		mQuat.SetEuler(x, y, z)
	End
	
	Method GetEulerX#()
		Return mEuler.x
	End
	
	Method GetEulerY#()
		Return mEuler.y
	End
	
	Method GetEulerZ#()
		Return mEuler.z
	End
	
	Method SetQuat:Void(w#, x#, y#, z#)
		mQuat.Set(w, x, y, z)
		mQuat.CalcEuler()
		mEuler.Set(mQuat.ResultVector())
	End
	
	Method GetQuatW#()
		Return mQuat.w
	End
	
	Method GetQuatX#()
		Return mQuat.x
	End
	
	Method GetQuatY#()
		Return mQuat.y
	End
	
	Method GetQuatZ#()
		Return mQuat.z
	End
	
	Method Move:Void(x#, y#, z#)
		mTempVec.Set(x, y, z)
		mQuat.Mul(mTempVec)
		mPosition.Sum(Quat.ResultVector())
	End
	
	Method Prepare:Void()
		'Calculate look direction
		mQuat.Mul(0, 1, 0)
		
		'Get view matrix
		mViewMatrix.LookAt(GetX(), GetY(), GetZ(), GetX() + Quat.ResultVector().x, GetY() + Quat.ResultVector().y, GetZ() + Quat.ResultVector().z, 0, 0, 1)
		
		'Setup for 3D rendering
		Renderer.Setup3D(mVX, mVY, mVWidth, mVHeight)
		
		'Setup matrices
		Renderer.SetProjectionMatrix(mProjMatrix)
		Renderer.SetViewMatrix(mViewMatrix)
		
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
	Field mVX			: Int
	Field mVY			: Int
	Field mVWidth		: Int
	Field mVHeight		: Int
	Field mPosition		: Vec3
	Field mEuler		: Vec3
	Field mQuat			: Quat
	Global mTempVec		: Vec3 = Vec3.Create()
End
