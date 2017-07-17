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

Function MaterialSize:Int(mat:Material)
	'Fixed header
	Local size:Int = 16	'RGBA
	size += 1			'BlendMode
	size += 1			'Flags
	size += 4			'Shininess
	size += 4			'RefractCoef
	size += 1			'Used textures
	
	'Texture names
	If mat.DiffuseTexture Then size += 4 + StripDir(mat.DiffuseTexture.Filename).Length
	If mat.NormalTexture Then size += 4 + StripDir(mat.NormalTexture.Filename).Length
	If mat.Lightmap Then size += 4 + StripDir(mat.Lightmap.Filename).Length
	If mat.ReflectionTexture Then size += 4 + StripDir(mat.ReflectionTexture.Filename).Length
	If mat.RefractionTexture Then size += 4 + StripDir(mat.RefractionTexture.Filename).Length
	
	Return size
End

Function NormalsSize:Int(surf:Surface)
	For Local v:Int = 0 Until surf.NumVertices
		If surf.GetVertexNX(v) <> 0 Or surf.GetVertexNY(v) <> 0 Or surf.GetVertexNZ(v) <> 0
			Return surf.NumVertices * 3 * 4
		End
	Next
	Return 0
End

Function TangentsSize:Int(surf:Surface)
	For Local v:Int = 0 Until surf.NumVertices
		If surf.GetVertexTX(v) <> 0 Or surf.GetVertexTY(v) <> 0 Or surf.GetVertexTZ(v) <> 0
			Return surf.NumVertices * 3 * 4
		End
	Next
	Return 0
End

Function ColorsSize:Int(surf:Surface)
	For Local v:Int = 0 Until surf.NumVertices
		If surf.GetVertexRed(v) <> 1 Or surf.GetVertexGreen(v) <> 1 Or surf.GetVertexBlue(v) <> 1 Or surf.GetVertexAlpha(v) <> 1
			Return surf.NumVertices * 4 * 4
		End
	Next
	Return 0
End

Function Tex0Size:Int(surf:Surface)
	For Local v:Int = 0 Until surf.NumVertices
		If surf.GetVertexU(v) <> 0 Or surf.GetVertexV(v) <> 0
			Return surf.NumVertices * 2 * 4
		End
	Next
	Return 0
End

Function Tex1Size:Int(surf:Surface)
	For Local v:Int = 0 Until surf.NumVertices
		If surf.GetVertexU(v, 1) <> surf.GetVertexU(v) Or surf.GetVertexV(v, 1) <> surf.GetVertexV(v)
			Return surf.NumVertices * 2 * 4
		End
	Next
	Return 0
End

Function WeightsSize:Int(surf:Surface)
	For Local v:Int = 0 Until surf.NumVertices
		If surf.GetVertexBoneIndex(v, 0) <> -1 Or surf.GetVertexBoneIndex(v, 1) <> -1 Or surf.GetVertexBoneIndex(v, 2) <> -1 Or surf.GetVertexBoneIndex(v, 3) <> -1
			Return (surf.NumVertices * 4 * 2) + (surf.NumVertices * 4 * 4)
		End
	Next
	Return 0
End

Function SurfaceSize:Int(surf:Surface, includeBones:Bool)
	'Header
	Local size:Int = MaterialSize(surf.Material)	'Material
	size += 4										'NumIndices
	size += 2										'NumVertices
	size += 1										'Vertex flags
	
	'Indices and vertices
	size += surf.NumTriangles * 6					'Indices
	size += surf.NumVertices * 3 * 4				'Vertex positions
	size += NormalsSize(surf)						'Vertex normals
	size += TangentsSize(surf)						'Vertex tangents
	size += ColorsSize(surf)						'Vertex colors
	size += Tex0Size(surf)							'Vertex tex coords 0
	size += Tex1Size(surf)							'Vertex tex coords 1
	If includeBones Then size += WeightsSize(surf)	'Vertex bones
	
	Return size
End

