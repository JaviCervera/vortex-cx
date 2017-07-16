Strict

Private
Import brl.datastream
Import brl.filepath
Import brl.filestream
Import brl.filesystem
Import brl.process
Import mojo.app
Import vortex
Import xml

Public

Function LoadFont:Font(filename:String, size:Int)
	'Directly load native XML files
	If ExtractExt(filename).ToLower() = "xml" Then Return LoadXMLFont(filename)
	
	'Directly load native FNT files
	If ExtractExt(filename).ToLower() = "fnt"
		Local font:Font = Font.Load(filename)
		Return font
	End

	'Use external tool to load other font formats
#If HOST="winnt"
	Local ext:String = ".exe"
#Else
	Local ext:String = ".bin"
#End
	Local path:String = CurrentDir() + "/data/fonttool" + ext
	If FileType(path) <> FILETYPE_FILE
		path = CurrentDir() + "/fonttool.data/fonttool" + ext
	Else
		'Make sure that file is given execution permissions on Linux
		Process.Execute("chmod +x ~q" + path + "~q")
	End
	Local command:String = "~q" + path + "~q ~q" + filename + "~q " + size
	Local output:String = Process.Execute(command).Trim()
	Local findIndex:Int = output.Find("<font>")
	If findIndex > -1 Then output = output[findIndex ..]
	Return LoadXMLFontString(output, filename)
End

Function LoadXMLFont:Font(filename:String)
	Return LoadXMLFontString(app.LoadString(filename), filename)
End

Function LoadXMLFontString:Font(buffer:String, filename:String)
	'Parse XML font
	If buffer = "" Then Return Null
	Local err:XMLError = New XMLError
	Local doc:XMLDoc = ParseXML(buffer, err)
	If (doc = Null And err.error) Or doc.name <> "font" Then Return Null

	'Get data
	Local alphas:String[] = doc.GetChild("alphas").value.Split(",")
	Local bufferWidth:Int = Int(doc.GetChild("buffer_width").value)
	Local fontSize:Int = Int(doc.GetChild("font_size").value)
	Local glyphNodes:List<XMLNode> = doc.GetChild("glyphs").GetChildren("glyph")
	If alphas.Length = 0 Or bufferWidth = 0 Or fontSize = 0 Or glyphNodes.IsEmpty() Then Return Null
	
	'Gen texture
	Local texData:DataBuffer = New DataBuffer(alphas.Length*4)
	For Local i:Int = 0 Until alphas.Length
		texData.PokeByte(i*4 + 0, 255)
		texData.PokeByte(i*4 + 1, 255)
		texData.PokeByte(i*4 + 2, 255)
		texData.PokeByte(i*4 + 3, Int(alphas[i]))
	Next
	Local tex:Texture = Texture.Create(texData, bufferWidth, bufferWidth, Renderer.FILTER_NONE)
	tex.Filename = StripDir(StripExt(filename)) + ".png"
	texData.Discard()

	'Create font
	Local font:Font = Font.Create(filename, fontSize, tex)

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

Function FontSize:Int(font:Font)
	'Id & version
	Local size:Int = 4
	
	'Texture name
	size += 4 + font.Texture.Filename.Length
	
	'Font height
	size += 2
	
	'Num glyphs
	size += 4
	
	'First char
	size += 4
	
	'Glyphs
	size += font.NumGlyphs * 6 * 4
	
	Return size
End

Function WriteGlyphData:Void(stream:DataStream, glyph:Glyph)
	stream.WriteFloat(glyph.mX)
	stream.WriteFloat(glyph.mY)
	stream.WriteFloat(glyph.mWidth)
	stream.WriteFloat(glyph.mHeight)
	stream.WriteFloat(glyph.mXOffset)
	stream.WriteFloat(glyph.mYOffset)
End

Function CreateFontData:DataBuffer(font:Font)
	Local stream:DataStream = New DataStream(New DataBuffer(FontSize(font)))
	
	'Id & version
	stream.WriteByte("F"[0])
	stream.WriteByte("N"[0])
	stream.WriteByte("0"[0])
	stream.WriteByte("1"[0])
	
	'Texture name
	stream.WriteInt(font.Texture.Filename.Length)
	stream.WriteString(font.Texture.Filename)
	
	'Font height
	stream.WriteShort(font.Height)
	
	'Num glyphs
	stream.WriteInt(font.NumGlyphs)
	
	'First char
	stream.WriteInt(32)
	
	'Glyphs
	For Local i:Int = 0 Until font.NumGlyphs
		WriteGlyphData(stream, font.GetGlyphData(i))
	Next
	
	Return stream.Data
End

Function SaveFont:Void(font:Font, filename:String)
	Local fontData:DataBuffer = CreateFontData(font)
	Local fileStream:FileStream = New FileStream(filename, "w")
	fileStream.WriteAll(fontData, 0, fontData.Length)
	fileStream.Close()
End

Function SaveFontTexture:Void(font:Font, filename:String)
#If HOST="winnt"
	Local ext:String = ".exe"
#Else
	Local ext:String = ".bin"
#End
	Local path:String = CurrentDir() + "/data/savefonttexture" + ext
	If FileType(path) <> FILETYPE_FILE
		path = CurrentDir() + "/fonttool.data/savefonttexture" + ext
	Else
		'Make sure that file is given execution permissions on Linux
		Process.Execute("chmod +x ~q" + path + "~q")
	End
	Local command:String = "~q" + path + "~q ~q" + font.Filename + "~q " + font.Height + " ~q" + filename + "~q"
	Process.Execute(command).Trim()
End