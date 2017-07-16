Strict

Private
Import brl.datastream
Import brl.filestream
Import os
Import vortex

Public

Function MaterialSize:Int(mat:Material)
	'Fixed header
	Local size:Int = 16	'RGBA
	size += 1			'BlendMode
	size += 1			'Flags
	size += 4			'Shininess
	size += 4			'RefractCoef
	size += 1			'Used textures
	
	'Texture names
	If mat.DiffuseTexture Then size += 4 + mat.DiffuseTexture.Filename.Length
	If mat.NormalTexture Then size += 4 + mat.NormalTexture.Filename.Length
	If mat.Lightmap Then size += 4 + mat.Lightmap.Filename.Length
	If mat.ReflectionTexture Then size += 4 + mat.ReflectionTexture.Filename.Length
	If mat.RefractionTexture Then size += 4 + mat.RefractionTexture.Filename.Length
	
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
	If mat.DiffuseTexture Then stream.WriteInt(mat.DiffuseTexture.Filename.Length); stream.WriteString(mat.DiffuseTexture.Filename)
	If mat.NormalTexture Then stream.WriteInt(mat.NormalTexture.Filename.Length); stream.WriteString(mat.NormalTexture.Filename)
	If mat.Lightmap Then stream.WriteInt(mat.Lightmap.Filename.Length); stream.WriteString(mat.Lightmap.Filename)
	If mat.ReflectionTexture Then stream.WriteInt(mat.ReflectionTexture.Filename.Length); stream.WriteString(mat.ReflectionTexture.Filename)
	If mat.RefractionTexture Then stream.WriteInt(mat.RefractionTexture.Filename.Length); stream.WriteString(mat.RefractionTexture.Filename)
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