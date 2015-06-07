Strict

Private
Import brl.databuffer
Import vortex.core.brush
Import vortex.core.renderer

Public
Class Surface Final
Public
	Function Create:Surface(brush:Brush = Null)
		Local surf:Surface = New Surface
		surf.mBrush = Brush.Create()
		If brush Then surf.mBrush.Set(brush)
		surf.mIndices = New DataBuffer(INC * 2)
		surf.mVertices = New DataBuffer(INC * VERTEX_SIZE)
		surf.mNumIndices = 0
		surf.mNumVertices = 0
		surf.mVertexBuffer = Renderer.CreateBuffer()
		surf.mIndexBuffer = Renderer.CreateBuffer()
		Return surf
	End
	
	Method Discard:Void()
		mIndices.Discard()
		mVertices.Discard()
		Renderer.FreeBuffer(mIndexBuffer)
		Renderer.FreeBuffer(mVertexBuffer)
	End
	
	Method GetBrush:Brush()
		Return mBrush
	End
	
	Method AddTriangle%(v0%, v1%, v2%)
		'Create new buffer if current is too short
		If mIndices.Length() < (mNumIndices + 3) * 2
			'Read data in an array
			Local data%[mIndices.Length()]
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
	
	Method GetNumTriangles%()
		Return mNumIndices / 3
	End
	
	Method SetTriangleVertices:Void(index%, v0%, v1%, v2%)
		mIndices.PokeShorts(index * 6, [v0, v1, v2], 0, 3)
	End
	
	Method GetTriangleV0%(index%)
		Return mIndices.PeekShort(index*6)
	End
	
	Method GetTriangleV1%(index%)
		Return mIndices.PeekShort(index*6 + 2)
	End
	
	Method GetTriangleV2%(index%)
		Return mIndices.PeekShort(index*6 + 4)
	End
	
	Method AddVertex%(x#, y#, z#, nx#, ny#, nz#, r#, g#, b#, a#, u#, v#)
		'Create new buffer if current is too short
		If mVertices.Length() < (GetNumVertices() + 1) * VERTEX_SIZE
			'Read data in an array
			Local data%[mVertices.Length()]
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
	
	Method GetNumVertices%()
		Return mNumVertices
	End
	
	Method SetVertexPosition:Void(index%, x#, y#, z#)
		mVertices.PokeFloats(index * VERTEX_SIZE + POS_OFFSET, [x, y, z], 0, 3)
	End
	
	Method SetVertexNormal:Void(index%, nx#, ny#, nz#)
		mVertices.PokeFloats(index * VERTEX_SIZE + NORMAL_OFFSET, [nx, ny, nz], 0, 3)
	End
	
	Method SetVertexColor:Void(index%, r#, g#, b#, a#)
		mVertices.PokeFloats(index * VERTEX_SIZE + COLOR_OFFSET, [r, g, b, a], 0, 4)
	End
	
	Method SetVertexTexCoords:Void(index%, u#, v#)
		mVertices.PokeFloats(index * VERTEX_SIZE + TEX_OFFSET, [u, v], 0, 2)
	End
	
	Method GetVertexX#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + POS_OFFSET)
	End
	
	Method GetVertexY#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + POS_OFFSET + 4)
	End
	
	Method GetVertexZ#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + POS_OFFSET + 8)
	End
	
	Method GetVertexNX#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + NORMAL_OFFSET)
	End
	
	Method GetVertexNY#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + NORMAL_OFFSET + 4)
	End
	
	Method GetVertexNZ#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + NORMAL_OFFSET + 8)
	End
	
	Method GetVertexRed#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + COLOR_OFFSET)
	End
	
	Method GetVertexGreen#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + COLOR_OFFSET + 4)
	End
	
	Method GetVertexBlue#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + COLOR_OFFSET + 8)
	End
	
	Method GetVertexAlpha#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + COLOR_OFFSET + 12)
	End
	
	Method GetVertexU#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + TEX_OFFSET)
	End
	
	Method GetVertexV#(index%)
		Return mVertices.PeekFloat(index*VERTEX_SIZE + TEX_OFFSET + 4)
	End
	
	Method Rebuild:Void()
		Renderer.SetIndexBufferData(mIndexBuffer, mIndices, mNumIndices * 2)
		Renderer.SetVertexBufferData(mVertexBuffer, mVertices, mNumVertices * VERTEX_SIZE)
	End
	
	Method Draw:Void()
		mBrush.Prepare()
		Renderer.DrawBuffers(mVertexBuffer, mIndexBuffer, mNumIndices, POS_OFFSET, NORMAL_OFFSET, COLOR_OFFSET, TEX_OFFSET, VERTEX_SIZE)
	End
Private
	Method New()
	End
	
	Const POS_OFFSET% = 0
	Const NORMAL_OFFSET% = 12
	Const COLOR_OFFSET% = 24
	Const TEX_OFFSET% = 40
	Const VERTEX_SIZE% = 48
	Const INC% = 128

	Field mBrush		: Brush
	Field mIndices		: DataBuffer
	Field mVertices		: DataBuffer
	Field mNumIndices	: Int
	Field mNumVertices	: Int
	Field mIndexBuffer	: Int
	Field mVertexBuffer	: Int
End
