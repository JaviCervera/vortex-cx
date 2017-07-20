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
		mRadius = 100
	End

	Field mEnabled		: Bool
	Field mX			: Float
	Field mY			: Float
	Field mZ			: Float
	Field mW			: Float
	Field mRed			: Float
	Field mGreen		: Float
	Field mBlue			: Float
	Field mRadius		: Float
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

	Function LightType:Int(index:Int)
		InitLights()
		Return mLights[index].mW
	End

	Function SetLightPosition:Void(index:Int, x:Float, y:Float, z:Float)
		InitLights()
		mLights[index].mX = x
		mLights[index].mY = y
		mLights[index].mZ = z
	End

	Function LightX:Float(index:Int)
		InitLights()
		Return mLights[index].mX
	End

	Function LightY:Float(index:Int)
		InitLights()
		Return mLights[index].mY
	End

	Function LightZ:Float(index:Int)
		InitLights()
		Return mLights[index].mZ
	End

	Function SetLightColor:Void(index:Int, r:Float, g:Float, b:Float)
		InitLights()
		mLights[index].mRed = r
		mLights[index].mGreen = g
		mLights[index].mBlue = b
	End

	Function LightRed:Float(index:Int)
		InitLights()
		Return mLights[index].mRed
	End

	Function LightGreen:Float(index:Int)
		InitLights()
		Return mLights[index].mGreen
	End

	Function LightBlue:Float(index:Int)
		InitLights()
		Return mLights[index].mBlue
	End

	Function SetLightRadius:Void(index:Int, radius:Float)
		InitLights()
		mLights[index].mRadius = radius
	End

	Function LightRadius:Float(index:Int)
		InitLights()
		Return mLights[index].mRadius
	End

	Function Prepare:Void(ambientRed:Float = 0.3, ambientGreen:Float = 0.3, ambientBlue:Float = 0.3, globalPixelLighting:Bool = False)
		InitLights()
		Renderer.SetLighting(True)
		Renderer.SetAmbient(ambientRed, ambientGreen, ambientBlue)
		For Local i:Int = 0 Until mLights.Length()
			Local light:LightData = mLights[i]
			Renderer.ViewMatrix().Mul(light.mX, light.mY, light.mZ, light.mW)
			Renderer.SetLight(i, light.mEnabled, Mat4.ResultVector().X, Mat4.ResultVector().Y, Mat4.ResultVector().Z, light.mW, light.mRed, light.mGreen, light.mBlue, light.mRadius)
		Next
		mGlobalPixelLighting = globalPixelLighting
	End
	
	Function GlobalPixelLightingEnabled:Bool()
		Return mGlobalPixelLighting
	End
Private
	Method New()
	End

	Function InitLights:Void()
		If mLights.Length() = 0 Then mLights = New LightData[Renderer.MaxLights()]
		If mLights[0] = Null
			For Local i:Int = 0 Until Renderer.MaxLights()
				mLights[i] = New LightData
			Next
		End
	End

	Global mLights				: LightData[]
	Global mGlobalPixelLighting	: Bool = False
End
