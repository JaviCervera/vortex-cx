Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class LightingTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer.Create(0, 0, DeviceWidth(), DeviceHeight())
		mViewer.SetClearColor(0, 0, 0)
		mViewer.SetPosition(0, 32, -90)
		mViewer.SetEuler(20, 0, 0)
		
		'Load sphere mesh
		Local sphere:Mesh = Cache.GetMesh("sphere.msh.xml")
		mSpheres = New Drawable[81]
		Local x:Int = -32, z:Int = -32
		For Local i:Int = 0 Until mSpheres.Length()
			mSpheres[i] = Drawable.Create(sphere)
			mSpheres[i].SetPosition(x, 0, z)
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
		mViewer.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mViewer.SetViewport(0, 0, DeviceWidth(), DeviceHeight())
		
		For Local i:Int = 0 Until mLightsEulerY.Length()
			mLightsEulerY[i] += 32 * deltaTime
			Lighting.SetLightPosition(i, 48 * Cos(mLightsEulerY[i]), 0, 48 * Sin(mLightsEulerY[i]))
		Next
	End
	
	Method Draw:Void()
		mViewer.Prepare()
		Lighting.Prepare(0, 0, 0)
		For Local sphere:Drawable = Eachin mSpheres
			sphere.Draw()
		Next
	End
Private
	Field mViewer			: Viewer
	Field mSpheres			: Drawable[]
	Field mLightsEulerY		: Float[3]
End