Function MeshSize:Int(mesh:Mesh, includeBones:Bool)
	'Fixed header
	Local size:Int = 4	'Id & version
	size += 2			'Number of surfaces
	
	'Surfaces
	For Local i:Int = 0 Until mesh.NumSurfaces
		size += SurfaceSize(mesh.GetSurface(i), includeBones)
	Next
	
	Return size 
End

Function WriteMaterialData:Void(stream:DataStream, mat:Material)
	'Color
	stream.WriteFloat(mat.DiffuseRed)
	stream.WriteFloat(mat.DiffuseGreen)
	stream.WriteFloat(mat.DiffuseBlue)
	stream.WriteFloat(mat.Opacity)
	
	'Blend mode
	stream.WriteByte(mat.BlendMode)
	
	'Flags
	Local flags:Int = 0
	If mat.Culling Then flags |= 1
	If mat.DepthWrite Then flags |= 2
	stream.WriteByte(flags)
	
	'Shininess
	stream.WriteFloat(mat.Shininess)
	
	'Refraction coef
	stream.WriteFloat(mat.RefractionCoef)
	
	'Used textures
	Local usedTexs:Int = 0	'1=Diffuse2D,2=DiffuseCube,4=Normal,8=Lightmap,16=Reflect,32=Refract
	If mat.DiffuseTexture And Not mat.DiffuseTexture.Cubic Then usedTexs |= 1
	If mat.DiffuseTexture And mat.DiffuseTexture.Cubic Then usedTexs |= 2
	If mat.NormalTexture Then usedTexs |= 4
	If mat.Lightmap Then usedTexs |= 8
	If mat.ReflectionTexture Then usedTexs |= 16
	If mat.RefractionTexture Then usedTexs |= 32
	stream.WriteByte(usedTexs)
	
	'Texture names
	Local filename:String = ""
	If mat.DiffuseTexture Then filename = StripDir(mat.DiffuseTexture.Filename); stream.WriteInt(filename.Length); stream.WriteString(filename)
	If mat.NormalTexture Then filename = StripDir(mat.NormalTexture.Filename); stream.WriteInt(filename.Length); stream.WriteString(filename)
	If mat.Lightmap Then filename = StripDir(mat.Lightmap.Filename); stream.WriteInt(filename.Length); stream.WriteString(filename)
	If mat.ReflectionTexture Then filename = StripDir(mat.ReflectionTexture.Filename); stream.WriteInt(filename.Length); stream.WriteString(filename)
	If mat.RefractionTexture Then filename = StripDir(mat.RefractionTexture.Filename); stream.WriteInt(filename.Length); stream.WriteString(filename)
End

