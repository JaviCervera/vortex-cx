Strict

Private

Import brl.filepath
Import brl.filesystem
Import brl.process
Import mojo.app
Import vortex
Import vortex.src.xml

Public

Function LoadMesh:Mesh(filename:String)
	'Directly load native XML files
	If ExtractExt(filename).ToLower() = "xml" Then Return LoadXMLMesh(filename)
	
	'Directly load native MSH files
	If ExtractExt(filename).ToLower() = "msh"
		Local mesh:Mesh = Mesh.Load(filename, StripExt(filename) + ".skl", StripExt(filename) + ".anm")
		Return mesh
	End

	'Use external tool to load other mesh formats
#If HOST="winnt"
	Local ext:String = ".exe"
#Else
	Local ext:String = ".bin"
#End
	Local path:String = CurrentDir() + "/data/meshtool" + ext
	If FileType(path) <> FILETYPE_FILE
		path = CurrentDir() + "/meshtool.data/meshtool" + ext
	Else
		'Make sure that file is given execution permissions on Linux
		Process.Execute("chmod +x ~q" + path + "~q")
	End
	Local command:String = "~q" + path + "~q ~q" + filename + "~q"
	Local output:String = Process.Execute(command).Trim()
	Local findIndex:Int = output.Find("<mesh>")
	If findIndex > -1 Then output = output[findIndex ..]
	Return LoadXMLMeshString(output, filename)
End

Function LoadXMLMesh:Mesh(filename:String, texFilter:Int = Renderer.FILTER_TRILINEAR)
	Return LoadXMLMeshString(app.LoadString(filename), filename, texFilter)
End

