Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class BillboardsTest Extends Test Final
	Method New()
		'Create matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mModel = Mat4.Create()
		
		'Create billboard surface
		mSurface = Surface.Create(Brush.Create(Cache.GetTexture("smile.png")))

		'Add vertices and indices
		Local x0# = -0.5
		Local x1# =  0.5
		Local z0# = -0.5
		Local z1# =  0.5
		mSurface.AddTriangle(0, 1, 2)
		mSurface.AddTriangle(2, 1, 3)
		mSurface.AddVertex(x0, z1, 0, 0, 0, -1, 1, 1, 1, 1, 0, 0)
		mSurface.AddVertex(x1, z1, 0, 0, 0, -1, 1, 1, 1, 1, 1, 0)
		mSurface.AddVertex(x0, z0, 0, 0, 0, -1, 1, 1, 1, 1, 0, 1)
		mSurface.AddVertex(x1, z0, 0, 0, 0, -1, 1, 1, 1, 1, 1, 1)
		mSurface.Rebuild()
		
		'Create billboard colors and positions
		mPositions = New Vec3[64]
		mColors = New Vec3[64]
		Local x:Int = -8, z:Int = -8
		For Local i:Int = 0 Until mPositions.Length()
			mPositions[i] = Vec3.Create(x, 0, z)
			mColors[i] = Vec3.Create(Rnd(0, 1), Rnd(0, 1), Rnd(0, 1))
			x += 2; If x >= 8 Then x = -8; z += 2
		Next
	End
	
	Method Update:Void(deltaTime:Float)
		mEulerY += 32 * deltaTime
	End
	
	Method Draw:Void()
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 100)
		mView.LookAtLH(Cos(mEulerY) * 8, Sin(45) * 8, Sin(mEulerY) * 8, 0, 0, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.ClearColorBuffer(1, 1, 1)
	
		For Local i:Int = 0 Until mPositions.Length()
			mModel.SetBillboardTransform(mView, mPositions[i].x, mPositions[i].y, mPositions[i].z, 0, 1, 1)
			Renderer.SetModelMatrix(mModel)
			mSurface.GetBrush().SetBaseColor(mColors[i].x, mColors[i].y, mColors[i].z)
			mSurface.Draw()
		Next
	End
Private
	Field mProj			: Mat4
	Field mView			: Mat4
	Field mModel		: Mat4
	Field mPositions	: Vec3[]
	Field mColors		: Vec3[]
	Field mSurface		: Surface
	Field mEulerY		: Float
End