Function WriteSurfaceData:Void(stream:DataStream, surf:Surface, includeBones:Bool)
	'Material
	WriteMaterialData(stream, surf.Material)
	
	'Number of indices and vertices
	stream.WriteInt(surf.NumTriangles * 3)
	stream.WriteShort(surf.NumVertices)
	
	'Vertex flags
	Local vertexFlags:Int = 0
	If NormalsSize(surf) > 0 Then vertexFlags |= 1
	If TangentsSize(surf) > 0 Then vertexFlags |= 2
	If ColorsSize(surf) > 0	Then vertexFlags |= 4
	If Tex0Size(surf) > 0 Then vertexFlags |= 8
	If Tex1Size(surf) > 0 Then vertexFlags |= 16
	If includeBones And WeightsSize(surf) > 0 Then vertexFlags |= 32
	stream.WriteByte(vertexFlags)
	
	'Indices
	For Local t:Int = 0 Until surf.NumTriangles
		stream.WriteShort(surf.GetTriangleV0(t))
		stream.WriteShort(surf.GetTriangleV1(t))
		stream.WriteShort(surf.GetTriangleV2(t))
	Next
	
	'Vertices
	For Local v:Int = 0 Until surf.NumVertices
		stream.WriteFloat(surf.GetVertexX(v))
		stream.WriteFloat(surf.GetVertexY(v))
		stream.WriteFloat(surf.GetVertexZ(v))
		
		If vertexFlags & 1 = 1
			stream.WriteFloat(surf.GetVertexNX(v))
			stream.WriteFloat(surf.GetVertexNY(v))
			stream.WriteFloat(surf.GetVertexNZ(v))
		End
		
		If vertexFlags & 2 = 2
			stream.WriteFloat(surf.GetVertexTX(v))
			stream.WriteFloat(surf.GetVertexTY(v))
			stream.WriteFloat(surf.GetVertexTZ(v))
		End
		
		If vertexFlags & 4 = 4
			stream.WriteFloat(surf.GetVertexRed(v))
			stream.WriteFloat(surf.GetVertexGreen(v))
			stream.WriteFloat(surf.GetVertexBlue(v))
			stream.WriteFloat(surf.GetVertexAlpha(v))
		End
		
		If vertexFlags & 8 = 8
			stream.WriteFloat(surf.GetVertexU(v, 0))
			stream.WriteFloat(surf.GetVertexV(v, 0))
		End
		
		If vertexFlags & 16 = 16
			stream.WriteFloat(surf.GetVertexU(v, 1))
			stream.WriteFloat(surf.GetVertexV(v, 1))
		End
		
		If vertexFlags & 32 = 32
			stream.WriteShort(surf.GetVertexBoneIndex(v, 0))
			stream.WriteShort(surf.GetVertexBoneIndex(v, 1))
			stream.WriteShort(surf.GetVertexBoneIndex(v, 2))
			stream.WriteShort(surf.GetVertexBoneIndex(v, 3))
			stream.WriteFloat(surf.GetVertexBoneWeight(v, 0))
			stream.WriteFloat(surf.GetVertexBoneWeight(v, 1))
			stream.WriteFloat(surf.GetVertexBoneWeight(v, 2))
			stream.WriteFloat(surf.GetVertexBoneWeight(v, 3))
		End
	Next
End

Function CreateMeshData:DataBuffer(mesh:Mesh, includeBones:Bool)
	Local stream:DataStream = New DataStream(New DataBuffer(MeshSize(mesh, includeBones)))
	
	'Id & version
	stream.WriteByte("M"[0])
	stream.WriteByte("E"[0])
	stream.WriteByte("0"[0])
	stream.WriteByte("1"[0])
	
	'Number of surfaces
	stream.WriteShort(mesh.NumSurfaces)
	
	'Surfaces
	For Local i:Int = 0 Until mesh.NumSurfaces
		WriteSurfaceData(stream, mesh.GetSurface(i), includeBones)
	Next
	
	Return stream.Data
End

Function BoneSize:Int(bone:Bone)
	Local size:Int = 4 + bone.Name.Length	'Name
	size += 4								'Parent index
	size += 16 * 4							'Inv pose matrix
	Return size
End

Function SkeletonSize:Int(mesh:Mesh)
	'Fixed header
	Local size:Int = 4	'Id & version
	size += 2			'Number of bones
	
	'Bones
	For Local i:Int = 0 Until mesh.NumBones
		size += BoneSize(mesh.GetBone(i))
	Next
	
	Return size 
End

Function WriteBoneData:Void(stream:DataStream, bone:Bone)
	'Name
	stream.WriteInt(bone.Name.Length)
	stream.WriteString(bone.Name)
	
	'Parent index
	stream.WriteInt(bone.ParentIndex)
	
	'Inv pose matrix
	For Local i:Int = 0 Until 16
		stream.WriteFloat(bone.InversePoseMatrix.M[i])
	Next
End

Function CreateSkeletonData:DataBuffer(mesh:Mesh)
	Local stream:DataStream = New DataStream(New DataBuffer(SkeletonSize(mesh)))
	
	'Id & version
	stream.WriteByte("S"[0])
	stream.WriteByte("K"[0])
	stream.WriteByte("0"[0])
	stream.WriteByte("1"[0])
	
	'Number of bones
	stream.WriteShort(mesh.NumBones)
	
	'Bones
	For Local b:Int = 0 Until mesh.NumBones
		WriteBoneData(stream, mesh.GetBone(b))
	Next
	
	Return stream.Data
