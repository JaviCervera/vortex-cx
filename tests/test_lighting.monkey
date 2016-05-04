Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class LightingTest Extends Test Final
	Method New()
		'Create matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mModel = Mat4.Create()
		
		'Load sphere mesh
		mMesh = Cache.GetMesh("sphere.msh.xml")
		
		'Create sphere positions
		mPositions = New Vec3[81]
		Local x:Int = -32, z:Int = -32
		For Local i:Int = 0 Until mPositions.Length()
			mPositions[i] = Vec3.Create(x, 0, z)
			x += 8; If x > 32 Then x = -32; z += 8
		Next
		
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
		mProj.SetPerspectiveLH(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mView.LookAtLH(0, 32, -90, 0, 0, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Lighting.Prepare(0, 0, 0)
		Renderer.ClearColorBuffer(0, 0, 0)
	
		For Local i:Int = 0 Until mPositions.Length()
			mModel.SetTransform(mPositions[i].x, mPositions[i].y, mPositions[i].z, 0, 0, 0, 1, 1, 1)
			Renderer.SetModelMatrix(mModel)
			mMesh.Draw()
		Next
	End
Private
	Field mProj			: Mat4
	Field mView			: Mat4
	Field mModel		: Mat4
	Field mPositions	: Vec3[]
	Field mMesh			: Mesh
	Field mLightsEulerY	: Float[3]
End
