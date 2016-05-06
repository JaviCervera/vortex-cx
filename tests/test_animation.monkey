Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class AnimationTest Extends Test Final
	Method New()
		'Create matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mModel = Mat4.Create()
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Load font
		mFont = Cache.GetFont("system_16.fnt.xml")
		
		'Load anim model, create matrices for animation data, and add mesh to RenderBatch
		mAnimMesh = Cache.GetMesh("dwarf.msh.xml")
		mAnimMatrices = New Mat4[mAnimMesh.GetNumBones()]
		For Local i:Int = 0 Until mAnimMatrices.Length()
			mAnimMatrices[i] = Mat4.Create()
		Next
		mBatch.AddMesh(mAnimMesh, mModel, mAnimMatrices)
	End
	
	Method Init:Void()
		mCurrentFrame = 0
	End
	
	Method Update:Void(deltaTime:Float)
		mCurrentFrame += 16 * deltaTime
		If mCurrentFrame > mAnimMesh.GetLastFrame()+1 Then mCurrentFrame = mCurrentFrame - Int(mCurrentFrame)
		mAnimMesh.Animate(mAnimMatrices, mCurrentFrame)
	End
	
	Method Draw:Void()
		mProj.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAt(0, 64, -128, 0, 32, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.SetModelMatrix(mModel)
		Renderer.ClearColorBuffer(1, 1, 1)
		Renderer.ClearDepthBuffer()
		'mAnimMesh.Draw(mAnimMatrices)
		mNumRenderCalls = mBatch.Render()
		
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetColor(0, 0, 0)
		mFont.Draw(4, DeviceHeight() - 20, "Frame: " + Int(mCurrentFrame))
	End
	
	Method GetNumRenderCalls:Int()
		Return mNumRenderCalls
	End
Private
	Field mProj				: Mat4
	Field mView				: Mat4
	Field mModel			: Mat4
	Field mFont				: Font
	Field mAnimMesh			: Mesh
	Field mAnimMatrices		: Mat4[]
	Field mCurrentFrame		: Float
	Field mBatch			: RenderBatch
	Field mNumRenderCalls	: Int
End
