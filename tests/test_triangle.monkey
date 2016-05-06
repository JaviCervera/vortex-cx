Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class TriangleTest Extends Test Final
	Method New()
		'Create matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mModel = Mat4.Create()
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Create triangle
		mTri = Surface.Create()
		mTri.GetMaterial().SetCulling(False)
		mTri.AddTriangle(0, 1, 2)
		mTri.AddVertex(0,0.5,0,     0,0,-1, 1,0,0,1, 0,0)
		mTri.AddVertex(0.5,-0.5,0,  0,0,-1, 0,1,0,1, 0,0)
		mTri.AddVertex(-0.5,-0.5,0, 0,0,-1, 0,0,1,1, 0,0)
		mTri.Rebuild()
		
		'Add triangle to RenderBatch
		mBatch.AddSurface(mTri, mModel)
	End
	
	Method Init:Void()
		mEulerY = 0
	End
	
	Method Update:Void(deltaTime:Float)
		mEulerY += 64 * deltaTime
	End
	
	Method Draw:Void()
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 10)
		mView.LookAtLH(0, 0, -4, 0, 0, 0, 0, 1, 0)
		mModel.SetTransform(0, 0, 0, 0, mEulerY, 0, 1, 1, 1)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.ClearColorBuffer(1, 1, 1)
		Renderer.ClearDepthBuffer()
		mNumRenderCalls = mBatch.Render()
	End
	
	Method GetNumRenderCalls:Int()
		Return mNumRenderCalls
	End
Private
	Field mProj				: Mat4
	Field mView				: Mat4
	Field mModel			: Mat4
	Field mTri				: Surface
	Field mBatch			: RenderBatch
	Field mEulerY			: Float
	Field mNumRenderCalls	: Int
End