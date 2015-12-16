Strict

Private
Import brl.filepath
Import brl.json
Import mojo.app
Import vortex.core.bone
Import vortex.core.brush
Import vortex.core.mesh
Import vortex.core.surface
Import vortex.core.texture
Import vortex.ext.cache

Public
Class MeshLoader_JSON Final
Public
	Function Load:Mesh(filename$, texFilter%)
		'Parse JSON mesh
		Local jsonString$ = LoadString(filename)
		If jsonString = "" Then Return Null
		Local root:JsonObject = JsonObject((New JsonParser(jsonString)).ParseValue())
		If Not root Then Return Null
	
		'Get arrays
		Local brushes:JsonArray = JsonArray(root.Get("brushes"))
		Local surfaces:JsonArray = JsonArray(root.Get("surfaces"))
		Local sequences:JsonArray = JsonArray(root.Get("sequences"))
		Local bones:JsonArray = JsonArray(root.Get("bones"))
		If Not surfaces Then Return Null
	
		'Parse brushes
		Local brushMap:StringMap<Brush> = New StringMap<Brush>
		If brushes <> Null
			For Local i% = 0 Until brushes.Length()
				Local jbrush:JsonObject = JsonObject(brushes.Get(i))
				If Not jbrush Then Return Null
			
				'Get material data
				Local name$ = jbrush.GetString("name")
				Local blend$ = jbrush.GetString("blend")
				Local base_color:JsonArray = JsonArray(jbrush.Get("base_color"))
				Local opacity# = jbrush.GetFloat("opacity", 1.0)
				Local shininess# = jbrush.GetFloat("shininess", 0.0)
				Local culling:Bool = jbrush.GetBool("culling", True)
				Local depth_write:Bool = jbrush.GetBool("depth_write", True)
				Local base_tex$ = jbrush.GetString("base_tex")
			
				'Load texture
				Local baseTex:Texture = Null
				If base_tex <> ""
					If ExtractDir(filename) <> "" Then base_tex = ExtractDir(filename) + "/" + base_tex
					baseTex = Cache.GetTexture(base_tex, texFilter)
				End If
			
				'Parse color
				Local r# = 1, g# = 1, b# = 1
				If base_color
					If base_color.Length() = 3
						r = base_color.GetFloat(0)
						g = base_color.GetFloat(1)
						b = base_color.GetFloat(2)
					Else
						Return Null
					End
				End
			
				'Create brush
				Local brush:Brush = Brush.Create(baseTex)
				If blend.ToLower() = "alpha" Then brush.SetBlendMode(Brush.BLEND_ALPHA)
				If blend.ToLower() = "add" Then brush.SetBlendMode(Brush.BLEND_ADD)
				If blend.ToLower() = "mul" Then brush.SetBlendMode(Brush.BLEND_MUL)
				brush.SetBaseColor(r, g, b)
				brush.SetOpacity(opacity)
				brush.SetShininess(shininess)
				brush.SetCulling(culling)
				brush.SetDepthWrite(depth_write)
				brushMap.Set(name, brush)
			Next
		End
	
		'Create mesh object
		Local mesh:Mesh = Mesh.Create(filename)
	
		'Parse surfaces
		For Local i% = 0 Until surfaces.Length()
			Local jsurface:JsonObject = JsonObject(surfaces.Get(i))
			If Not jsurface Then Return Null
		
			'Get surface data
			Local brushName$ = jsurface.GetString("brush")
			Local indices:JsonArray = JsonArray(jsurface.Get("indices"))
			Local coords:JsonArray = JsonArray(jsurface.Get("coords"))
			Local normals:JsonArray = JsonArray(jsurface.Get("normals"))
			Local colors:JsonArray = JsonArray(jsurface.Get("colors"))
			Local texcoords:JsonArray = JsonArray(jsurface.Get("texcoords"))
			If Not indices Or Not coords Then Return Null
		
			'Create surface
			Local surf:Surface = Surface.Create(brushMap.Get(brushName))
			For Local j% = 0 Until indices.Length() Step 3
				surf.AddTriangle(indices.GetInt(j), indices.GetInt(j+1), indices.GetInt(j+2))
			Next
			For Local j% = 0 Until coords.Length()/3
				Local x#, y#, z#
				Local nx# = 1, ny# = 1, nz# = 1
				Local r# = 1, g# = 1, b# = 1, a# = 1
				Local u# = 0, v# = 0
			
				'Read coords
				x = coords.GetFloat(j*3)
				y = coords.GetFloat(j*3+1)
				z = coords.GetFloat(j*3+2)
			
				'Read normals
				If normals
					nx = normals.GetFloat(j*3)
					ny = normals.GetFloat(j*3+1)
					nz = normals.GetFloat(j*3+2)
				End
				
				'Read colors
				If colors
					r = colors.GetFloat(j*4)
					g = colors.GetFloat(j*4+1)
					b = colors.GetFloat(j*4+2)
					a = colors.GetFloat(j*4+3)
				End
			
				'Read tex coords
				If texcoords
					u = texcoords.GetFloat(j*2)
					v = texcoords.GetFloat(j*2+1)
				End
			
				surf.AddVertex(x, y, z, nx, ny, nz, r, g, b, a, u, v)
			Next
		
			mesh.AddSurface(surf)
		Next
		
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
	
		Return mesh
	End
Private
	Method New()
	End
End
