Strict

Private
Import brl.filepath
Import mojo.app
Import vortex.src.font
Import vortex.src.renderer
Import vortex.src.texture
Import vortex.src.xml

Public
Class FontLoader_XML Final
Public
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
		Local tex:Texture = Texture.Create(image, Renderer.FILTER_NONE)
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
Private
	Method New()
	End
End
