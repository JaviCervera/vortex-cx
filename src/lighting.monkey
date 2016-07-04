Strict

Private
Import vortex.src.math3d
Import vortex.src.renderer

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
	Const DIRECTIONAL	: Int = 0
	Const POINT			: Int = 1

	Function SetLightEnabled:Void(index:Int, enabled:Bool)
		InitLights()
		mLights[index].mEnabled = enabled
	End

	Function IsLightEnabled:Bool(index:Int)
		InitLights()
		Return mLights[index].mEnabled
	End

	Function SetLightType:Void(index:Int, type:Int)
		InitLights()
		If type = DIRECTIONAL Or type = POINT Then mLights[index].mW = type
	End

	Function GetLightType:Int(index:Int)
		InitLights()
		Return mLights[index].mW
	End

	Function SetLightPosition:Void(index:Int, x:Float, y:Float, z:Float)
		InitLights()
		mLights[index].mX = x
		mLights[index].mY = y
		mLights[index].mZ = z
	End

	Function GetLightX:Float(index:Int)
		InitLights()
		Return mLights[index].mX
	End

	Function GetLightY:Float(index:Int)
		InitLights()
		Return mLights[index].mY
	End

	Function GetLightZ:Float(index:Int)
		InitLights()
		Return mLights[index].mZ
	End

	Function SetLightColor:Void(index:Int, r:Float, g:Float, b:Float)
		InitLights()
		mLights[index].mRed = r
		mLights[index].mGreen = g
		mLights[index].mBlue = b
	End

	Function GetLightRed:Float(index:Int)
		InitLights()
		Return mLights[index].mRed
	End

	Function GetLightGreen:Float(index:Int)
		InitLights()
		Return mLights[index].mGreen
	End

	Function GetLightBlue:Float(index:Int)
		InitLights()
		Return mLights[index].mBlue
	End

	Function SetLightAttenuation:Void(index:Int, att:Float)
		InitLights()
		mLights[index].mAttenuation = att
	End

	Function GetLightAttenuation:Float(index:Int)
		InitLights()
		Return mLights[index].mAttenuation
	End

	Function Prepare:Void(ambientRed:Float = 0.3, ambientGreen:Float = 0.3, ambientBlue:Float = 0.3, globalPixelLighting:Bool = False)
		InitLights()
		Renderer.SetLighting(True)
		Renderer.SetAmbient(ambientRed, ambientGreen, ambientBlue)
		For Local i% = 0 Until mLights.Length()
			Local light:LightData = mLights[i]
			Renderer.GetViewMatrix().Mul(light.mX, light.mY, light.mZ, light.mW)
			Renderer.SetLight(i, light.mEnabled, Mat4.ResultVector().X, Mat4.ResultVector().Y, Mat4.ResultVector().Z, light.mW, light.mRed, light.mGreen, light.mBlue, light.mAttenuation)
		Next
		mGlobalPixelLighting = globalPixelLighting
	End
	
	Function GetGlobalPixelLighting:Bool()
		Return mGlobalPixelLighting
	End
Private
	Method New()
	End

	Function InitLights:Void()
		If mLights.Length() = 0 Then mLights = New LightData[Renderer.GetMaxLights()]
		If mLights[0] = Null
			For Local i:Int = 0 Until Renderer.GetMaxLights()
				mLights[i] = New LightData
			Next
		End
	End

	Global mLights				: LightData[]
	Global mGlobalPixelLighting	: Bool = False
End
