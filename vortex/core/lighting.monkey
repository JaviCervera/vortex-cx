Strict

Private
Import vortex.core.math3d
Import vortex.core.renderer

Class LightData Final
	Method New()
		mEnabled = False
		mX = 0
		mY = 0
		mZ = 0
		mW = 0
		mRed = 1
		mGreen = 1
		mBlue = 1
		mAttenuation = 0
	End

	Field mEnabled		: Bool
	Field mX			: Float
	Field mY			: Float
	Field mZ			: Float
	Field mW			: Float
	Field mRed			: Float
	Field mGreen		: Float
	Field mBlue			: Float
	Field mAttenuation	: Float
End

Public
Class Lighting Final
Public
	Const NUM_LIGHTS%			= Renderer.MAX_LIGHTS
	Const DIRECTIONAL%	= 0
	Const POINT%			= 1
	
	Function SetLightEnabled:Void(index%, enabled:Bool)
		InitLights()
		mLights[index].mEnabled = enabled
	End
	
	Function IsLightEnabled:Bool(index%)
		InitLights()
		Return mLights[index].mEnabled
	End
	
	Function SetLightType:Void(index%, type%)
		InitLights()
		If type = DIRECTIONAL Or type = POINT Then mLights[index].mW = type
	End
	
	Function GetLightType%(index%)
		InitLights()
		Return mLights[index].mW
	End
	
	Function SetLightPosition:Void(index%, x#, y#, z#)
		InitLights()
		mLights[index].mX = x
		mLights[index].mY = y
		mLights[index].mZ = z
	End
	
	Function GetLightX#(index%)
		InitLights()
		Return mLights[index].mX
	End
	
	Function GetLightY#(index%)
		InitLights()
		Return mLights[index].mY
	End
	
	Function GetLightZ#(index%)
		InitLights()
		Return mLights[index].mZ
	End
	
	Function SetLightColor:Void(index%, r#, g#, b#)
		InitLights()
		mLights[index].mRed = r
		mLights[index].mGreen = g
		mLights[index].mBlue = b
	End
	
	Function GetLightRed#(index%)
		InitLights()
		Return mLights[index].mRed
	End
	
	Function GetLightGreen#(index%)
		InitLights()
		Return mLights[index].mGreen
	End
	
	Function GetLightBlue#(index%)
		InitLights()
		Return mLights[index].mBlue
	End
	
	Function SetLightAttenuation:Void(index%, att#)
		InitLights()
		mLights[index].mAttenuation = att
	End
	
	Function GetLightAttenuation#(index%)
		InitLights()
		Return mLights[index].mAttenuation
	End
	
	Function Prepare:Void(ambientRed# = 0.3, ambientGreen# = 0.3, ambientBlue# = 0.3)
		InitLights()
		Renderer.SetLighting(True)
		Renderer.SetAmbient(ambientRed, ambientGreen, ambientBlue)
		For Local i% = 0 Until mLights.Length()
			Local light:LightData = mLights[i]
			Renderer.GetViewMatrix().Mul(light.mX, light.mY, light.mZ, light.mW)
			Renderer.SetLight(i, light.mEnabled, Mat4.ResultVector().x, Mat4.ResultVector().y, Mat4.ResultVector().z, light.mW, light.mRed, light.mGreen, light.mBlue, light.mAttenuation)
		Next
	End
Private
	Method New()
	End
	
	Function InitLights:Void()
		If mLights[0] = Null
			For Local i% = 0 Until NUM_LIGHTS
				mLights[i] = New LightData
			Next
		End
	End
	
	Global mLights	: LightData[NUM_LIGHTS]
End
