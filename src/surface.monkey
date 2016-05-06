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
		surf.mMaterial = Material.Create()
		If mat Then surf.mMaterial.Set(mat)
		surf.mIndices = New DataBuffer(INC * 2)
		surf.mVertices = New DataBuffer(INC * VERTEX_SIZE)
		surf.mNumIndices = 0
		surf.mNumVertices = 0
		surf.mVertexBuffer = Renderer.CreateBuffer()
		surf.mIndexBuffer = Renderer.CreateBuffer()
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
		mMaterial.Set(other.mMaterial)
		If mIndices.Length() <> other.mIndices.Length()
			mIndices.Discard()
			mIndices = New DataBuffer(other.mIndices.Length())
		End
		other.mIndices.CopyBytes(0, mIndices, 0, mIndices.Length())
		If mVertices.Length() <> other.mVertices.Length()
			mVertices.Discard()
			mVertices = New DataBuffer(other.mVertices.Length())
		End
		other.mVertices.CopyBytes(0, mVertices, 0, mVertices.Length())
		mNumIndices = other.mNumIndices
		mNumVertices = other.mNumVertices
		Rebuild()
	End

	Method GetMaterial:Material()
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
		Return GetNumTriangles()-1
	End

	Method GetNumTriangles:Int()
		Return mNumIndices / 3
	End

	Method SetTriangleVertices:Void(index:Int, v0:Int, v1:Int, v2:Int)
		mIndices.PokeShorts(index * 6, [v0, v1, v2], 0, 3)
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

	Method AddVertex:Int(x:Float, y:Float, z:Float, nx:Float, ny:Float, nz:Float, r:Float, g:Float, b:Float, a:Float, u:Float, v:Float)
		'Create new buffer if current is too short
		If mVertices.Length() < (GetNumVertices() + 1) * VERTEX_SIZE
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
		mVertices.PokeFloats(mNumVertices * VERTEX_SIZE, [x, y, z, nx, ny, nz, r, g, b, a, u, v], 0, 12)
		mNumVertices += 1

		Return GetNumVertices()-1
	End

	Method GetNumVertices:Int()
		Return mNumVertices
	End

	Method SetVertexPosition:Void(index:Int, x:Float, y:Float, z:Float)
		mVertices.PokeFloats(index * VERTEX_SIZE + POS_OFFSET, [x, y, z], 0, 3)
	End

	Method SetVertexNormal:Void(index:Int, nx:Float, ny:Float, nz:Float)
		mVertices.PokeFloats(index * VERTEX_SIZE + NORMAL_OFFSET, [nx, ny, nz], 0, 3)
	End

	Method SetVertexColor:Void(index:Int, r:Float, g:Float, b:Float, a:Float)
		mVertices.PokeFloats(index * VERTEX_SIZE + COLOR_OFFSET, [r, g, b, a], 0, 4)
	End

	Method SetVertexTexCoords:Void(index:Int, u:Float, v:Float)
		mVertices.PokeFloats(index * VERTEX_SIZE + TEX_OFFSET, [u, v], 0, 2)
	End
	
	Method SetVertexBone:Void(vertex:Int, index:Int, bone:Int, weight:Float)
		'WebGL does not support int attributes, so storing it as a float is a very dirty trick I am using
		mVertices.PokeFloat(vertex * VERTEX_SIZE + BONEINDICES_OFFSET + index * 4, bone)
		mVertices.PokeFloat(vertex * VERTEX_SIZE + BONEWEIGHTS_OFFSET + index * 4, weight)
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

	Method GetVertexU:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + TEX_OFFSET)
	End

	Method GetVertexV:Float(index:Int)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + TEX_OFFSET + 4)
	End
	
	Method GetVertexBoneIndex:Int(vertex:Int, index:Int)
		Return mVertices.PeekFloat(vertex * VERTEX_SIZE + BONEINDICES_OFFSET + index * 4)
	End
	
	Method GetVertexBoneWeight:Float(vertex:Int, index:Int)
		Return mVertices.PeekFloat(vertex * VERTEX_SIZE + BONEWEIGHTS_OFFSET + index * 4)
	End

	Method Rebuild:Void()
		Renderer.SetIndexBufferData(mIndexBuffer, mIndices, mNumIndices * 2)
		Renderer.SetVertexBufferData(mVertexBuffer, mVertices, mNumVertices * VERTEX_SIZE)
	End
	
	Method Draw:Void()
		Renderer.DrawBuffers(mVertexBuffer, mIndexBuffer, mNumIndices, POS_OFFSET, NORMAL_OFFSET, COLOR_OFFSET, TEX_OFFSET, BONEINDICES_OFFSET, BONEWEIGHTS_OFFSET, VERTEX_SIZE)
	End
Private
	Method New()
	End

	Const POS_OFFSET:Int = 0
	Const NORMAL_OFFSET:Int = 12
	Const COLOR_OFFSET:Int = 24
	Const TEX_OFFSET:Int = 40
	Const BONEINDICES_OFFSET:Int = 48
	Const BONEWEIGHTS_OFFSET:Int = 64
	Const VERTEX_SIZE:Int = 80
	Const INC:Int = 128

	Field mMaterial		: Material
	Field mIndices		: DataBuffer
	Field mVertices		: DataBuffer
	Field mNumIndices	: Int
	Field mNumVertices	: Int
	Field mIndexBuffer	: Int
	Field mVertexBuffer	: Int
End
