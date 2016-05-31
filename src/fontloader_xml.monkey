Strict

Private
Import brl.filepath
Import mojo.app
Import vortex.src.font
Import vortex.src.renderer
Import vortex.src.texture
Import vortex.src.xml_old

Public
Class FontLoader_XML Final
Public
	Function Load:Font(filename$)
		'Parse XML font
		Local xmlString$ = LoadString(filename)
		If xmlString = "" Then Return Null
		Local parser:XMLParser = New XMLParser(xmlString)
		If Not parser.Parse() Then DebugLog parser.GetError(); Return Null
		If parser.GetRootNode().GetName() <> "font" Then Return Null

		'Get data
		Local image$ = parser.GetRootNode().GetChildValue("image", "")
		Local height% = Int(parser.GetRootNode().GetChildValue("height", "0"))
		Local glyphsNode:XMLNode = parser.GetRootNode().GetChild("glyphs")
		If height = 0 Or Not glyphsNode Then Return Null

		'Load texture map
		If ExtractDir(filename) <> "" Then image = ExtractDir(filename) + "/" + image
		Local tex:Texture = Texture.Create(image, Renderer.FILTER_NONE)
		If Not tex Then Return Null

		'Create font
		Local font:Font = Font.Create(filename, height, tex)

		'Parse glyphs
		For Local i% = 0 Until glyphsNode.GetNumChildren()
			Local glyphNode:XMLNode = glyphsNode.GetChild(i)
			If glyphNode.GetName() <> "glyph"
				DebugLog "Unexpected node '" + glyphNode.GetName() + "' found in glyphs section. Ignoring..."
				Continue
			End

			'Get glyph data
			Local x# = Float(glyphNode.GetAttribute("x", "0"))
			Local y# = Float(glyphNode.GetAttribute("y", "0"))
			Local w# = Float(glyphNode.GetAttribute("width", "0"))
			Local h# = Float(glyphNode.GetAttribute("height", "0"))
			Local yoffset# = Float(glyphNode.GetAttribute("yoffset", "0"))

			'Add glyph
			font.SetGlyphData(i, x, y, w, h, yoffset)
		Next

		Return font
	End
Private
	Method New()
	End
End
