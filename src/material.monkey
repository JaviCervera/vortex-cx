Strict

Private
Import vortex.src.lighting
Import vortex.src.renderlist
Import vortex.src.renderer
Import vortex.src.texture

Public

Interface IMaterialDelegate
Method MaterialChanged:Void(mat:Material)
End

Class Material Final
Public
	Function Create:Material(diffuseTex:Texture = Null, delegate:IMaterialDelegate = Null)
		Local mat:Material = New Material
		mat.mDelegate = delegate
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
	
	Function Create:Material(other:Material, delegate:IMaterialDelegate = Null)
		Local mat:Material = Material.Create(Texture(Null), delegate)
		mat.Set(other)
		Return mat
	End
	
	Method FreeTextures:Void()
		If mDiffuseTex Then mDiffuseTex.Free()
		If mNormalTex Then mNormalTex.Free()
		If mLightmap Then mLightmap.Free()
		If mReflectTex Then mReflectTex.Free()
		If mReflectTex Then mRefractTex.Free()
	End
	
	Method IsEqual:Bool(other:Material)
		If Self = other Then Return True
		If mDiffuseRed = other.mDiffuseRed And mDiffuseGreen = other.mDiffuseGreen And mDiffuseBlue = other.mDiffuseBlue And mDiffuseTex = other.mDiffuseTex And mNormalTex = other.mNormalTex And mLightmap = other.mLightmap And mReflectTex = other.mReflectTex And mRefractTex = other.mRefractTex And mOpacity = other.mOpacity And mShininess = other.mShininess And mRefractCoef = other.mRefractCoef And mBlendMode = other.mBlendMode And mCulling = other.mCulling And mDepthWrite = other.mDepthWrite
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
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End
	
	Method Delegate:Void(delegate:IMaterialDelegate) Property
		mDelegate = delegate
	End
	
	Method Delegate:IMaterialDelegate() Property
		Return mDelegate
	End

	Method SetDiffuseColor:Void(r:Float, g:Float, b:Float)
		If DiffuseRed = r And DiffuseGreen = g And DiffuseBlue = b Then Return
		mDiffuseRed = r
		mDiffuseGreen = g
		mDiffuseBlue = b
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End
	
	Method DiffuseRed:Void(red:Float) Property
		If DiffuseRed = red Then Return
		mDiffuseRed = Clamp(red, 0.0, 1.0)
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End

	Method DiffuseRed:Float() Property
		Return mDiffuseRed
	End
	
	Method DiffuseGreen:Void(green:Float) Property
		If DiffuseGreen = green Then Return
		mDiffuseGreen = Clamp(green, 0.0, 1.0)
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End

	Method DiffuseGreen:Float() Property
		Return mDiffuseGreen
	End
	
	Method DiffuseBlue:Void(blue:Float) Property
		If DiffuseBlue = blue Then Return
		mDiffuseBlue = Clamp(blue, 0.0, 1.0)
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End

	Method DiffuseBlue:Float() Property
		Return mDiffuseBlue
	End
	
	Method DiffuseTexture:Void(tex:Texture) Property
		If mDiffuseTex = tex Then Return
		mDiffuseTex = tex
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End

	Method DiffuseTexture:Texture() Property
		Return mDiffuseTex
	End
	
	Method NormalTexture:Void(tex:Texture) Property
		If mNormalTex = tex Then Return
		mNormalTex = tex
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End
	
	Method NormalTexture:Texture() Property
		Return mNormalTex
	End
	
	Method Lightmap:Void(tex:Texture) Property
		If mLightmap = tex Then Return
		mLightmap = tex
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End
	
	Method Lightmap:Texture() Property
		Return mLightmap
	End
	
	Method ReflectionTexture:Void(tex:Texture) Property
		If mReflectTex Then Return
		mReflectTex = tex
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End
	
	Method ReflectionTexture:Texture() Property
		Return mReflectTex
	End
	
	Method RefractionTexture:Void(tex:Texture) Property
		If mRefractTex = tex Then Return
		mRefractTex = tex
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End
	
	Method RefractionTexture:Texture() Property
		Return mRefractTex
	End

	Method Opacity:Void(opacity:Float) Property
		If mOpacity = opacity Then Return
		mOpacity = opacity
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End

	Method Opacity:Float() Property
		Return mOpacity
	End

	Method Shininess:Void(shininess:Float) Property
		If mShininess = shininess Then Return
		mShininess = Clamp(shininess, 0.0, 1.0)
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End

	Method Shininess:Float() Property
		Return mShininess
	End
	
	Method RefractionCoef:Void(coef:Float) Property
		If mRefractCoef = coef Then Return
		mRefractCoef = coef
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End
	
	Method RefractionCoef:Float() Property
		Return mRefractCoef
	End

	Method BlendMode:Void(mode:Int) Property
		If mBlendMode = mode Then Return
		mBlendMode = mode
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End

	Method BlendMode:Int() Property
		Return mBlendMode
	End

	Method Culling:Void(enable:Bool) Property
		If mCulling = enable Then Return
		mCulling = enable
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End

	Method Culling:Bool() Property
		Return mCulling
	End

	Method DepthWrite:Void(enable:Bool) Property
		If mDepthWrite = enable Then Return
		mDepthWrite = enable
		RenderList.Sort(Self)
		If mDelegate Then mDelegate.MaterialChanged(Self)
	End

	Method DepthWrite:Bool() Property
		Return mDepthWrite
	End

	Method Prepare:Void()
		Local diffuseHandle:Int = 0
		Local normalHandle:Int = 0
		Local lightmapHandle:Int = 0
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
		If mLightmap <> Null Then lightmapHandle = mLightmap.Handle
		If mReflectTex <> Null Then reflectHandle = mReflectTex.Handle
		If mRefractTex <> Null Then refractHandle = mRefractTex.Handle
		Renderer.SetTextures(diffuseHandle, normalHandle, lightmapHandle, reflectHandle, refractHandle, mDiffuseTex And mDiffuseTex.IsCubic)
		Renderer.SetPixelLighting(Lighting.GlobalPixelLightingEnabled())
	End
Private
	Method New()
	End

	Field mDelegate		: IMaterialDelegate
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