End

Function BoneAnimationSize:Int(bone:Bone)
	'Position keys
	Local size:Int = 2						'Num keys
	size += bone.NumPositionKeys * 2		'Indices
	size += bone.NumPositionKeys * 3 * 4	'Positions
	
	'Rotation keys
	size += 2								'Num keys
	size += bone.NumRotationKeys * 2		'Indices
	size += bone.NumRotationKeys * 4 * 4	'Rotations
	
	'Scale keys
	size += 2								'Num keys
	size += bone.NumScaleKeys * 2			'Indices
	size += bone.NumScaleKeys * 3 * 4		'Scales
	
	Return size
End

Function AnimationSize:Int(mesh:Mesh)
	'Fixed header
	Local size:Int = 4	'Id & version
	size += 2			'Number of frames
	size += 2			'Number of bones
	
	'Animations
	For Local i:Int = 0 Until mesh.NumBones
		size += BoneAnimationSize(mesh.GetBone(i))
	Next
	
	Return size
End

Function WriteAnimationData:Void(stream:DataStream, bone:Bone)
	'Position keys
	stream.WriteShort(bone.NumPositionKeys)
	For Local i:Int = 0 Until bone.NumPositionKeys
		stream.WriteShort(bone.GetPositionKeyFrame(i))
		stream.WriteFloat(bone.GetPositionKeyX(i))
		stream.WriteFloat(bone.GetPositionKeyY(i))
		stream.WriteFloat(bone.GetPositionKeyZ(i))
	Next
	
	'Rotation keys
	stream.WriteShort(bone.NumRotationKeys)
	For Local i:Int = 0 Until bone.NumRotationKeys
		stream.WriteShort(bone.GetRotationKeyFrame(i))
		stream.WriteFloat(bone.GetRotationKeyW(i))
		stream.WriteFloat(bone.GetRotationKeyX(i))
		stream.WriteFloat(bone.GetRotationKeyY(i))
		stream.WriteFloat(bone.GetRotationKeyZ(i))
	Next
	
	'Scale keys
	stream.WriteShort(bone.NumScaleKeys)
	For Local i:Int = 0 Until bone.NumScaleKeys
		stream.WriteShort(bone.GetScaleKeyFrame(i))
		stream.WriteFloat(bone.GetScaleKeyX(i))
		stream.WriteFloat(bone.GetScaleKeyY(i))
		stream.WriteFloat(bone.GetScaleKeyZ(i))
	Next
End

Function CreateAnimationData:DataBuffer(mesh:Mesh)
	Local stream:DataStream = New DataStream(New DataBuffer(AnimationSize(mesh)))
	
	'Id & version
	stream.WriteByte("A"[0])
	stream.WriteByte("N"[0])
	stream.WriteByte("0"[0])
	stream.WriteByte("1"[0])
	
	'Number of frames
	stream.WriteShort(mesh.NumFrames)
	
	'Number of bones
	stream.WriteShort(mesh.NumBones)
	
	'Animation data
	For Local b:Int = 0 Until mesh.NumBones
		WriteAnimationData(stream, mesh.GetBone(b))
	Next
	
	Return stream.Data
End

Function SaveMesh:Void(mesh:Mesh, filename:String, includeBones:Bool)
	Local meshData:DataBuffer = CreateMeshData(mesh, includeBones)
	Local fileStream:FileStream = New FileStream(filename, "w")
	fileStream.WriteAll(meshData, 0, meshData.Length)
	fileStream.Close()
End

Function SaveSkeleton:Void(mesh:Mesh, filename:String)
	Local skeletonData:DataBuffer = CreateSkeletonData(mesh)
	Local fileStream:FileStream = New FileStream(filename, "w")
	fileStream.WriteAll(skeletonData, 0, skeletonData.Length)
	fileStream.Close()
