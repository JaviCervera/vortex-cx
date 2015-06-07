Strict

Private
Import brl.filepath
Import brl.json
Import mojo.app
Import vortex.core.font
Import vortex.core.texture

Public
Class FontLoader Final
Public
	Function Load:Font(filename$)
		'Parse JSON font
		Local jsonString$ = LoadString(filename)
		If jsonString = "" Then Return Null
		Local root:JsonObject = JsonObject((New JsonParser(jsonString)).ParseValue())
		If Not root Then Return Null
		
		'Get data
		Local image$ = root.GetString("image")
		Local height% = root.GetInt("height")
		Local glyphsArr:JsonArray = JsonArray(root.Get("glyphs"))
		If height = 0 Or Not glyphsArr Then Return Null
		If glyphsArr.Length() <> 224 Then Return Null
		
		'Load texture map
		If ExtractDir(filename) <> "" Then image = ExtractDir(filename) + "/" + image
		Local tex:Texture = Texture.Create(image, Texture.FILTER_NONE)
		If Not tex Then Return Null
		
		'Create font
		Local font:Font = Font.Create(filename, height, tex)
		
		'Parse glyphs
		For Local i% = 0 Until 224
			Local jglyph:JsonObject = JsonObject(glyphsArr.Get(i))
			If Not jglyph
				font.Discard()
				Return Null
			End
			
			'Get glyph data
			Local x# = jglyph.GetFloat("x")
			Local y# = jglyph.GetFloat("y")
			Local w# = jglyph.GetFloat("width")
			Local h# = jglyph.GetFloat("height")
			Local yoffset# = jglyph.GetFloat("yoffset")
			
			'Add glyph
			font.SetGlyphData(i, x, y, w, h, yoffset)
		Next
		
		Return font
	End
Private
	Method New()
	End
End
