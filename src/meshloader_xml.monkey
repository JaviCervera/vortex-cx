Strict

Private
Import brl.filepath
Import mojo.app
Import vortex.src.bone
Import vortex.src.cache
Import vortex.src.material
Import vortex.src.math3d
Import vortex.src.mesh
Import vortex.src.renderer
Import vortex.src.surface
Import vortex.src.texture
Import vortex.src.xml

Public
Class MeshLoader_XML Final
Public
	Function Load:Mesh(filename:String, texFilter:Int)
		'Parse XML mesh
		Local xmlString$ = LoadString(filename)
		If xmlString = "" Then Return Null
		Local err:XMLError = New XMLError
		Local doc:XMLDoc = ParseXML(xmlString, err)
		If (doc = Null And err.error) Or doc.name <> "mesh" Then Return Null

		'Get arrays
		Local materialNodes:List<XMLNode> = doc.GetChild("materials").GetChildren("material")
		Local surfaceNodes:List<XMLNode> = doc.GetChild("surfaces").GetChildren("surface")
		Local lastFrameNode:XMLNode = doc.GetChild("last_frame")
		Local boneNodes:List<XMLNode> = doc.GetChild("bones").GetChildren("bone")
		If surfaceNodes.IsEmpty() Then Return Null

		'Parse materials
		Local materialsMap:StringMap<Material> = New StringMap<Material>
		For Local materialNode:XMLNode = Eachin materialNodes
			'Get material data
			Local nameStr:String = materialNode.GetChild("name").value
			Local blendStr:String = materialNode.GetChild("blend").value
			Local baseColorStr:String[] = materialNode.GetChild("base_color").value.Split(",")
			Local opacityStr:String = materialNode.GetChild("opacity").value
			Local shininess:Float = Float(materialNode.GetChild("shininess").value)
			Local cullingStr:String = materialNode.GetChild("culling").value
			Local depthWriteStr:String = materialNode.GetChild("depth_write").value
			Local baseTexStr:String = materialNode.GetChild("base_tex").value
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
			Local diffuseTex:Texture = Null
			If baseTexStr <> ""
				If ExtractDir(filename) <> "" Then baseTexStr = ExtractDir(filename) + "/" + baseTexStr
				diffuseTex = Cache.GetTexture(baseTexStr, texFilter)
			End

			'Create material
			Local material:Material = Material.Create(diffuseTex)
			If blendStr.ToLower() = "alpha" Then material.BlendMode = Renderer.BLEND_ALPHA
			If blendStr.ToLower() = "add" Then material.BlendMode = Renderer.BLEND_ADD
			If blendStr.ToLower() = "mul" Then material.BlendMode = Renderer.BLEND_MUL
			material.SetDiffuseColor(baseColor[0], baseColor[1], baseColor[2])
			material.Alpha = opacity
			material.Shininess = shininess
			material.Culling = culling
			material.DepthWrite = depthWrite
			materialsMap.Set(nameStr, material)
		Next

		'Create mesh object
		Local mesh:Mesh = Mesh.Create(filename)

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
				Local u# = 0, v# = 0
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
					u = Float(texcoordsStr[j*2])
					v = Float(texcoordsStr[j*2+1])
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
				Local vertex:Int = surf.AddVertex(x, y, z, nx, ny, nz, r, g, b, a, u, v)
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
				mTempMatrix.M[i] = Float(invPoseStr[i])
			Next
			bone.InversePoseMatrix = mTempMatrix
				
			'Add to mesh
			mesh.AddBone(bone)
				
			'Update mesh surfaces weights if needed
			#Rem
			If surfacesStr[0] <> ""
				For Local j:Int = 0 Until surfacesStr.Length()
					Local index:Int = Int(surfacesStr[j])
					Local surf:Surface = mesh.GetSurface(index)
					For Local v:Int = 0 Until surf.NumVertices
						bone.GlobalPoseMatrix.Mul(surf.GetVertexX(v), surf.GetVertexY(v), surf.GetVertexZ(v), 1)
						surf.SetVertexPosition(v, bone.GlobalPoseMatrix.ResultVector().X, bone.GlobalPoseMatrix.ResultVector().Y, bone.GlobalPoseMatrix.ResultVector().Z)
						surf.SetVertexBone(v, 0, i, 1)
					Next
					surf.Rebuild()
				Next
			End
			#End

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
Private
	Method New()
	End
	
	'Used to calculate pose matrix
	Global mTempMatrix:Mat4 = Mat4.Create()
End