Function LoadXMLMeshString:Mesh(buffer:String, filename:String, texFilter:Int = Renderer.FILTER_TRILINEAR)
	'Parse XML mesh
	If buffer = "" Then Return Null
	Local err:XMLError = New XMLError
	Local doc:XMLDoc = ParseXML(buffer, err)
	If (doc = Null And err.error) Or doc.name <> "mesh" Then Return Null

	'Get arrays
	Local materialNodes:List<XMLNode> = doc.GetChild("materials").GetChildren("material")
	Local surfaceNodes:List<XMLNode> = doc.GetChild("surfaces").GetChildren("surface")
	Local numFramesNode:XMLNode = doc.GetChild("num_frames")
	Local boneNodes:List<XMLNode> = doc.GetChild("bones").GetChildren("bone")
	If surfaceNodes.IsEmpty() Then Return Null
	
	'Texture caches
	Local loadedDiffuse:StringMap<Texture> = New StringMap<Texture>
	Local loadedLightmaps:StringMap<Texture> = New StringMap<Texture>

	'Parse materials
	Local materialsMap:StringMap<Material> = New StringMap<Material>
	For Local materialNode:XMLNode = Eachin materialNodes
		'Get material data
		Local nameStr:String = materialNode.GetChild("name").value
		Local blendStr:String = materialNode.GetChild("blend").value
		Local baseColorStr:String[] = materialNode.GetChild("diffuse_color").value.Split(",")
		Local opacityStr:String = materialNode.GetChild("opacity").value
		Local shininess:Float = Float(materialNode.GetChild("shininess").value)
		Local cullingStr:String = materialNode.GetChild("culling").value
		Local depthWriteStr:String = materialNode.GetChild("depth_write").value
		Local baseTexStr:String = materialNode.GetChild("diffuse_tex").value
		Local lightmapStr:String = materialNode.GetChild("lightmap").value
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

		'Load diffuse texture
		Local diffuseTex:Texture = Null
		If baseTexStr <> ""
			If ExtractDir(filename) <> "" And ExtractDir(baseTexStr) = "" Then baseTexStr = ExtractDir(filename) + "/" + baseTexStr
			If loadedDiffuse.Contains(baseTexStr)
				diffuseTex = loadedDiffuse.Get(baseTexStr)
			Else
				diffuseTex = Texture.Load(baseTexStr, texFilter)
				loadedDiffuse.Add(baseTexStr, diffuseTex)
			End
		End
		
		'Load lightmap
		Local lightmap:Texture = Null
		If lightmapStr <> ""
			If ExtractDir(filename) <> "" And ExtractDir(lightmapStr) = "" Then lightmapStr = ExtractDir(filename) + "/" + lightmapStr
			If loadedLightmaps.Contains(lightmapStr)
				lightmap = loadedLightmaps.Get(lightmapStr)
			Else
				lightmap = Texture.Load(lightmapStr, texFilter)
				loadedLightmaps.Add(lightmapStr, lightmap)
			End
		End

		'Create material
		Local material:Material = Material.Create(diffuseTex)
		material.Lightmap = lightmap
		If blendStr.ToLower() = "alpha" Then material.BlendMode = Renderer.BLEND_ALPHA
		If blendStr.ToLower() = "add" Then material.BlendMode = Renderer.BLEND_ADD
		If blendStr.ToLower() = "mul" Then material.BlendMode = Renderer.BLEND_MUL
		material.SetDiffuseColor(baseColor[0], baseColor[1], baseColor[2])
		material.Opacity = opacity
		material.Shininess = shininess
		material.Culling = culling
		material.DepthWrite = depthWrite
		materialsMap.Set(nameStr, material)
	Next

	'Create mesh object
	Local mesh:Mesh = Mesh.Create()
	mesh.Filename = filename

	'Parse surfaces
	For Local surfaceNode:XMLNode = Eachin surfaceNodes
		'Get surface data
		Local materialStr:String = surfaceNode.GetChild("material").value
		Local indicesStr:String[] = surfaceNode.GetChild("indices", "").value.Split(",")
		Local coordsStr:String[] = surfaceNode.GetChild("coords", "").value.Split(",")
		Local normalsStr:String[] = surfaceNode.GetChild("normals", "").value.Split(",")
		Local tangentsStr:String[] = surfaceNode.GetChild("tangents", "").value.Split(",")
		Local colorsStr:String[] = surfaceNode.GetChild("colors", "").value.Split(",")
		Local texcoordsStr:String[] = surfaceNode.GetChild("texcoords", "").value.Split(",")
		Local texcoords2Str:String[] = surfaceNode.GetChild("texcoords2", "").value.Split(",")
		Local boneIndicesStr:String[] = surfaceNode.GetChild("bone_indices", "").value.Split(",")
		Local boneWeightsStr:String[] = surfaceNode.GetChild("bone_weights", "").value.Split(",")

		'Create surface
		Local surf:Surface = Surface.Create(materialsMap.Get(materialStr))
		Local indicesLen:Int = indicesStr.Length()
		For Local j:Int = 0 Until indicesLen Step 3
			surf.AddTriangle(Int(indicesStr[j]), Int(indicesStr[j+1]), Int(indicesStr[j+2]))
		Next
		Local coordsLenDiv3:Int = coordsStr.Length()/3
		For Local j:Int = 0 Until coordsLenDiv3
			Local x#, y#, z#
			Local nx# = 0, ny# = 0, nz# = 0
			Local tx# = 0, ty# = 0, tz# = 0
			Local r# = 1, g# = 1, b# = 1, a# = 1
			Local u0# = 0, v0# = 0
			Local u1:Float = 0, v1:Float = 0
			Local b0% = -1, b1% = -1, b2% = -1, b3% = -1
			Local w0# = 0, w1# = 0, w2# = 0, w3# = 0

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
			
			'Read tangents
			If tangentsStr.Length() > 1
				tx = Float(tangentsStr[j*3])
				ty = Float(tangentsStr[j*3+1])
				tz = Float(tangentsStr[j*3+2])
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
				u0 = Float(texcoordsStr[j*2])
				v0 = Float(texcoordsStr[j*2+1])
			End
			If texcoords2Str.Length() > 1
				u1 = Float(texcoords2Str[j*2])
				v1 = Float(texcoords2Str[j*2+1])
			Else
				u1 = u0
				v1 = v0
			End
			
			'Read bone indices
			If boneIndicesStr.Length() > 1
				b0 = Int(boneIndicesStr[j*4])
				b1 = Int(boneIndicesStr[j*4+1])
				b2 = Int(boneIndicesStr[j*4+2])
				b3 = Int(boneIndicesStr[j*4+3])
			End
			
			'Read bone weights
			If boneWeightsStr.Length() > 1
				w0 = Float(boneWeightsStr[j*4])
				w1 = Float(boneWeightsStr[j*4+1])
				w2 = Float(boneWeightsStr[j*4+2])
				w3 = Float(boneWeightsStr[j*4+3])
			End

			'Add vertex
			Local vertex:Int = surf.AddVertex(x, y, z, nx, ny, nz, r, g, b, a, u0, v0)
			surf.SetVertexTexCoords(vertex, u1, v1, 1)
			surf.SetVertexTangent(vertex, tx, ty, tz)
			
			'Set vertex bones and weights
			surf.SetVertexBone(vertex, 0, b0, w0)
			surf.SetVertexBone(vertex, 1, b1, w1)
			surf.SetVertexBone(vertex, 2, b2, w2)
			surf.SetVertexBone(vertex, 3, b3, w3)
		Next

		mesh.AddSurface(surf)
	Next

	'Parse number of frames
	mesh.NumFrames = Int(numFramesNode.value)

	'Parse bones
	For Local boneNode:XMLNode = Eachin boneNodes
		'Get bone data
		Local nameStr:String = boneNode.GetChild("name").value
		Local parentStr:String = boneNode.GetChild("parent").value
		Local invPoseStr:String[] = boneNode.GetChild("inv_pose").value.Split(",")
		Local surfacesStr:String[] = boneNode.GetChild("surfaces").value.Split(",")
		If invPoseStr.Length <> 16 Then Return Null

		'Create bone
		Local bone:Bone = Bone.Create(nameStr, mesh.GetBoneIndex(parentStr))
			
		'Set inverse pose matrix
		Local m:Float[] = New Float[16]
		For Local i:Int = 0 Until 16
			bone.InversePoseMatrix.M[i] = Float(invPoseStr[i])
		Next
			
		'Add to mesh
		mesh.AddBone(bone)

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
	Next

	Return mesh
End
