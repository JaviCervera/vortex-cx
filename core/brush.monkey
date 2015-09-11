Strict

Private
Import vortex.core.renderer
Import vortex.core.texture

Public
Class Brush Final
Public
	Const BLEND_ALPHA% = Renderer.BLEND_ALPHA
	Const BLEND_ADD% = Renderer.BLEND_ADD
	Const BLEND_MUL% = Renderer.BLEND_MUL
	
	Function Create:Brush(baseTex:Texture = Null)
		Local brush:Brush = New Brush
		brush.mRed = 1
		brush.mGreen = 1
		brush.mBlue = 1
		brush.mOpacity = 1
		brush.mShininess = 0
		brush.mBaseTex = baseTex
		brush.mBlendMode = BLEND_ALPHA
		brush.mCulling = True
		brush.mDepthWrite = True
		Return brush
	End
	
	Method Set:Void(other:Brush)
		mRed = other.mRed
		mGreen = other.mGreen
		mBlue = other.mBlue
		mOpacity = other.mOpacity
		mBaseTex = other.mBaseTex
		mBlendMode = other.mBlendMode
		mShininess = other.mShininess
		mCulling = other.mCulling
		mDepthWrite = other.mDepthWrite
	End
	
	Method SetBaseColor:Void(r#, g#, b#)
		mRed = r
		mGreen = g
		mBlue = b
	End
	
	Method GetRed#()
		Return mRed
	End
	
	Method GetGreen#()
		Return mGreen
	End
	
	Method GetBlue#()
		Return mBlue
	End
	
	Method SetOpacity:Void(opacity#)
		mOpacity = opacity
	End
	
	Method GetOpacity#()
		Return mOpacity
	End
	
	Method SetShininess:Void(shininess#)
		mShininess = shininess
	End
	
	Method GetShininess#()
		Return mShininess
	End
	
	Method SetBaseTexture:Void(tex:Texture)
		mBaseTex = tex
	End
	
	Method GetBaseTexture:Texture()
		Return mBaseTex
	End
	
	Method SetBlendMode:Void(mode%)
		mBlendMode = mode
	End
	
	Method GetBlendMode%()
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
		Renderer.SetBaseColor(mRed, mGreen, mBlue, mOpacity)
		Renderer.SetShininess(shininess)
		Renderer.SetBlendMode(mBlendMode)
		Renderer.SetCulling(mCulling)
		Renderer.SetDepthWriting(mDepthWrite)
		If mBaseTex <> Null Then Renderer.SetTexture(mBaseTex.GetHandle()) Else Renderer.SetTexture(0)
	End
Private
	Method New()
	End
	
	Field mRed			: Float
	Field mGreen		: Float
	Field mBlue			: Float
	Field mOpacity		: Float
	Field mShininess	: Float
	Field mBaseTex		: Texture
	Field mBlendMode	: Int
	Field mCulling		: Bool
	Field mDepthWrite	: Bool
End