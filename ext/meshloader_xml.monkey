Strict

Private
Import brl.filepath
Import mojo.app
Import vortex.core.bone
Import vortex.core.brush
Import vortex.core.mesh
Import vortex.core.surface
Import vortex.core.texture
Import vortex.ext.cache
Import xml

Public
Class MeshLoader_XML Final
Public
	Function Load:Mesh(filename$, texFilter%)
		'Parse XML mesh
		Local xmlString$ = LoadString(filename)
		If xmlString = "" Then Return Null
		Local parser:XMLParser = New XMLParser(xmlString)
		If Not parser.Parse() Then DebugLog parser.GetError(); Return Null
		If parser.GetRootNode().GetName() <> "mesh" Then Return Null
	
		'Get arrays
		Local brushesNode:XMLNode = parser.GetRootNode().GetChild("brushes")
		Local surfacesNode:XMLNode = parser.GetRootNode().GetChild("surfaces")
		Local sequencesNode:XMLNode = parser.GetRootNode().GetChild("sequences")
		Local bonesNode:XMLNode = parser.GetRootNode().GetChild("bones")
		If Not surfacesNode Then Return Null
	
		'Parse brushes
		Local brushMap:StringMap<Brush> = New StringMap<Brush>
		If brushesNode <> Null
			For Local i% = 0 Until brushesNode.GetNumChildren()
				Local brushNode:XMLNode = brushesNode.GetChild(i)
				If brushNode.GetName() <> "brush"
					DebugLog "Unexpected node '" + brushNode.GetName() + "' found in brushes section. Ignoring..."
					Continue
				End
			
				'Get brush data
				Local nameStr$ = brushNode.GetChildValue("name", "")
				Local blendStr$ = brushNode.GetChildValue("blend", "alpha")
				Local baseColorStr$[] = brushNode.GetChildValue("base_color", "1,1,1").Split(",")
				Local opacity# = Float(brushNode.GetChildValue("opacity", "1"))
				Local shininess# = Float(brushNode.GetChildValue("shininess", "0"))
				Local cullingStr$ = brushNode.GetChildValue("culling", "true")
				Local depthWriteStr$ = brushNode.GetChildValue("depth_write", "true")
				Local baseTexStr$ = brushNode.GetChildValue("base_tex", "")
				Local culling:Bool = True
				Local depthWrite:Bool = True
				Local baseColor#[3]
				If cullingStr = "0" Or cullingStr.ToLower() = "false" Then culling = False
				If depthWriteStr = "0" Or depthWriteStr.ToLower() = "false" Then depthWrite = False
				baseColor[0] = Float(baseColorStr[0])
				If baseColorStr.Length() > 1 Then baseColor[1] = Float(baseColorStr[1])
				If baseColorStr.Length() > 2 Then baseColor[2] = Float(baseColorStr[2])
			
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
				brushMap.Set(nameStr, brush)
			Next
		End
	
		'Create mesh object
		Local mesh:Mesh = Mesh.Create(filename)
	
		'Parse surfaces
		For Local i% = 0 Until surfacesNode.GetNumChildren()
			Local surfaceNode:XMLNode = surfacesNode.GetChild(i)
			If surfaceNode.GetName() <> "surface"
				DebugLog "Unexpected node '" + surfaceNode.GetName() + "' found in surfaces section. Ignoring..."
				Continue
			end
		
			'Get surface data
			Local brushStr$ = surfaceNode.GetChildValue("brush", "")
			Local indicesStr$[] = surfaceNode.GetChildValue("indices", "").Split(",")
			Local coordsStr$[] = surfaceNode.GetChildValue("coords", "").Split(",")
			Local normalsStr$[] = surfaceNode.GetChildValue("normals", "").Split(",")
			Local colorsStr$[] = surfaceNode.GetChildValue("colors", "").Split(",")
			Local texcoordsStr$[] = surfaceNode.GetChildValue("texcoords", "").Split(",")
			If indicesStr.Length() < 1 Or coordsStr.Length() < 1 Then Return Null
		
			'Create surface
			Local surf:Surface = Surface.Create(brushMap.Get(brushStr))
			Local indicesLen% = indicesStr.Length()
			For Local j% = 0 Until indicesLen Step 3
				surf.AddTriangle(Int(indicesStr[j]), Int(indicesStr[j+1]), Int(indicesStr[j+2]))
			Next
			Local coordsLenDiv3% = coordsStr.Length()/3
			For Local j% = 0 Until coordsLenDiv3
				Local x#, y#, z#
				Local nx# = 1, ny# = 1, nz# = 1
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
			
				surf.AddVertex(x, y, z, nx, ny, nz, r, g, b, a, u, v)
			Next
		
			mesh.AddSurface(surf)
		Next
		
		#rem
		'Parse sequences
		If sequences <> Null
			For Local i% = 0 Until sequences.Length()
				Local jseq:JsonObject = JsonObject(sequences.Get(i))
				If Not jseq Then Return Null
			
				'Get sequence data
				Local name$ = jseq.GetString("name")
				Local first_frame% = jseq.GetInt("first_frame")
				Local last_frame% = jseq.GetInt("last_frame")
			
				'Add sequence
				mesh.AddSequence(name, first_frame, last_frame)
			Next
		End
		
		'Parse bones
		If bones
			For Local i% = 0 Until bones.Length()
				Local jbone:JsonObject = JsonObject(bones.Get(i))
				If Not jbone Then Return Null
			
				'Get node data
				Local name$ = jbone.GetString("name")
				Local parent$ = jbone.GetString("parent")
				Local position:JsonArray = JsonArray(jbone.Get("def_position"))
				Local rotation:JsonArray = JsonArray(jbone.Get("def_rotation"))
				Local scale:JsonArray = JsonArray(jbone.Get("def_scale"))
				Local surfaces:JsonArray = JsonArray(jbone.Get("surfaces"))
				If Not position Or Not rotation Or Not scale Then Return Null
				If position.Length() <> 3 Or rotation.Length() <> 4 Or scale.Length() <> 3 Then Return Null
				
				'Add bone
				Local bone:Bone = Bone.Create(name)
				bone.SetDefaultTransform(position.GetFloat(0), position.GetFloat(1), position.GetFloat(2), rotation.GetFloat(0), rotation.GetFloat(1), rotation.GetFloat(2), rotation.GetFloat(3), scale.GetFloat(0), scale.GetFloat(1), scale.GetFloat(2))

				'Add into hierarchy
				If parent = ""	'Root node
					If Not mesh.SetRootBone(bone) Then Return Null	'There can only be one root bone
				Else
					If Not mesh.GetRootBone() Then Return Null		'Parent bone must already exist
					Local parentBone:Bone = mesh.GetRootBone().Find(parent)
					If Not parentBone Then Return Null					'Parent node must exist
					parentBone.AddChild(bone)
				End
			
				'Add surfaces
				If surfaces <> Null
					For Local j% = 0 Until surfaces.Length()
						bone.AddSurface(mesh.GetSurface(surfaces.GetInt(j)))
					Next
				End
				
				'Add position frames
				Local positions:JsonArray = JsonArray(jbone.Get("position_frames"))
				If positions <> Null
					For Local k% = 0 Until positions.Length() Step 4
						Local frame% = positions.GetInt(k)
						Local x# = positions.GetFloat(k+1)
						Local y# = positions.GetFloat(k+2)
						Local z# = positions.GetFloat(k+3)
						bone.AddPositionKey(frame, x, y, z)
					Next
				End
				Local rotations:JsonArray = JsonArray(jbone.Get("rotation_frames"))
				If rotations <> Null
					For Local k% = 0 Until rotations.Length() Step 5
						Local frame% = rotations.GetInt(k)
						Local w# = rotations.GetFloat(k+1)
						Local x# = rotations.GetFloat(k+2)
						Local y# = rotations.GetFloat(k+3)
						Local z# = rotations.GetFloat(k+4)
						bone.AddRotationKey(frame, w, x, y, z)
					Next
				End
				Local scales:JsonArray = JsonArray(jbone.Get("scale_frames"))
				If scales <> Null
					For Local k% = 0 Until scales.Length() Step 4
						Local frame% = scales.GetInt(k)
						Local x# = scales.GetFloat(k+1)
						Local y# = scales.GetFloat(k+2)
						Local z# = scales.GetFloat(k+3)
						bone.AddScaleKey(frame, x, y, z)
					Next
				End
			Next
		End
		#end
	
		Return mesh
	End
Private
	Method New()
	End
End
