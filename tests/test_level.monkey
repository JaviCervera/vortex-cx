Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class LevelTest Extends Test Final
	Method New()
		'Create matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mModel = Mat4.Create()
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Load level
		mLevel = Cache.GetMesh("simple-dm5.msh.xml")
		mBatch.AddMesh(mLevel, mModel)
	End
	
	Method Init:Void()
		mEulerY = 0
	End
	
	Method Update:Void(deltaTime:Float)
		mEulerY -= 32 * deltaTime
	End
	
	Method Draw:Void()
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAtLH(0, 100, 0, 0, 100, 100, 0, 1, 0)
		mModel.SetTransform(0, 0, 0, 0, mEulerY, 0, 1, 1, 1)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.SetModelMatrix(mModel)
		Renderer.ClearColorBuffer(0, 0, 0)
		Renderer.ClearDepthBuffer()
		Renderer.SetFog(True, 600, 1000, 0, 0, 0)
		mNumRenderCalls = mBatch.Render()
	End
	
	Method GetNumRenderCalls:Int()
		Return mNumRenderCalls
	End
Private
	Field mProj				: Mat4
	Field mView				: Mat4
	Field mModel			: Mat4
	Field mLevel			: Mesh
	Field mBatch			: RenderBatch
	Field mEulerY			: Float
	Field mNumRenderCalls	: Int
End
