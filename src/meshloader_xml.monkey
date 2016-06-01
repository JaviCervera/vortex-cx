Strict

Private
Import brl.filepath
Import mojo.app
Import vortex.src.bone
Import vortex.src.brush
Import vortex.src.cache
Import vortex.src.mesh
Import vortex.src.surface
Import vortex.src.texture
Import vortex.src.xml

Public
Class MeshLoader_XML Final
Public
	Function Load:Mesh(filename$, texFilter%)
		'Parse XML mesh
		Local xmlString$ = LoadString(filename)
		If xmlString = "" Then Return Null
		Local err:XMLError = New XMLError
		Local doc:XMLDoc = ParseXML(xmlString, err)
		If (doc = Null And err.error) Or doc.name <> "mesh" Then Return Null

		'Get arrays
		Local brushNodes:List<XMLNode> = doc.GetChild("brushes").GetChildren("brush")
		Local surfaceNodes:List<XMLNode> = doc.GetChild("surfaces").GetChildren("surface")
		Local lastFrameNode:XMLNode = doc.GetChild("last_frame")
		Local boneNodes:List<XMLNode> = doc.GetChild("bones").GetChildren("bone")
		If surfaceNodes.IsEmpty() Then Return Null

		'Parse brushes
		Local brushesMap:StringMap<Brush> = New StringMap<Brush>
		For Local brushNode:XMLNode = Eachin brushNodes
			'Get brush data
			Local nameStr:String = brushNode.GetChild("name").value
			Local blendStr:String = brushNode.GetChild("blend").value
			Local baseColorStr:String[] = brushNode.GetChild("base_color").value.Split(",")
			Local opacityStr:String = brushNode.GetChild("opacity").value
			Local shininess:Float = Float(brushNode.GetChild("shininess").value)
			Local cullingStr:String = brushNode.GetChild("culling").value
			Local depthWriteStr:String = brushNode.GetChild("depth_write").value
			Local baseTexStr:String = brushNode.GetChild("base_tex").value
			Local opacity:Float = 1
			Local culling:Bool = True
			Local depthWrite:Bool = True
			Local baseColor:Float[] = [1.0, 1.0, 1.0]
			If opacityStr <> "" Then opacity = Float(opacityStr)
			If cullingStr = "0" Or cullingStr.ToLower() = "false" Then culling = False
			If depthWriteStr = "0" Or depthWriteStr.ToLower() = "false" Then depthWrite = False
			If baseColorStr.Length() > 2
				baseColor[0] = Float(baseColorStr[0])
				baseColor[1] = Float(baseColorStr[1])
				baseColor[2] = Float(baseColorStr[2])
			End

			'Load texture
			Local baseTex:Texture = Null
			If baseTexStr <> ""
				If ExtractDir(filename) <> "" Then baseTexStr = ExtractDir(filename) + "/" + baseTexStr
				baseTex = Cache.GetTexture(baseTexStr, texFilter)
			End
			
			'Create brush
			Local brush:Brush = Brush.Create(baseTex)
			If blendStr.ToLower() = "alpha" Then brush.SetBlendMode(Brush.BLEND_ALPHA)
			If blendStr.ToLower() = "add" Then brush.SetBlendMode(Brush.BLEND_ADD)
			If blendStr.ToLower() = "mul" Then brush.SetBlendMode(Brush.BLEND_MUL)
			brush.SetBaseColor(baseColor[0], baseColor[1], baseColor[2])
			brush.SetOpacity(opacity)
			brush.SetShininess(shininess)
			brush.SetCulling(culling)
			brush.SetDepthWrite(depthWrite)
			brushesMap.Set(nameStr, brush)
		Next

		'Create mesh object
		Local mesh:Mesh = Mesh.Create()
		mesh.SetFilename(filename)
		
		'Parse surfaces
		For Local surfaceNode:XMLNode = Eachin surfaceNodes
			'Get surface data
			Local brushStr:String = surfaceNode.GetChild("brush").value
			Local indicesStr:String[] = surfaceNode.GetChild("indices", "").value.Split(",")
			Local coordsStr:String[] = surfaceNode.GetChild("coords", "").value.Split(",")
			Local normalsStr:String[] = surfaceNode.GetChild("normals", "").value.Split(",")
			Local colorsStr:String[] = surfaceNode.GetChild("colors", "").value.Split(",")
			Local texcoordsStr:String[] = surfaceNode.GetChild("texcoords", "").value.Split(",")

			'Create surface
			Local surf:Surface = Surface.Create(brushesMap.Get(brushStr))
			Local indicesLen:Int = indicesStr.Length()
			For Local j:Int = 0 Until indicesLen Step 3
				surf.AddTriangle(Int(indicesStr[j]), Int(indicesStr[j+1]), Int(indicesStr[j+2]))
			Next
			Local coordsLenDiv3:Int = coordsStr.Length()/3
			For Local j:Int = 0 Until coordsLenDiv3
				Local x#, y#, z#
				Local nx# = 0, ny# = 0, nz# = 0
				Local r# = 1, g# = 1, b# = 1, a# = 1
				Local u# = 0, v# = 0

				'Read coords
				x = Float(coordsStr[j*3])
				y = Float(coordsStr[j*3+1])
				z = Float(coordsStr[j*3+2])

				'Read normals
				If normalsStr.Length() > 1
					nx = Float(normalsStr[j*3])
					ny = Float(normalsStr[j*3+1])
					nz = Float(normalsStr[j*3+2])
				End

				'Read colors
				If colorsStr.Length() > 1
					r = Float(colorsStr[j*4])
					g = Float(colorsStr[j*4+1])
					b = Float(colorsStr[j*4+2])
					a = Float(colorsStr[j*4+3])
				End

				'Read tex coords
				If texcoordsStr.Length() > 1
					u = Float(texcoordsStr[j*2])
					v = Float(texcoordsStr[j*2+1])
				End

				'Add vertex
				Local vertex:Int = surf.AddVertex(x, y, z, nx, ny, nz, r, g, b, a, u, v)
			Next

			mesh.AddSurface(surf)
		Next

		'Parse last frame
		mesh.SetLastFrame(Int(lastFrameNode.value))
		
		'Parse bones
		Local i:Int = 0
		For Local boneNode:XMLNode = Eachin boneNodes
			'Get bone data
			Local nameStr:String = boneNode.GetChild("name").value
			Local parentStr:String = boneNode.GetChild("parent").value
			Local defPositionStr:String[] = boneNode.GetChild("def_position").value.Split(",")
			Local defRotationStr:String[] = boneNode.GetChild("def_rotation").value.Split(",")
			Local defScaleStr:String[] = boneNode.GetChild("def_scale").value.Split(",")
			Local surfacesStr:String[] = boneNode.GetChild("surfaces").value.Split(",")
			If defPositionStr.Length() <> 3 Or defRotationStr.Length() <> 4 Or defScaleStr.Length() <> 3 Then Return Null

			'Create bone
			Local bone:Bone = Bone.Create(nameStr)
				
			'Set parent
			If parentStr <> ""
				Local parent:Bone = mesh.FindBone(parentStr)
				If parent = Null Then Return Null	'Parent bone must exist
				bone.SetParent(parent)
			End
				
			'Set pose matrix
			bone.CalcPoseMatrix(Float(defPositionStr[0]), Float(defPositionStr[1]), Float(defPositionStr[2]), Float(defRotationStr[0]), Float(defRotationStr[1]), Float(defRotationStr[2]), Float(defRotationStr[3]), Float(defScaleStr[0]), Float(defScaleStr[1]), Float(defScaleStr[2]))
				
			'Add to mesh
			mesh.AddBone(bone)
			
			'Add surfaces
			If surfacesStr[0] <> ""
				For Local j% = 0 Until surfacesStr.Length()
					bone.AddSurface(mesh.GetSurface(Int(surfacesStr[j])))
				Next
			End

			'Add position frames
			Local positionsStr$[] = boneNode.GetChild("positions").value.Split(",")
			If positionsStr.Length() >= 4
				For Local k% = 0 Until positionsStr.Length() Step 4
					Local frame% = Int(positionsStr[k])
					Local x# = Float(positionsStr[k+1])
					Local y# = Float(positionsStr[k+2])
					Local z# = Float(positionsStr[k+3])
					bone.AddPositionKey(frame, x, y, z)
				Next
			End
			Local rotationsStr$[] = boneNode.GetChild("rotations").value.Split(",")
			If rotationsStr.Length() >= 5
				For Local k% = 0 Until rotationsStr.Length() Step 5
					Local frame% = Int(rotationsStr[k])
					Local w# = Float(rotationsStr[k+1])
					Local x# = Float(rotationsStr[k+2])
					Local y# = Float(rotationsStr[k+3])
					Local z# = Float(rotationsStr[k+4])
					bone.AddRotationKey(frame, w, x, y, z)
				Next
			End
			Local scalesStr$[] = boneNode.GetChild("scales").value.Split(",")
			If scalesStr.Length() >= 4
				For Local k% = 0 Until scalesStr.Length() Step 4
					Local frame% = Int(scalesStr[k])
					Local x# = Float(scalesStr[k+1])
					Local y# = Float(scalesStr[k+2])
					Local z# = Float(scalesStr[k+3])
					bone.AddScaleKey(frame, x, y, z)
				Next
			End
			
			i += 1
		Next

		Return mesh
	End
Private
	Method New()
	End
End
