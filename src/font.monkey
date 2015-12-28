Strict

Private
Import vortex.src.config
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
			'If String.FromChar(text[i]) = " " Then
			'	width += mMaxWidth
			'Else
				width += mGlyphs[text[i]-32].mWidth
			'End
		Next
		Return width
	End

	Method GetTextHeight:Float(text:String)
		#Rem
		Local height# = 0
		For Local i% = 0 Until text.Length()
			Local charHeight# = mGlyphs[text[i]-32].mHeight + mGlyphs[text[i]-32].mYOffset
			If charHeight > height Then height = charHeight
		Next
		Return height
		#End
		Return mMaxHeight
	End

	Method SetGlyphData:Void(index:Int, x:Float, y:Float, w:Float, h:Float, yoffset:Float)
		mGlyphs[index].mX = x
		mGlyphs[index].mY = y
		mGlyphs[index].mWidth = w
		mGlyphs[index].mHeight = h
		mGlyphs[index].mYOffset = yoffset
		If index = 33 And mGlyphs[0].mWidth = 0 Then mGlyphs[0].mWidth = w
		If h > mMaxHeight Then mMaxHeight = h
	End

	Method Draw:Void(x:Float, y:Float, text:String)
		Local textHeight# = mMaxHeight
		For Local i% = 0 Until text.Length()
			Local glyph:Glyph = mGlyphs[text[i]-32]
			If text[i]-32 <> 0 And glyph.mWidth <> 0 And glyph.mHeight <> 0
#If VORTEX_SCREENCOORDS=VORTEX_YDOWN
				mTexture.Draw(x, y + (textHeight - glyph.mHeight) + glyph.mYOffset, 0, 0, glyph.mX, glyph.mY, glyph.mWidth, glyph.mHeight)
#Else
				mTexture.Draw(x, y - glyph.mYOffset, 0, 0, glyph.mX, mTexture.GetHeight() - glyph.mY - glyph.mHeight, glyph.mWidth, glyph.mHeight)
#End
			End
			x += glyph.mWidth
		Next
	End
Private
	Method New()
	End

	Field mFilename		: String
	Field mHeight		: Float
	Field mTexture		: Texture
	Field mGlyphs		: Glyph[224]
	Field mMaxHeight	: Float	'Height of the tallest char in this font
End