End

Function SaveAnimation:Void(mesh:Mesh, filename:String)
	Local animationData:DataBuffer = CreateAnimationData(mesh)
	Local fileStream:FileStream = New FileStream(filename, "w")
	fileStream.WriteAll(animationData, 0, animationData.Length)
	fileStream.Close()
End


Function SaveMeshXML:Void(mesh:Mesh, filename:String, exportAnimations:Bool)
	Local buffer:String = "<mesh>~n"
	
	'Export materials
	buffer += "~t<materials>~n"
	For Local i:Int = 0 Until mesh.NumSurfaces
		Local mat:Material = mesh.GetSurface(i).Material
		buffer += "~t~t<material>~n"
		buffer += "~t~t~t<name>Material #" + i + "</name>~n"
		buffer += "~t~t~t<blend>"
		Select mat.BlendMode
		Case Renderer.BLEND_ALPHA
			buffer += "alpha"
		Case Renderer.BLEND_ADD
			buffer += "add"
		Case Renderer.BLEND_MUL
			buffer += "mul"
		End
		buffer += "</blend>~n"
		If mat.DiffuseTexture Then buffer += "~t~t~t<diffuse_tex>" + StripDir(mat.DiffuseTexture.Filename) + "</diffuse_tex>~n"
		If mat.Lightmap Then buffer += "~t~t~t<lightmap>" + StripDir(mat.Lightmap.Filename) + "</lightmap>~n"
		buffer += "~t~t~t<diffuse_color>" + mat.DiffuseRed + "," + mat.DiffuseGreen + "," + mat.DiffuseBlue + "</diffuse_color>~n"
		buffer += "~t~t~t<opacity>" + mat.Opacity + "</opacity>~n"
		buffer += "~t~t~t<shininess>" + mat.Shininess + "</shininess>~n"
		If mat.Culling Then buffer += "~t~t~t<culling>true</culling>~n" Else buffer += "~t~t~t<culling>false</culling>~n"
		If mat.DepthWrite Then buffer += "~t~t~t<depth_write>true</depth_write>~n" Else buffer += "~t~t~t<depth_write>false</depth_write>~n"
		buffer += "~t~t</material>~n"
	Next
	buffer += "~t</materials>~n"
	
	'Export surfaces
	buffer += "~t<surfaces>~n"
	For Local i:Int = 0 Until mesh.NumSurfaces
		Local surf:Surface = mesh.GetSurface(i)
		buffer += "~t~t<surface>~n"
		buffer += "~t~t~t<material>Material #" + i + "</material>~n"
		buffer += "~t~t~t<indices>"
		For Local t:Int = 0 Until surf.NumTriangles
			buffer += surf.GetTriangleV0(t) + "," + surf.GetTriangleV1(t) + "," + surf.GetTriangleV2(t)
			If t < surf.NumTriangles - 1 Then buffer += ","
		Next
		buffer += "</indices>~n"
		buffer += "~t~t~t<coords>"
		For Local v:Int = 0 Until surf.NumVertices
			buffer += surf.GetVertexX(v) + "," + surf.GetVertexY(v) + "," + surf.GetVertexZ(v)
			If v < surf.NumVertices - 1 Then buffer += ","
		Next
		buffer += "</coords>~n"
		buffer += "~t~t~t<normals>"
		For Local v:Int = 0 Until surf.NumVertices
			buffer += surf.GetVertexNX(v) + "," + surf.GetVertexNY(v) + "," + surf.GetVertexNZ(v)
			If v < surf.NumVertices - 1 Then buffer += ","
		Next
		buffer += "</normals>~n"
		buffer += "~t~t~t<texcoords>"
		For Local v:Int = 0 Until surf.NumVertices
			buffer += surf.GetVertexU(v) + "," + surf.GetVertexV(v)
			If v < surf.NumVertices - 1 Then buffer += ","
		Next
		buffer += "</texcoords>~n"
		buffer += "~t~t~t<texcoords2>"
		For Local v:Int = 0 Until surf.NumVertices
			buffer += surf.GetVertexU(v, 1) + "," + surf.GetVertexV(v, 1)
			If v < surf.NumVertices - 1 Then buffer += ","
		Next
		buffer += "</texcoords2>~n"
		If exportAnimations
			buffer += "~t~t~t<bone_indices>"
			For Local v:Int = 0 Until surf.NumVertices
				buffer += surf.GetVertexBoneIndex(v, 0) + "," + surf.GetVertexBoneIndex(v, 1) + "," + surf.GetVertexBoneIndex(v, 2) + "," + surf.GetVertexBoneIndex(v, 3)
				If v < surf.NumVertices - 1 Then buffer += ","
			Next
			buffer += "</bone_indices>~n"
			buffer += "~t~t~t<bone_weights>"
			For Local v:Int = 0 Until surf.NumVertices
				buffer += surf.GetVertexBoneWeight(v, 0) + "," + surf.GetVertexBoneWeight(v, 1) + "," + surf.GetVertexBoneWeight(v, 2) + "," + surf.GetVertexBoneWeight(v, 3)
				If v < surf.NumVertices - 1 Then buffer += ","
			Next
			buffer += "</bone_weights>~n"
		End
		buffer += "~t~t</surface>~n"
	Next
	buffer += "~t</surfaces>~n"
	
	'Export last frame
	If exportAnimations Then buffer += "~t<last_frame>" + mesh.LastFrame + "</last_frame>~n"
	
	'Export bones
	If exportAnimations
		buffer += "~t<bones>~n"
		For Local i:Int = 0 Until mesh.NumBones
			Local bone:Bone = mesh.GetBone(i)
			buffer += "~t~t<bone>~n"
			buffer += "~t~t~t<name>" + bone.Name + "</name>~n"
			If bone.ParentIndex > -1 Then buffer += "~t~t~t<parent>" + mesh.GetBone(bone.ParentIndex).Name + "</parent>~n"
			buffer += "~t~t~t<inv_pose>"
			For Local m:Int = 0 Until 16
				buffer += bone.InversePoseMatrix.M[m]
				If m < 15 Then buffer += ","
			Next
			buffer += "</inv_pose>~n"
			If bone.NumPositionKeys > 0
				buffer += "~t~t~t<positions>"
				For Local j:Int = 0 Until bone.NumPositionKeys
					buffer += bone.GetPositionKeyFrame(j) + "," + bone.GetPositionKeyX(j) + "," + bone.GetPositionKeyY(j) + "," + bone.GetPositionKeyZ(j)
					If j < bone.NumPositionKeys - 1 Then buffer += ","
				Next
				buffer += "</positions>~n"
			End
			If bone.NumRotationKeys > 0
				buffer += "~t~t~t<rotations>"
				For Local j:Int = 0 Until bone.NumRotationKeys
					buffer += bone.GetRotationKeyFrame(j) + "," + bone.GetRotationKeyW(j) + "," + bone.GetRotationKeyX(j) + "," + bone.GetRotationKeyY(j) + "," + bone.GetRotationKeyZ(j)
					If j < bone.NumRotationKeys - 1 Then buffer += ","
				Next
				buffer += "</rotations>~n"
			End
			If bone.NumScaleKeys > 0
				buffer += "~t~t~t<scales>"
				For Local j:Int = 0 Until bone.NumScaleKeys
					buffer += bone.GetScaleKeyFrame(j) + "," + bone.GetScaleKeyX(j) + "," + bone.GetScaleKeyY(j) + "," + bone.GetScaleKeyZ(j)
					If j < bone.NumScaleKeys - 1 Then buffer += ","
				Next
				buffer += "</scales>~n"
			End
			buffer += "~t~t</bone>~n"
		Next
		buffer += "~t</bones>~n"
	End
	
	buffer += "</mesh>~n"
	SaveString(buffer, filename)
