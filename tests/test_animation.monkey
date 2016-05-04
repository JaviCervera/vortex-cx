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
		
		'Load font
		mFont = Cache.GetFont("system_16.fnt.xml")
		
		'Load anim model and create matrices for animation data
		mAnimMesh = Cache.GetMesh("dwarf.msh.xml")
		mAnimMatrices = New Mat4[mAnimMesh.GetNumBones()]
		For Local i:Int = 0 Until mAnimMatrices.Length()
			mAnimMatrices[i] = Mat4.Create()
		Next
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
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAtLH(0, 64, -128, 0, 32, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.SetModelMatrix(mModel)
		Renderer.ClearColorBuffer(1, 1, 1)
		mAnimMesh.Draw(mAnimMatrices)
		
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetColor(0, 0, 0)
		mFont.Draw(4, DeviceHeight() - 20, "Frame: " + Int(mCurrentFrame))
	End
Private
	Field mProj			: Mat4
	Field mView			: Mat4
	Field mModel		: Mat4
	Field mFont			: Font
	Field mAnimMesh		: Mesh
	Field mAnimMatrices	: Mat4[]
	Field mCurrentFrame	: Float
End
