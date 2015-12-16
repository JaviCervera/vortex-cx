Strict

Private
Import vortex.core.font
Import vortex.core.mesh
Import vortex.core.texture
Import vortex.ext.fontloader_json
Import vortex.ext.meshloader_xml

Public
Class Cache Final
Public
	Function Push:Void()
		mStack = mStack.Resize(mStack.Length() + 1)
		mStack[mStack.Length() - 1] = New Cache
	End
	
	Function Pop:Void()
		mStack[mStack.Length() - 1].Clear()
		mStack = mStack.Resize(mStack.Length() - 1)
	End
	
	Function GetFont:Font(filename$)
		'Search for the font in all allocated caches
		For Local i% = mStack.Length()-1 To 0 Step -1
			If mStack[i].mFonts.Contains(filename)
				Return mStack[i].mFonts.Get(filename)
			End
		Next
		
		'If it was not found, load it
		Local font:Font = FontLoader_JSON.Load(filename)
		If font <> Null Then mStack[mStack.Length() -1].mFonts.Set(filename, font)
		Return font
	End
	
	Function GetMesh:Mesh(filename$, texFilter% = Texture.FILTER_TRILINEAR)
		'Search for the mesh in all allocated caches
		For Local i% = mStack.Length()-1 To 0 Step -1
			If mStack[i].mMeshes.Contains(filename)
				Return mStack[i].mMeshes.Get(filename)
			End
		Next
		
		'If it was not found, load it
		Local mesh:Mesh = MeshLoader_XML.Load(filename, texFilter)
		If mesh <> Null Then mStack[mStack.Length() -1].mMeshes.Set(filename, mesh)
		Return mesh
	End
	
	Function GetTexture:Texture(filename$, filter% = Texture.FILTER_TRILINEAR)
		'Search for the texture in all allocated caches
		For Local i% = mStack.Length()-1 To 0 Step -1
			If mStack[i].mTextures.Contains(filename)
				Return mStack[i].mTextures.Get(filename)
			End
		Next
	
		'If it was not found, load it
		Local tex:Texture = Texture.Create(filename, filter)
		If tex <> Null Then mStack[mStack.Length() - 1].mTextures.Set(filename, tex)
		Return tex
	End
Private
	Method New()
		mFonts = New StringMap<Font>
		mMeshes = New StringMap<Mesh>
		mTextures = New StringMap<Texture>
	End
	
	Method Clear:Void()
		For Local font:Font = Eachin mFonts.Values()
			font.Discard()
		Next
		For Local mesh:Mesh = Eachin mMeshes.Values()
			mesh.Discard()
		Next
		For Local tex:Texture = Eachin mTextures.Values()
			tex.Discard()
		Next
	End

	Global mStack	: Cache[0]
	Field mFonts	: StringMap<Font>
	Field mMeshes	: StringMap<Mesh>
	Field mTextures	: StringMap<Texture>
End