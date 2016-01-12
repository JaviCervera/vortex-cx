Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class LightingTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer_Create(0, 0, DeviceWidth(), DeviceHeight())
		Viewer_SetClearColor(mViewer, 0, 0, 0)
		Viewer_SetPosition(mViewer, 0, 32, -90)
		Viewer_SetEuler(mViewer, 20, 0, 0)
		
		'Load sphere mesh
		Local sphere:Object = Mesh_Cache("sphere.msh.xml")
		mSpheres = New Object[81]
		Local x:Int = -32, z:Int = -32
		For Local i:Int = 0 Until mSpheres.Length()
			mSpheres[i] = Drawable_CreateWithMesh(sphere)
			Drawable_SetPosition(mSpheres[i], x, 0, z)
			x += 8; If x > 32 Then x = -32; z += 8
		Next
		
		'Prepare lights
		Lighting_SetLightEnabled(0, True)
		Lighting_SetLightEnabled(1, True)
		Lighting_SetLightEnabled(2, True)
		Lighting_SetLightType(0, LIGHT_POINT)
		Lighting_SetLightType(1, LIGHT_POINT)
		Lighting_SetLightType(2, LIGHT_POINT)
		Lighting_SetLightAttenuation(0, 0.05)
		Lighting_SetLightAttenuation(1, 0.05)
		Lighting_SetLightAttenuation(2, 0.05)
		Lighting_SetLightColor(0, 1, 0, 0)
		Lighting_SetLightColor(1, 0, 1, 0)
		Lighting_SetLightColor(2, 0, 0, 1)
		mLightsEulerY[0] = 0
		mLightsEulerY[1] = 120
		mLightsEulerY[2] = 240
	End
	
	Method Update:Void(deltaTime:Float)
		Viewer_SetPerspective(mViewer, 45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		Viewer_SetViewport(mViewer, 0, 0, DeviceWidth(), DeviceHeight())
		
		For Local i:Int = 0 Until mLightsEulerY.Length()
			mLightsEulerY[i] += 32 * deltaTime
			Lighting_SetLightPosition(i, 48 * Cos(mLightsEulerY[i]), 0, 48 * Sin(mLightsEulerY[i]))
		Next
	End
	
	Method Draw:Void()
		Viewer_Prepare(mViewer)
		Lighting_Prepare(0, 0, 0)
		For Local sphere:Object = Eachin mSpheres
			Drawable_Draw(sphere)
		Next
	End
Private
	Field mViewer			: Object
	Field mSpheres			: Object[]
	Field mLightsEulerY		: Float[3]
End
