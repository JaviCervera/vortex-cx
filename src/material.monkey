Strict

Private
Import vortex.src.lighting
Import vortex.src.renderer
Import vortex.src.texture

Public
Class Material Final
Public
	Function Create:Material(diffuseTex:Texture = Null)
		Local mat:Material = New Material
		mat.mDiffuseRed = 1
		mat.mDiffuseGreen = 1
		mat.mDiffuseBlue = 1
		mat.mDiffuseTex = diffuseTex
		mat.mOpacity = 1
		mat.mShininess = 0
		mat.mRefractCoef = 1
		mat.mBlendMode = Renderer.BLEND_ALPHA
		mat.mCulling = True
		mat.mDepthWrite = True
		Return mat
	End
	
	Method IsEqual:Bool(other:Material)
		If Self = other Then Return True
		If mDiffuseRed = other.mDiffuseRed And mDiffuseGreen = other.mDiffuseGreen And mDiffuseBlue = other.mDiffuseBlue And mDiffuseTex = other.mDiffuseTex And mNormalTex = other.mNormalTex And mReflectTex = other.mReflectTex And mRefractTex = other.mRefractTex And mOpacity = other.mOpacity And mShininess = other.mShininess And mRefractCoef = other.mRefractCoef And mBlendMode = other.mBlendMode And mCulling = other.mCulling And mDepthWrite = other.mDepthWrite
			Return True
		Else
			Return False
		End
	End

	Method Set:Void(other:Material)
		If Self.IsEqual(other) Then Return
		mDiffuseRed = other.mDiffuseRed
		mDiffuseGreen = other.mDiffuseGreen
		mDiffuseBlue = other.mDiffuseBlue
		mDiffuseTex = other.mDiffuseTex
		mNormalTex = other.mNormalTex
		mLightmap = other.mLightmap
		mReflectTex = other.mReflectTex
		mRefractTex = other.mRefractTex
		mOpacity = other.mOpacity
		mShininess = other.mShininess
		mRefractCoef = other.mRefractCoef
		mBlendMode = other.mBlendMode
		mCulling = other.mCulling
		mDepthWrite = other.mDepthWrite
	End

	Method SetDiffuseColor:Void(r:Float, g:Float, b:Float)
		mDiffuseRed = r
		mDiffuseGreen = g
		mDiffuseBlue = b
	End
	
	Method DiffuseRed:Void(red:Float) Property
		mDiffuseRed = red
	End

	Method DiffuseRed:Float() Property
		Return mDiffuseRed
	End
	
	Method DiffuseGreen:Void(green:Float) Property
		mDiffuseGreen = green
	End

	Method DiffuseGreen:Float() Property
		Return mDiffuseGreen
	End
	
	Method DiffuseBlue:Void(blue:Float) Property
		mDiffuseBlue = blue
	End

	Method DiffuseBlue:Float() Property
		Return mDiffuseBlue
	End
	
	Method DiffuseTexture:Void(tex:Texture) Property
		mDiffuseTex = tex
	End

	Method DiffuseTexture:Texture() Property
		Return mDiffuseTex
	End
	
	Method NormalTexture:Void(tex:Texture) Property
		mNormalTex = tex
	End
	
	Method NormalTexture:Texture() Property
		Return mNormalTex
	End
	
	Method Lightmap:Void(tex:Texture) Property
		mLightmap = tex
	End
	
	Method Lightmap:Texture() Property
		Return mLightmap
	End
	
	Method ReflectionTexture:Void(tex:Texture) Property
		mReflectTex = tex
	End
	
	Method ReflectionTexture:Texture() Property
		Return mReflectTex
	End
	
	Method RefractionTexture:Void(tex:Texture) Property
		mRefractTex = tex
	End
	
	Method RefractionTexture:Texture() Property
		Return mRefractTex
	End

	Method Opacity:Void(opacity:Float) Property
		mOpacity = opacity
	End

	Method Opacity:Float() Property
		Return mOpacity
	End

	Method Shininess:Void(shininess:Float) Property
		mShininess = shininess
	End

	Method Shininess:Float() Property
		Return mShininess
	End
	
	Method RefractionCoef:Void(coef:Float) Property
		mRefractCoef = coef
	End
	
	Method RefractionCoef:Float() Property
		Return mRefractCoef
	End

	Method BlendMode:Void(mode:Int) Property
		mBlendMode = mode
	End

	Method BlendMode:Int() Property
		Return mBlendMode
	End

	Method Culling:Void(enable:Bool) Property
		mCulling = enable
	End

	Method Culling:Bool() Property
		Return mCulling
	End

	Method DepthWrite:Void(enable:Bool) Property
		mDepthWrite = enable
	End

	Method DepthWrite:Bool() Property
		Return mDepthWrite
	End

	Method Prepare:Void()
		Local diffuseHandle:Int = 0
		Local normalHandle:Int = 0
		Local reflectHandle:Int = 0
		Local refractHandle:Int = 0
		Local shininess:Int = 0
		If mShininess > 0 Then shininess = Int(mShininess * 128)
		Renderer.SetColor(mDiffuseRed, mDiffuseGreen, mDiffuseBlue, mOpacity)
		Renderer.SetShininess(shininess)
		Renderer.SetRefractCoef(mRefractCoef)
		Renderer.SetBlendMode(mBlendMode)
		Renderer.SetCulling(mCulling)
		Renderer.SetDepthWrite(mDepthWrite)
		If mDiffuseTex <> Null Then diffuseHandle = mDiffuseTex.Handle
		If mNormalTex <> Null Then normalHandle = mNormalTex.Handle
		If mReflectTex <> Null Then reflectHandle = mReflectTex.Handle
		If mRefractTex <> Null Then refractHandle = mRefractTex.Handle
		Renderer.SetTextures(diffuseHandle, normalHandle, reflectHandle, refractHandle, mDiffuseTex And mDiffuseTex.Cubic)
		Renderer.SetPixelLighting(Lighting.GetGlobalPixelLighting())
	End
Private
	Method New()
	End

	Field mDiffuseRed	: Float
	Field mDiffuseGreen	: Float
	Field mDiffuseBlue	: Float
	Field mDiffuseTex	: Texture
	Field mNormalTex	: Texture
	Field mLightmap		: Texture
	Field mReflectTex	: Texture
	Field mRefractTex	: Texture
	Field mOpacity		: Float
	Field mShininess	: Float
	Field mRefractCoef	: Float
	Field mBlendMode	: Int
	Field mCulling		: Bool
	Field mDepthWrite	: Bool
End
