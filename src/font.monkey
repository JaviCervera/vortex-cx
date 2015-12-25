Strict

Private
Import vortex.src.texture

Class Glyph Final
	Field mX		: Float
	Field mY		: Float
	Field mWidth	: Float
	Field mHeight	: Float
	Field mYOffset	: Float
End

Public
Class Font Final
Public
	Function Create:Font(filename:String, height:Float, tex:Texture)
		Local f:Font = New Font
		f.mFilename = filename
		f.mHeight = height
		f.mTexture = tex
		For Local i% = 0 Until f.mGlyphs.Length()
			f.mGlyphs[i] = New Glyph
		Next
		Return f
	End

	Method Discard:Void()
		mTexture.Discard()
	End

	Method GetFilename:String()
		Return mFilename
	End

	Method GetHeight:Float()
		Return mHeight
	End
	
	Method GetTexture:Texture()
		Return mTexture
	End

	Method GetTextWidth:Float(text:String)
		Local width# = 0
		For Local i% = 0 Until text.Length()
			If String.FromChar(text[i]) = " " Then
				width += mHeight/3
			Else
				width += mGlyphs[text[i]-32].mWidth
			End
		Next
		Return width
	End

	Method GetTextHeight:Float(text:String)
		Local height# = 0
		For Local i% = 0 Until text.Length()
			If mGlyphs[text[i]-32].mHeight > height Then height = mGlyphs[text[i]-32].mHeight
		Next
		Return height
	End

	Method SetGlyphData:Void(index:Int, x:Float, y:Float, w:Float, h:Float, yoffset:Float)
		mGlyphs[index].mX = x
		mGlyphs[index].mY = y
		mGlyphs[index].mWidth = w
		mGlyphs[index].mHeight = h
		mGlyphs[index].mYOffset = yoffset
	End

	Method Draw:Void(x:Float, y:Float, text:String)
		For Local i% = 0 Until text.Length()
			Local glyph:Glyph = mGlyphs[text[i]-32]
			If ( String.FromChar(text[i]) = " " )
				x += mHeight/3
			Elseif glyph.mWidth <> 0 And glyph.mHeight <> 0
				mTexture.Draw(x, y + glyph.mYOffset, 0, 0, glyph.mX, glyph.mY, glyph.mWidth, glyph.mHeight)
			End
			x += glyph.mWidth
		Next
	End
Private
	Method New()
	End

	Field mFilename	: String
	Field mHeight	: Float
	Field mTexture	: Texture
	Field mGlyphs	: Glyph[224]
End
