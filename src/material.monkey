Strict

Private
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
		mat.mAlpha = 1
		mat.mShininess = 0
		mat.mDiffuseTex = diffuseTex
		mat.mBlendMode = Renderer.BLEND_ALPHA
		mat.mCulling = True
		mat.mDepthWrite = True
		Return mat
	End
	
	Method IsEqual:Bool(other:Material)
		If Self = other Then Return True
		If mDiffuseRed = other.mDiffuseRed And mDiffuseGreen = other.mDiffuseGreen And mDiffuseBlue = other.mDiffuseBlue And mAlpha = other.mAlpha And mShininess = other.mShininess And mDiffuseTex = other.mDiffuseTex And mBlendMode = other.mBlendMode And mCulling = other.mCulling And mDepthWrite = other.mDepthWrite
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
		mAlpha = other.mAlpha
		mDiffuseTex = other.mDiffuseTex
		mBlendMode = other.mBlendMode
		mShininess = other.mShininess
		mCulling = other.mCulling
		mDepthWrite = other.mDepthWrite
	End

	Method SetDiffuseColor:Void(r:Float, g:Float, b:Float)
		mDiffuseRed = r
		mDiffuseGreen = g
		mDiffuseBlue = b
	End

	Method GetDiffuseRed:Float()
		Return mDiffuseRed
	End

	Method GetDiffuseGreen:Float()
		Return mDiffuseGreen
	End

	Method GetDiffuseBlue:Float()
		Return mDiffuseBlue
	End

	Method SetAlpha:Void(alpha:Float)
		mAlpha = alpha
	End

	Method GetAlpha:Float()
		Return mAlpha
	End

	Method SetShininess:Void(shininess:Float)
		mShininess = shininess
	End

	Method GetShininess:Float()
		Return mShininess
	End

	Method SetDiffuseTexture:Void(tex:Texture)
		mDiffuseTex = tex
	End

	Method GetDiffuseTexture:Texture()
		Return mDiffuseTex
	End

	Method SetBlendMode:Void(mode:Int)
		mBlendMode = mode
	End

	Method GetBlendMode:Int()
		Return mBlendMode
	End

	Method SetCulling:Void(enable:Bool)
		mCulling = enable
	End

	Method GetCulling:Bool()
		Return mCulling
	End

	Method SetDepthWrite:Void(enable:Bool)
		mDepthWrite = enable
	End

	Method GetDepthWrite:Bool()
		Return mDepthWrite
	End

	Method Prepare:Void()
		Local shininess% = 0
		If mShininess > 0 Then shininess = Int((1.0 - mShininess) * 128)
		Renderer.SetColor(mDiffuseRed, mDiffuseGreen, mDiffuseBlue, mAlpha)
		Renderer.SetShininess(shininess)
		Renderer.SetBlendMode(mBlendMode)
		Renderer.SetCulling(mCulling)
		Renderer.SetDepthWrite(mDepthWrite)
		If mDiffuseTex <> Null Then Renderer.SetTexture(mDiffuseTex.GetHandle()) Else Renderer.SetTexture(0)
	End
Private
	Method New()
	End

	Field mDiffuseRed	: Float
	Field mDiffuseGreen	: Float
	Field mDiffuseBlue	: Float
	Field mAlpha		: Float
	Field mShininess	: Float
	Field mDiffuseTex	: Texture
	Field mBlendMode	: Int
	Field mCulling		: Bool
	Field mDepthWrite	: Bool
End
