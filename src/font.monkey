Strict

Private
Import brl.databuffer
Import brl.datastream
Import brl.filepath
Import mojo.app
Import vortex.src.renderer
Import vortex.src.texture

Public

Class Glyph Final
	Field mX		: Float
	Field mY		: Float
	Field mWidth	: Float
	Field mHeight	: Float
	Field mXOffset	: Float
	Field mYOffset	: Float
End

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

	Function Load:Font(filename:String)
		'Fix filename
		If filename.Length > 2 And String.FromChar(filename[0]) <> "/" And String.FromChar(filename[1]) <> ":" Then filename = "monkey://data/" + filename
		
		'Load font data
		Local data:DataBuffer = DataBuffer.Load(filename)
		If Not data Then Return Null
		Local font:Font = Font.LoadData(data, filename)
		data.Discard()
	
		Return font
	End
	
	Function LoadData:Font(data:DataBuffer, filename:String)
		Local stream:DataStream = New DataStream(data)
		
		'Id
		Local id:String = stream.ReadString(4)
		If id <> "FN01" Then Return Null
		
		'Texture name
		Local texLen:Int = stream.ReadInt()
		Local texName:String = stream.ReadString(texLen)
		
		'Font height
		Local height:Int = stream.ReadShort()
		
		'Num glyphs
		Local numGlyphs:Int = stream.ReadInt()
		
		'First char
		Local firstChar:Int = stream.ReadInt()
		
		'Load texture
		Local tex:Texture = texture.Texture.Load(texName, Renderer.FILTER_NONE)
		
		'Create font
		Local font:Font = Font.Create(filename, height, tex)
		
		'Add glyphs
		For Local i:Int = 0 Until numGlyphs
			'Get glyph data
			Local x:Float = stream.ReadFloat()
			Local y:Float = stream.ReadFloat()
			Local width:Float = stream.ReadFloat()
			Local height:Float = stream.ReadFloat()
			Local xoffset:Float = stream.ReadFloat()
			Local yoffset:Float = stream.ReadFloat()
			
			'Add glyph data
			font.SetGlyphData(i, x, y, width, height, yoffset)
		Next
		
		stream.Close()
		
		Return font
	End

	Method Free:Void()
		mTexture.Free()
	End
	
	Method Filename:Void(filename:String) Property
		mFilename = filename
	End

	Method Filename:String() Property
		Return mFilename
	End

	Method Height:Float() Property
		Return mHeight
	End
	
	Method Texture:Texture() Property
		Return mTexture
	End

	Method TextWidth:Float(text:String)
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

	Method TextHeight:Float(text:String)
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

	Method Draw:Void(x:Float, y:Float, text:String)
		Local textHeight# = mMaxHeight
		For Local i% = 0 Until text.Length()
			Local glyph:Glyph = mGlyphs[text[i]-32]
			If text[i]-32 <> 0 And glyph.mWidth <> 0 And glyph.mHeight <> 0
				mTexture.Draw(x, y + (textHeight - glyph.mHeight) + glyph.mYOffset, 0, 0, glyph.mX, glyph.mY, glyph.mWidth, glyph.mHeight)
			End
			x += glyph.mWidth
		Next
	End
	
	Method NumGlyphs:Int() Property
		Return mGlyphs.Length
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
	
	Method GlyphData:Glyph(index:Int)
		Return mGlyphs[index]
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
