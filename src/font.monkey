Strict

Private
Import brl.filepath
Import mojo.app
Import vortex.src.renderer
Import vortex.src.texture
Import vortex.src.xml

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
	
	Function Load:Font(filename:String)
		'Parse XML font
		Local xmlString$ = LoadString(filename)
		If xmlString = "" Then Return Null
		Local err:XMLError = New XMLError
		Local doc:XMLDoc = ParseXML(xmlString, err)
		If (doc = Null And err.error) Or doc.name <> "font" Then Return Null

		'Get data
		Local image:String = doc.GetChild("image").value
		Local height:Int = Int(doc.GetChild("height").value)
		Local glyphNodes:List<XMLNode> = doc.GetChild("glyphs").GetChildren("glyph")
		If height = 0 Or glyphNodes.IsEmpty() Then Return Null

		'Load texture map
		If ExtractDir(filename) <> "" Then image = ExtractDir(filename) + "/" + image
		Local tex:Texture = texture.Texture.Load(image, Renderer.FILTER_NONE)
		If Not tex Then Return Null

		'Create font
		Local font:Font = Font.Create(filename, height, tex)

		'Parse glyphs
		Local index:Int = 0
		For Local glyphNode:XMLNode = Eachin glyphNodes
			'Get glyph data
			Local x:Float = glyphNode.GetAttribute("x", 0.0)
			Local y:Float = glyphNode.GetAttribute("y", 0.0)
			Local w:Float = glyphNode.GetAttribute("width", 0.0)
			Local h:Float = glyphNode.GetAttribute("height", 0.0)
			Local yoffset:Float = glyphNode.GetAttribute("yoffset", 0.0)

			'Add glyph
			font.SetGlyphData(index, x, y, w, h, yoffset)
			index += 1
		Next

		Return font
	End

	Method Free:Void()
		mTexture.Free()
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
	
	Method SetGlyphData:Void(index:Int, x:Float, y:Float, w:Float, h:Float, yoffset:Float)
		mGlyphs[index].mX = x
		mGlyphs[index].mY = y
		mGlyphs[index].mWidth = w
		mGlyphs[index].mHeight = h
		mGlyphs[index].mYOffset = yoffset
		If index = 33 And mGlyphs[0].mWidth = 0 Then mGlyphs[0].mWidth = w
		If h > mMaxHeight Then mMaxHeight = h
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
