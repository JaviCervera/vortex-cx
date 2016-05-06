Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class BillboardsTest Extends Test Final
	Method New()
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
	End
	
	Method Init:Void()
		mEulerY = 0
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
		Renderer.ClearDepthBuffer()
	
		For Local i:Int = 0 Until mPositions.Length()
			mModels[i].SetBillboardTransform(mView, mPositions[i][0], 0, mPositions[i][1], 0, 1, 1)
		Next
		
		mNumRenderCalls = mBatch.Render()
	End
	
	Method GetNumRenderCalls:Int()
		Return mNumRenderCalls
	End
Private
	Field mProj				: Mat4
	Field mView				: Mat4
	Field mModels			: Mat4[]
	Field mPositions		: Float[][]
	Field mMaterials		: Material[]
	Field mBillboard		: Surface
	Field mBatch			: RenderBatch
	Field mEulerY			: Float
	Field mNumRenderCalls	: Int
End