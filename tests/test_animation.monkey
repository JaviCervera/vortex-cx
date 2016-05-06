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
		mSwatModel = Mat4.Create()
		mDwarfModel = Mat4.Create()
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Load font
		mFont = Cache.GetFont("system_16.fnt.xml")
		
		'Load SWAT model, create matrices for animation data, and add mesh to RenderBatch
		mSwatMesh = Cache.GetMesh("swat.msh.xml")
		mSwatAnimMatrices = New Mat4[mSwatMesh.GetNumBones()]
		For Local i:Int = 0 Until mSwatAnimMatrices.Length()
			mSwatAnimMatrices[i] = Mat4.Create()
		Next
		mSwatModel.SetTransform(-32, 0, 0, 0, -15, 0, 35, 35, 35)
		mBatch.AddMesh(mSwatMesh, mSwatModel, mSwatAnimMatrices)
		
		'Load dwarf model, create matrices for animation data, and add mesh to RenderBatch
		mDwarfMesh = Cache.GetMesh("dwarf.msh.xml")
		mDwarfAnimMatrices = New Mat4[mDwarfMesh.GetNumBones()]
		For Local i:Int = 0 Until mDwarfAnimMatrices.Length()
			mDwarfAnimMatrices[i] = Mat4.Create()
		Next
		mDwarfModel.SetTransform(32, 0, 0, 0, 15, 0, 1, 1, 1)
		mBatch.AddMesh(mDwarfMesh, mDwarfModel, mDwarfAnimMatrices)
	End
	
	Method Init:Void()
		mSwatCurrentFrame = 0
		mDwarfCurrentFrame = 0
	End
	
	Method Update:Void(deltaTime:Float)
		mSwatCurrentFrame += 16 * deltaTime
		If mSwatCurrentFrame > mSwatMesh.GetLastFrame()+1 Then mSwatCurrentFrame = mSwatCurrentFrame - Int(mSwatCurrentFrame)
		mSwatMesh.Animate(mSwatAnimMatrices, mSwatCurrentFrame)
	
		mDwarfCurrentFrame += 16 * deltaTime
		If mDwarfCurrentFrame > mDwarfMesh.GetLastFrame()+1 Then mDwarfCurrentFrame = mDwarfCurrentFrame - Int(mDwarfCurrentFrame)
		mDwarfMesh.Animate(mDwarfAnimMatrices, mDwarfCurrentFrame)
	End
	
	Method Draw:Void()
		mProj.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAt(0, 64, -128, 0, 32, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.SetModelMatrix(mDwarfModel)
		Renderer.ClearColorBuffer(1, 1, 1)
		Renderer.ClearDepthBuffer()
		mNumRenderCalls = mBatch.Render()
		
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetColor(0, 0, 0)
		mFont.Draw(4, DeviceHeight() - 20, "Frame: " + Int(mDwarfCurrentFrame))
	End
	
	Method GetNumRenderCalls:Int()
		Return mNumRenderCalls
	End
Private
	Field mFont					: Font
	Field mProj					: Mat4
	Field mView					: Mat4
	Field mSwatModel			: Mat4
	Field mDwarfModel			: Mat4
	Field mSwatMesh				: Mesh
	Field mDwarfMesh			: Mesh
	Field mSwatAnimMatrices		: Mat4[]
	Field mDwarfAnimMatrices	: Mat4[]
	Field mSwatCurrentFrame		: Float
	Field mDwarfCurrentFrame	: Float
	Field mBatch				: RenderBatch
	Field mNumRenderCalls		: Int
End
