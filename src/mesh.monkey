Strict

Private
Import brl.databufferf
Import brl.datastream
Import brl.filepath
Import mojo.app
Import vortex.src.bone
Import vortex.src.material
Import vortex.src.math3d
Import vortex.src.renderer
Import vortex.src.surface
Import vortex.src.texture

Public
Class Mesh Final
Public
	Function Create:Mesh()
		Local mesh:Mesh = New Mesh
		mesh.mFilename = ""
		mesh.mSurfaces = New Surface[0]
		mesh.mBones = New Bone[0]
		mesh.mNumFrames = 0
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
		mesh.mNumFrames = other.mNumFrames
		Return mesh
	End
	
	Function Load:Mesh(filename:String, skeletonFilename:String = "", animationFilename:String = "", texFilter:Int = Renderer.FILTER_TRILINEAR)
		'Fix filenames
		If filename.Length > 2 And String.FromChar(filename[0]) <> "/" And String.FromChar(filename[1]) <> ":" Then filename = "monkey://data/" + filename
		If skeletonFilename.Length > 2 And String.FromChar(skeletonFilename[0]) <> "/" And String.FromChar(skeletonFilename[1]) <> ":" Then skeletonFilename = "monkey://data/" + skeletonFilename
		If animationFilename.Length > 2 And String.FromChar(animationFilename[0]) <> "/" And String.FromChar(animationFilename[1]) <> ":" Then animationFilename = "monkey://data/" + animationFilename
		
		'Load mesh data
		Local data:DataBuffer = DataBuffer.Load(filename)
		If Not data Then Return Null
		Local mesh:Mesh = Mesh.LoadData(data, filename, texFilter)
		data.Discard()
		
		'Load skeleton data
		data = DataBuffer.Load(skeletonFilename)
		If data
			mesh.LoadSkeletonData(data)
			data.Discard()
		End
		
		'Load animation data
		data = DataBuffer.Load(animationFilename)
		If data
			mesh.LoadAnimationData(data)
			data.Discard()
		End
		
		Return mesh
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
			
			'Vertex flags
			Local vertexFlags:Int = stream.ReadByte()
			
			'Indices
			For Local i:Int = 0 Until numIndices Step 3
				Local v0:Int = stream.ReadShort()
				Local v1:Int = stream.ReadShort()
				Local v2:Int = stream.ReadShort()
				surf.AddTriangle(v0, v1, v2)
			Next
			
			'Vertices
			For Local v:Int = 0 Until numVertices
				'Load vertices
				Local x:Float = stream.ReadFloat()
				Local y:Float = stream.ReadFloat()
				Local z:Float = stream.ReadFloat()
				
				'Load normals if present
				Local nx:Float = 0
				Local ny:Float = 0
				Local nz:Float = 0
				If vertexFlags & 1 = 1
					nx = stream.ReadFloat()
					ny = stream.ReadFloat()
					nz = stream.ReadFloat()
				End
				
				'Load tangents if present
				Local tx:Float = 0
				Local ty:Float = 0
				Local tz:Float = 0
				If vertexFlags & 2 = 2
					tx = stream.ReadFloat()
					ty = stream.ReadFloat()
					tz = stream.ReadFloat()
				End
				
				'Load colors if present
				Local r:Float = 1
				Local g:Float = 1
				Local b:Float = 1
				Local a:Float = 1
				If vertexFlags & 4 = 4
					r = stream.ReadFloat()
					g = stream.ReadFloat()
					b = stream.ReadFloat()
					a = stream.ReadFloat()
				End
				
				'Load texcoords0 if present
				Local u0:Float = 0
				Local v0:Float = 0
				If vertexFlags & 8 = 8
					u0 = stream.ReadFloat()
					v0 = stream.ReadFloat()
				End
				
				'Load texcoords1 if present
				Local u1:Float = u0
				Local v1:Float = v0
				If vertexFlags & 16 = 16
					u1 = stream.ReadFloat()
					v1 = stream.ReadFloat()
				End
				
				'Load bones if present
				Local b0:Int = -1
				Local b1:Int = -1
				Local b2:Int = -1
				Local b3:Int = -1
				Local w0:Float = 0
				Local w1:Float = 0
				Local w2:Float = 0
				Local w3:Float = 0
				If vertexFlags & 32 = 32
					b0 = stream.ReadShort()
					b1 = stream.ReadShort()
					b2 = stream.ReadShort()
					b3 = stream.ReadShort()
					w0 = stream.ReadFloat()
					w1 = stream.ReadFloat()
					w2 = stream.ReadFloat()
					w3 = stream.ReadFloat()
				End
				
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
	
	Method LoadSkeletonData:Bool(data:DataBuffer)
		Local stream:DataStream = New DataStream(data)
		
		'Id
		Local id:String = stream.ReadString(4)
		If id <> "SK01" Then Return False
		
		'Number of bones
		Local numBones:Int = stream.ReadShort()
		
		'Bones
		For Local b:Int = 0 Until numBones
			'Name
			Local nameLen:Int = stream.ReadInt()
			Local name:String = stream.ReadString(nameLen)
			
			'Parent index
			Local parentIndex:Int = stream.ReadInt()
			
			'Inv pose matrix
			For Local i:Int = 0 Until 16
				mTempMatrix.M[i] = stream.ReadFloat()
			Next
		
			'Create and add bone
			Local bone:Bone = Bone.Create(name, parentIndex)
			bone.InversePoseMatrix = mTempMatrix
			AddBone(bone)
		Next
		
		Return True
	End
	
	Method LoadAnimationData:Bool(data:DataBuffer)
		Local stream:DataStream = New DataStream(data)
		
		'Id
		Local id:String = stream.ReadString(4)
		If id <> "AN01" Then Return False
		
		'Number of frames
		Local numFrames:Int = stream.ReadShort()
		
		'Number of bones
		Local numBones:Int = stream.ReadShort()
		
		'Bone animations
		Local firstFrame:Int = NumFrames
		For Local i:Int = 0 Until numBones
			'Position keys
			Local numKeys:Int = stream.ReadShort()
			For Local k:Int = 0 Until numKeys
				Local frame:Int = stream.ReadShort()
				Local x:Float = stream.ReadFloat()
				Local y:Float = stream.ReadFloat()
				Local z:Float = stream.ReadFloat()
				GetBone(i).AddPositionKey(firstFrame + frame, x, y, z)
			Next
			
			'Rotation keys
			numKeys = stream.ReadShort()
			For Local k:Int = 0 Until numKeys
				Local frame:Int = stream.ReadShort()
				Local w:Float = stream.ReadFloat()
				Local x:Float = stream.ReadFloat()
				Local y:Float = stream.ReadFloat()
				Local z:Float = stream.ReadFloat()
				GetBone(i).AddRotationKey(firstFrame + frame, w, x, y, z)
			Next
			
			'Scale keys
			numKeys = stream.ReadShort()
			For Local k:Int = 0 Until numKeys
				Local frame:Int = stream.ReadShort()
				Local x:Float = stream.ReadFloat()
				Local y:Float = stream.ReadFloat()
				Local z:Float = stream.ReadFloat()
				GetBone(i).AddScaleKey(firstFrame + frame, x, y, z)
			Next
		Next
		
		NumFrames += numFrames
		
		Return True
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

	Method NumFrames:Void(numFrames:Int) Property
		mNumFrames = numFrames
	End

	Method NumFrames:Int() Property
		Return mNumFrames
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
			If lastFrame = 0 Then lastFrame = mNumFrames
			
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
	Field mNumFrames	: Int
	Global mTempMatrix	: Mat4 = Mat4.Create()
End