End

Function CreateCube:Mesh()
	Local surf:Surface = Surface.Create()
	
	'Front face
	surf.AddVertex(-0.5,  0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5,  0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex(-0.5, -0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, -0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddTriangle(0, 1, 2)
	surf.AddTriangle(3, 2, 1)
	
	'Back face
	surf.AddVertex( 0.5,  0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddVertex(-0.5,  0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddVertex( 0.5, -0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddVertex(-0.5, -0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddTriangle(4, 5, 6)
	surf.AddTriangle(7, 6, 5)
	
	'Left face
	surf.AddVertex(-0.5,  0.5,  0.5,  -1, 0, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddVertex(-0.5,  0.5, -0.5,  -1, 0, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddVertex(-0.5, -0.5,  0.5,  -1, 0, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddVertex(-0.5, -0.5, -0.5,  -1, 0, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddTriangle(8, 9, 10)
	surf.AddTriangle(11, 10, 9)
	
	'Right face
	surf.AddVertex(0.5,  0.5, -0.5,  1, 0, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddVertex(0.5,  0.5,  0.5,  1, 0, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddVertex(0.5, -0.5, -0.5,  1, 0, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddVertex(0.5, -0.5,  0.5,  1, 0, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddTriangle(12, 13, 14)
	surf.AddTriangle(15, 14, 13)
	
	'Top face
	surf.AddVertex(-0.5, 0.5,  0.5,  0, 1, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, 0.5,  0.5,  0, 1, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex(-0.5, 0.5, -0.5,  0, 1, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, 0.5, -0.5,  0, 1, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddTriangle(16, 17, 18)
	surf.AddTriangle(19, 18, 17)
	
	'Bottom face
	surf.AddVertex(-0.5, -0.5, -0.5,  0, -1, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, -0.5, -0.5,  0, -1, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex(-0.5, -0.5,  0.5,  0, -1, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, -0.5,  0.5,  0, -1, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddTriangle(20, 21, 22)
	surf.AddTriangle(23, 22, 21)

	'Create mesh with surface
	Local cube:Mesh = Mesh.Create()
	cube.AddSurface(surf)
	
	Return cube
End

Function RotateMesh:Void(mesh:Mesh, pitch:Float, yaw:Float, roll:Float)
	'Get rotation quaternion
	Local q:Quat = Quat.Create()
	q.SetEuler(pitch, yaw, roll)
	q.CalcAxis()
	
	'Define rotation matrix
	Local mat:Mat4 = Mat4.Create()
	mat.Rotate(q.Angle(), q.ResultVector().X, q.ResultVector().Y, q.ResultVector().Z)
	
	'Rotate all surfaces
	For Local i:Int = 0 Until mesh.NumSurfaces
		RotateSurface(mesh.GetSurface(i), mat)
	Next
	
	'Rotate all bones
	For Local i:Int = 0 Until mesh.NumBones
		RotateBone(mesh.GetBone(i), mat, q)
	Next
End

Function RotateSurface:Void(surf:Surface, mat:Mat4)	
	For Local i:Int = 0 Until surf.NumVertices
		mat.Mul(surf.GetVertexX(i), surf.GetVertexY(i), surf.GetVertexZ(i), 1)
		surf.SetVertexPosition(i, mat.ResultVector().X, mat.ResultVector().Y, mat.ResultVector().Z)
		mat.Mul(surf.GetVertexNX(i), surf.GetVertexNY(i), surf.GetVertexNZ(i), 1)
		surf.SetVertexNormal(i, mat.ResultVector().X, mat.ResultVector().Y, mat.ResultVector().Z)
		mat.Mul(surf.GetVertexTX(i), surf.GetVertexTY(i), surf.GetVertexTZ(i), 1)
		surf.SetVertexTangent(i, mat.ResultVector().X, mat.ResultVector().Y, mat.ResultVector().Z)
	Next
	
	surf.Rebuild()
End

Function RotateBone:Void(bone:Bone, mat:Mat4, q:Quat)
	'TODO
End
