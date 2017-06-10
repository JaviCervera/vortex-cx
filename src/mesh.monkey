Strict

Private
Import brl.databuffer
Import brl.datastream
Import brl.filepath
Import mojo.app
Import vortex.src.bone
Import vortex.src.material
Import vortex.src.math3d
Import vortex.src.renderer
Import vortex.src.surface
Import vortex.src.texture
Import vortex.src.xml

Public
Class Mesh Final
Public
	Function Create:Mesh()
		Local mesh:Mesh = New Mesh
		mesh.mFilename = ""
		mesh.mSurfaces = New Surface[0]
		mesh.mBones = New Bone[0]
		mesh.mLastFrame = 0
		Return mesh
	End
	
	Function Create:Mesh(other:Mesh)
		Local mesh:Mesh = Mesh.Create()
		mesh.mFilename = other.mFilename
		mesh.mSurfaces = New Surface[other.mSurfaces.Length()]
		For Local i:Int = 0 Until other.mSurfaces.Length()
			mesh.mSurfaces[i] = Surface.Create(other.mSurfaces[i])
		Next
		mesh.mBones	= New Bone[other.mBones.Length()]
		For Local i:Int = 0 Until other.mBones.Length()
			mesh.mBones[i] = Bone.Create(other.mBones[i])
		Next
		mesh.mLastFrame = other.mLastFrame
		Return mesh
	End
	
	Function Load:Mesh(filename:String, texFilter:Int = Renderer.FILTER_TRILINEAR)
		If ExtractExt(filename).ToLower() = "xml"
			Return Mesh.LoadString(app.LoadString(filename), filename, texFilter)
		Else
			'Fix filename
			If String.FromChar(filename[0]) <> "/" And String.FromChar(filename[1]) <> ":" Then filename = "monkey://data/" + filename
			Local data:DataBuffer = DataBuffer.Load(filename)
			If Not data Then Return Null
			Return Mesh.LoadData(data, filename, texFilter)
		End
	End
	
	Function LoadData:Mesh(data:DataBuffer, filename:String, texFilter:Int = Renderer.FILTER_TRILINEAR)
		Local stream:DataStream = New DataStream(data)
		
		'Id
		Local id:String = stream.ReadString(4)
		If id <> "ME01" Then Return Null
		
		'Create mesh
		Local mesh:Mesh = Mesh.Create()
		mesh.Filename = filename
		
		'Surfaces
		Local numSurfaces:Int = stream.ReadShort()
		For Local s:Int = 0 Until numSurfaces
			Local surf:Surface = Surface.Create()
		
			'Material
			Local flags:Int = 0
			surf.Material.DiffuseRed = stream.ReadFloat()
			surf.Material.DiffuseGreen = stream.ReadFloat()
			surf.Material.DiffuseBlue = stream.ReadFloat()
			surf.Material.Opacity = stream.ReadFloat()
			surf.Material.BlendMode = stream.ReadByte()
			flags = stream.ReadByte()
			If flags & 1 Then surf.Material.Culling = True Else surf.Material.Culling = False
			If flags & 2 Then surf.Material.DepthWrite = True Else surf.Material.DepthWrite = False
			surf.Material.Shininess = stream.ReadFloat()
			surf.Material.RefractionCoef = stream.ReadFloat()
			
			'Material textures
			Local usedTexs:Int = 0
			Local strLen:Int = 0
			usedTexs = stream.ReadByte()
			If usedTexs & 1
				strLen = stream.ReadInt()
				surf.Material.DiffuseTexture = Texture.Load(stream.ReadString(strLen), texFilter)
			End
			If usedTexs & 2
				strLen = stream.ReadInt()
				Local cubeTexs:String[] = stream.ReadString(strLen).Split(",")
				surf.Material.DiffuseTexture = Texture.Load(cubeTexs[0], cubeTexs[1], cubeTexs[2], cubeTexs[3], cubeTexs[4], cubeTexs[5], texFilter)
			End
			If usedTexs & 4
				strLen = stream.ReadInt()
				surf.Material.NormalTexture = Texture.Load(stream.ReadString(strLen), texFilter)
			End
			If usedTexs & 8
				strLen = stream.ReadInt()
				surf.Material.Lightmap = Texture.Load(stream.ReadString(strLen), texFilter)
			End
			If usedTexs & 16
				strLen = stream.ReadInt()
				Local cubeTexs:String[] = stream.ReadString(strLen).Split(",")
				surf.Material.ReflectionTexture = Texture.Load(cubeTexs[0], cubeTexs[1], cubeTexs[2], cubeTexs[3], cubeTexs[4], cubeTexs[5], texFilter)
			End
			If usedTexs & 32
				strLen = stream.ReadInt()
				Local cubeTexs:String[] = stream.ReadString(strLen).Split(",")
				surf.Material.RefractionTexture = Texture.Load(cubeTexs[0], cubeTexs[1], cubeTexs[2], cubeTexs[3], cubeTexs[4], cubeTexs[5], texFilter)
			End
			
			'Number of indices and vertices
			Local numIndices:Int = stream.ReadInt()
			Local numVertices:Int = stream.ReadShort()
			
			'Indices
			For Local i:Int = 0 Until numIndices Step 3
				Local v0:Int = stream.ReadShort()
				Local v1:Int = stream.ReadShort()
				Local v2:Int = stream.ReadShort()
				surf.AddTriangle(v0, v1, v2)
			Next
			
			'Vertices
			For Local v:Int = 0 Until numVertices
				Local x:Float = stream.ReadFloat()
				Local y:Float = stream.ReadFloat()
				Local z:Float = stream.ReadFloat()
				Local nx:Float = stream.ReadFloat()
				Local ny:Float = stream.ReadFloat()
				Local nz:Float = stream.ReadFloat()
				Local tx:Float = stream.ReadFloat()
				Local ty:Float = stream.ReadFloat()
				Local tz:Float = stream.ReadFloat()
				Local r:Float = stream.ReadFloat()
				Local g:Float = stream.ReadFloat()
				Local b:Float = stream.ReadFloat()
				Local a:Float = stream.ReadFloat()
				Local u0:Float = stream.ReadFloat()
				Local v0:Float = stream.ReadFloat()
				Local u1:Float = stream.ReadFloat()
				Local v1:Float = stream.ReadFloat()
				Local b0:Int = stream.ReadShort()
				Local b1:Int = stream.ReadShort()
				Local b2:Int = stream.ReadShort()
				Local b3:Int = stream.ReadShort()
				Local w0:Float = stream.ReadFloat()
				Local w1:Float = stream.ReadFloat()
				Local w2:Float = stream.ReadFloat()
				Local w3:Float = stream.ReadFloat()
				
				surf.AddVertex(x, y, z, nx, ny, nz, r, g, b, a, u0, v0)
				surf.SetVertexTangent(v, tx, ty, tz)
				surf.SetVertexTexCoords(v, u1, v1, 1)
				surf.SetVertexBone(v, 0, b0, w0)
				surf.SetVertexBone(v, 1, b1, w1)
				surf.SetVertexBone(v, 2, b2, w2)
				surf.SetVertexBone(v, 3, b3, w3)
			Next
			
			mesh.AddSurface(surf)
		Next
		
		Return mesh
	End
	
	Function LoadString:Mesh(buffer:String, filename:String, texFilter:Int = Renderer.FILTER_TRILINEAR)
		'Parse XML mesh
		If buffer = "" Then Return Null
		Local err:XMLError = New XMLError
		Local doc:XMLDoc = ParseXML(buffer, err)
		If (doc = Null And err.error) Or doc.name <> "mesh" Then Return Null

		'Get arrays
		Local materialNodes:List<XMLNode> = doc.GetChild("materials").GetChildren("material")
		Local surfaceNodes:List<XMLNode> = doc.GetChild("surfaces").GetChildren("surface")
		Local lastFrameNode:XMLNode = doc.GetChild("last_frame")
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
				If ExtractDir(filename) <> "" Then baseTexStr = ExtractDir(filename) + "/" + baseTexStr
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
				If ExtractDir(filename) <> "" Then lightmapStr = ExtractDir(filename) + "/" + lightmapStr
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

		'Parse last frame
		mesh.LastFrame = Int(lastFrameNode.value)

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

	Method Free:Void(freeTextures:Bool = False)
		For Local surf:Surface = Eachin mSurfaces
			surf.Free(freeTextures)
		Next
	End
	
	Method Filename:Void(filename:String) Property
		mFilename = filename
	End

	Method Filename:String() Property
		Return mFilename
	End

	Method AddSurface:Void(surf:Surface)
		mSurfaces = mSurfaces.Resize(mSurfaces.Length() + 1)
		mSurfaces[mSurfaces.Length()-1] = surf
		surf.Rebuild()
	End

	Method NumSurfaces:Int() Property
		Return mSurfaces.Length()
	End

	Method GetSurface:Surface(index:Int)
		Return mSurfaces[index]
	End

	Method LastFrame:Void(lastFrame:Int) Property
		mLastFrame = lastFrame
	End

	Method LastFrame:Int() Property
		Return mLastFrame
	End
	
	Method AddBone:Void(bone:Bone)
		mBones = mBones.Resize(mBones.Length() + 1)
		mBones[mBones.Length() - 1] = bone
	End
	
	Method NumBones:Int() Property
		Return mBones.Length()
	End
	
	Method GetBone:Bone(index:Int)
		If index = -1 Then Return Null
		Return mBones[index]
	End
	
	Method Animate:Void(animMatrices:Mat4[], frame:Float, firstFrame:Int = 0, lastFrame:Int = 0)
		'We can only animate if the mesh has bones
		If mBones.Length() > 0
			'If we have not specified the ending frame of the sequence, take the last frame in the entire animation
			If lastFrame = 0 Then lastFrame = mLastFrame
			
			'Calculate animation matrix for all bones
			For Local i:Int = 0 Until NumBones
				Local parentIndex:Int = GetBone(i).ParentIndex
				If parentIndex > -1
					animMatrices[i].Set(animMatrices[parentIndex])
					GetBone(i).CalculateAnimMatrix(mTempMatrix, frame, firstFrame, lastFrame)
					animMatrices[i].Mul(mTempMatrix)
				Else
					GetBone(i).CalculateAnimMatrix(animMatrices[i], frame, firstFrame, lastFrame)
				End
			Next
			
			'Multiply every animation matrix by the inverse of the pose matrix
			For Local i:Int = 0 Until NumBones
				animMatrices[i].Mul(GetBone(i).InversePoseMatrix)
			Next
		End
	End
	
	Method GetBoneIndex:Int(name:String)
		For Local i:Int = 0 Until mBones.Length()
			If mBones[i].Name = name Then Return i
		Next
		Return -1
	End
Private
	Method New()
	End

	Field mFilename		: String
	Field mSurfaces		: Surface[]
	Field mBones		: Bone[]
	Field mLastFrame	: Int
	Global mTempMatrix	: Mat4 = Mat4.Create()
End
