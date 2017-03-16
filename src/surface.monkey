Strict

Private
Import brl.databuffer
Import vortex.src.material
Import vortex.src.renderer

Public
Class Surface Final
Public
	Function Create:Surface(mat:Material = Null)
		Local surf:Surface = New Surface
		surf.mMaterial = surf.Material.Create()	'I need to call the function as surf.Material because the compiler is not capable of finding the correct context
		If mat Then surf.mMaterial.Set(mat)
		surf.mIndices = New DataBuffer(INC * 2, True)
		surf.mVertices = New DataBuffer(INC * VERTEX_SIZE, True)
		surf.mNumIndices = 0
		surf.mNumVertices = 0
		surf.mVertexBuffer = Renderer.CreateVertexBuffer(0)
		surf.mIndexBuffer = Renderer.CreateIndexBuffer(0)
		surf.mStatus = STATUS_OK
		Return surf
	End
	
	Function Create:Surface(other:Surface)
		Local surf:Surface = Surface.Create(other.mMaterial)
		surf.Set(other)
		Return surf
	End

	Method Free:Void()
		mIndices.Discard()
		mVertices.Discard()
		Renderer.FreeBuffer(mIndexBuffer)
		Renderer.FreeBuffer(mVertexBuffer)
	End
	
	Method Set:Void(other:Surface)
		If Self = other Then Return
		mStatus = STATUS_V_DIRTY | STATUS_I_DIRTY
		If mNumIndices <> other.mNumIndices Then mStatus |= STATUS_I_RESIZED
		If mNumVertices <> other.mNumVertices Then mStatus |= STATUS_V_RESIZED
		mMaterial.Set(other.mMaterial)
		If mIndices.Length <> other.mIndices.Length
			mIndices.Discard()
			mIndices = New DataBuffer(other.mIndices.Length, True)
		End
		other.mIndices.CopyBytes(0, mIndices, 0, mIndices.Length)
		If mVertices.Length <> other.mVertices.Length
			mVertices.Discard()
			mVertices = New DataBuffer(other.mVertices.Length, True)
		End
		other.mVertices.CopyBytes(0, mVertices, 0, mVertices.Length)
		mNumIndices = other.mNumIndices
		mNumVertices = other.mNumVertices
		Rebuild()
	End

	Method Material:Material() Property
		Return mMaterial
	End

	Method AddTriangle:Int(v0:Int, v1:Int, v2:Int)
		'Create new buffer if current is too short
		If mIndices.Length() < (mNumIndices + 3) * 2
			'Read data in an array
			Local data:Int[mIndices.Length()]
			mIndices.PeekBytes(0, data, 0, mIndices.Length())

			'Copy into new buffer
			Local buf:DataBuffer = New DataBuffer(mIndices.Length() + INC*2)
			buf.PokeBytes(0, data, 0, mIndices.Length())

			'Change buffer
			mIndices.Discard()
			mIndices = buf
		End

		'Copy new index data
		mIndices.PokeShorts(mNumIndices * 2, [v0, v1, v2], 0, 3)
		mNumIndices += 3
		
		'Update status
		mStatus |= STATUS_I_DIRTY | STATUS_I_RESIZED
		
		Return NumTriangles-1
	End

	Method NumTriangles:Int() Property
		Return mNumIndices / 3
	End

	Method SetTriangleVertices:Void(index:Int, v0:Int, v1:Int, v2:Int)
		mIndices.PokeShorts(index * 6, [v0, v1, v2], 0, 3)
		mStatus |= STATUS_I_DIRTY
	End

	Method GetTriangleV0:Int(index:Int)
		Return mIndices.PeekShort(index*6)
	End

	Method GetTriangleV1:Int(index:Int)
		Return mIndices.PeekShort(index*6 + 2)
	End

	Method GetTriangleV2:Int(index:Int)
		Return mIndices.PeekShort(index*6 + 4)
	End

	Method AddVertex:Int(x:Float, y:Float, z:Float, nx:Float, ny:Float, nz:Float, r:Float, g:Float, b:Float, a:Float, u0:Float, v0:Float)
		'Create new buffer if current is too short
		If mVertices.Length() < (NumVertices + 1) * VERTEX_SIZE
			'Read data in an array
			Local data:Int[mVertices.Length()]
			mVertices.PeekBytes(0, data, 0, mVertices.Length())

			'Copy into new buffer
			Local buf:DataBuffer = New DataBuffer(mVertices.Length() + INC*VERTEX_SIZE)
			buf.PokeBytes(0, data, 0, mVertices.Length())

			'Change buffer
			mVertices.Discard()
			mVertices = buf
		End

		'Copy new vertex data
		mVertices.PokeFloats(mNumVertices * VERTEX_SIZE, [x, y, z, nx, ny, nz, 0.0, 0.0, 0.0, r, g, b, a, u0, v0, u0, v0], 0, 17)
		mNumVertices += 1
		
		'Update status
		mStatus |= STATUS_V_DIRTY | STATUS_V_RESIZED

		Return NumVertices-1
	End

	Method NumVertices:Int() Property
		Return mNumVertices
	End

	Method SetVertexPosition:Void(index:Int, x:Float, y:Float, z:Float)
		mVertices.PokeFloats(index * VERTEX_SIZE + POS_OFFSET, [x, y, z], 0, 3)
		mStatus |= STATUS_V_DIRTY
	End

	Method SetVertexNormal:Void(index:Int, nx:Float, ny:Float, nz:Float)
		mVertices.PokeFloats(index * VERTEX_SIZE + NORMAL_OFFSET, [nx, ny, nz], 0, 3)
		mStatus |= STATUS_V_DIRTY
	End
	
	Method SetVertexTangent:Void(index:Int, tx:Float, ty:Float, tz:Float)
		mVertices.PokeFloats(index * VERTEX_SIZE + TANGENT_OFFSET, [tx, ty, tz], 0, 3)
		mStatus |= STATUS_V_DIRTY
	End

	Method SetVertexColor:Void(index:Int, r:Float, g:Float, b:Float, a:Float)
		mVertices.PokeFloats(index * VERTEX_SIZE + COLOR_OFFSET, [r, g, b, a], 0, 4)
		mStatus |= STATUS_V_DIRTY
	End

	Method SetVertexTexCoords:Void(index:Int, u:Float, v:Float, set:Int = 0)
		If set = 0
			mVertices.PokeFloats(index * VERTEX_SIZE + TEX0_OFFSET, [u, v], 0, 2)
		Else
			mVertices.PokeFloats(index * VERTEX_SIZE + TEX1_OFFSET, [u, v], 0, 2)
		End
		mStatus |= STATUS_V_DIRTY
	End
	
	Method SetVertexBone:Void(vertex:Int, index:Int, bone:Int, weight:Float)
		'WebGL does not support int attributes, so storing it as a float is a very dirty trick I am using
		mVertices.PokeFloat(vertex * VERTEX_SIZE + BONEINDICES_OFFSET + index * 4, bone)
		mVertices.PokeFloat(vertex * VERTEX_SIZE + BONEWEIGHTS_OFFSET + index * 4, weight)
		mStatus |= STATUS_V_DIRTY
	End

	Method GetVertexX:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + POS_OFFSET)
	End

	Method GetVertexY:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + POS_OFFSET + 4)
	End

	Method GetVertexZ:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + POS_OFFSET + 8)
	End

	Method GetVertexNX:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + NORMAL_OFFSET)
	End

	Method GetVertexNY:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + NORMAL_OFFSET + 4)
	End

	Method GetVertexNZ:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + NORMAL_OFFSET + 8)
	End
	
	Method GetVertexTX:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + TANGENT_OFFSET)
	End
	
	Method GetVertexTY:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + TANGENT_OFFSET + 4)
	End
	
	Method GetVertexTZ:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + TANGENT_OFFSET + 8)
	End

	Method GetVertexRed:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + COLOR_OFFSET)
	End

	Method GetVertexGreen:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + COLOR_OFFSET + 4)
	End

	Method GetVertexBlue:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + COLOR_OFFSET + 8)
	End

	Method GetVertexAlpha:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + COLOR_OFFSET + 12)
	End

	Method GetVertexU:Float(index:Int, set:Int = 0)
		If set = 0
			Return mVertices.PeekFloat(index*VERTEX_SIZE + TEX0_OFFSET)
		Else
			Return mVertices.PeekFloat(index*VERTEX_SIZE + TEX1_OFFSET)
		End
	End

	Method GetVertexV:Float(index:Int, set:Int = 0)
		If set = 0
			Return mVertices.PeekFloat(index*VERTEX_SIZE + TEX0_OFFSET + 4)
		Else
			Return mVertices.PeekFloat(index*VERTEX_SIZE + TEX1_OFFSET + 4)
		End
	End
	
	Method GetVertexBoneIndex:Int(vertex:Int, index:Int)
		Return mVertices.PeekFloat(vertex * VERTEX_SIZE + BONEINDICES_OFFSET + index * 4)
	End
	
	Method GetVertexBoneWeight:Float(vertex:Int, index:Int)
		Return mVertices.PeekFloat(vertex * VERTEX_SIZE + BONEWEIGHTS_OFFSET + index * 4)
	End

	Method Rebuild:Void()
		If mStatus & STATUS_I_RESIZED Then Renderer.ResizeIndexBuffer(mIndexBuffer, mNumIndices * 2)
		If mStatus & STATUS_I_DIRTY Then Renderer.SetIndexBufferData(mIndexBuffer, 0, mNumIndices * 2, mIndices)
		If mStatus & STATUS_V_RESIZED Then Renderer.ResizeVertexBuffer(mVertexBuffer, mNumVertices * VERTEX_SIZE)
		If mStatus & STATUS_V_DIRTY Then Renderer.SetVertexBufferData(mVertexBuffer, 0, mNumVertices * VERTEX_SIZE, mVertices)
		mStatus = STATUS_OK
	End
	
	Method Draw:Void()
		Renderer.DrawBuffers(mVertexBuffer, mIndexBuffer, mNumIndices, POS_OFFSET, NORMAL_OFFSET, TANGENT_OFFSET, COLOR_OFFSET, TEX0_OFFSET, BONEINDICES_OFFSET, BONEWEIGHTS_OFFSET, VERTEX_SIZE)
	End
Private
	Method New()
	End

	Const POS_OFFSET:Int = 0			'12 bytes
	Const NORMAL_OFFSET:Int = 12		'12 bytes
	Const TANGENT_OFFSET:Int = 24		'12 bytes
	Const COLOR_OFFSET:Int = 36			'16 bytes
	Const TEX0_OFFSET:Int = 52			'8 bytes
	Const TEX1_OFFSET:Int = 60			'8 bytes
	Const BONEINDICES_OFFSET:Int = 68	'16 bytes
	Const BONEWEIGHTS_OFFSET:Int = 84	'16 bytes
	Const VERTEX_SIZE:Int = 100
	Const INC:Int = 128
	
	Const STATUS_OK			: Int = 0
	Const STATUS_V_DIRTY	: Int = 1
	Const STATUS_V_RESIZED	: Int = 2
	Const STATUS_I_DIRTY	: Int = 4
	Const STATUS_I_RESIZED	: Int = 8

	Field mMaterial		: Material
	Field mIndices		: DataBuffer
	Field mVertices		: DataBuffer
	Field mNumIndices	: Int
	Field mNumVertices	: Int
	Field mIndexBuffer	: Int
	Field mVertexBuffer	: Int
	Field mStatus		: Int
End
