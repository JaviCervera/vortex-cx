Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class LightingTest Extends Test Final
	Method New()
		'Create projection and view matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Load sphere mesh
		mMesh = Cache.GetMesh("sphere.msh.xml")
		
		'Create sphere model matrices and add to RenderBatch
		mModels = New Mat4[81]
		Local x:Int = -32, z:Int = -32
		For Local i:Int = 0 Until mModels.Length()
			mModels[i] = Mat4.Create()
			mModels[i].SetTransform(x, 0, z, 0, 0, 0, 1, 1, 1)
			x += 8; If x > 32 Then x = -32; z += 8
			mBatch.AddMesh(mMesh, mModels[i])
		Next
	End
	
	Method Init:Void()
		'Prepare lights
		Lighting.SetLightEnabled(0, True)
		Lighting.SetLightEnabled(1, True)
		Lighting.SetLightEnabled(2, True)
		Lighting.SetLightType(0, Lighting.POINT)
		Lighting.SetLightType(1, Lighting.POINT)
		Lighting.SetLightType(2, Lighting.POINT)
		Lighting.SetLightAttenuation(0, 0.05)
		Lighting.SetLightAttenuation(1, 0.05)
		Lighting.SetLightAttenuation(2, 0.05)
		Lighting.SetLightColor(0, 1, 0, 0)
		Lighting.SetLightColor(1, 0, 1, 0)
		Lighting.SetLightColor(2, 0, 0, 1)
		mLightsEulerY[0] = 0
		mLightsEulerY[1] = 120
		mLightsEulerY[2] = 240
	End
	
	Method Update:Void(deltaTime:Float)
		For Local i:Int = 0 Until mLightsEulerY.Length()
			mLightsEulerY[i] += 32 * deltaTime
			Lighting.SetLightPosition(i, 48 * Cos(mLightsEulerY[i]), 0, 48 * Sin(mLightsEulerY[i]))
		Next
	End
	
	Method Draw:Void()
		mProj.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAt(0, 32, -90, 0, 0, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Lighting.Prepare(0, 0, 0)
		Renderer.ClearColorBuffer(0, 0, 0)
		Renderer.ClearDepthBuffer()
	
		mNumRenderCalls = mBatch.Render()
	End
	
	Method Finish:Void()
		Lighting.SetLightEnabled(0, False)
		Lighting.SetLightEnabled(1, False)
		Lighting.SetLightEnabled(2, False)
	End
	
	Method GetNumRenderCalls:Int()
		Return mNumRenderCalls
	End
Private
	Field mProj				: Mat4
	Field mView				: Mat4
	Field mModels			: Mat4[]
	Field mMesh				: Mesh
	Field mBatch			: RenderBatch
	Field mLightsEulerY		: Float[3]
	Field mNumRenderCalls	: Int
End
