Strict

Private

Import vortex.src.material
Import vortex.src.math3d
Import vortex.src.mesh
Import vortex.src.renderer
Import vortex.src.surface

Class RenderGeom Final
Public
	Method New(surface:Surface, animMatrices:Mat4[])
		mSurface = surface
		mAnimMatrices = animMatrices
		mTransforms = New List<Mat4>
	End
	
	Method AddTransform:Void(transform:Mat4)
		mTransforms.AddLast(transform)
	End
	
	Method RemoveTransform:Void(transform:Mat4)
		mTransforms.RemoveFirst(transform)
	End
	
	Method HasTransforms:Bool()
		Return Not mTransforms.IsEmpty()
	End
	
	Method Render:Int()
		Local numRenderCalls:Int = 0
		Renderer.SetSkinned(mAnimMatrices.Length() > 0)
		If mAnimMatrices.Length() > 0 Then Renderer.SetBoneMatrices(mAnimMatrices)
		For Local transform:Mat4 = Eachin mTransforms
			Renderer.SetModelMatrix(transform)
			mSurface.Draw()
			numRenderCalls += 1
		Next
		Return numRenderCalls
	End
Private
	Method New()
	End
	
	Field mSurface:Surface
	Field mAnimMatrices:Mat4[]
	Field mTransforms:List<Mat4>
End

Class RenderOp Final
Public
	Method New(material:Material, geom:RenderGeom)
		mMaterial = material
		mGeoms = New List<RenderGeom>
		mGeoms.AddLast(geom)
	End
	
	Method Render:Int()
		Local numRenderCalls:Int = 0
		mMaterial.Prepare()
		For Local geom:RenderGeom = Eachin mGeoms
			numRenderCalls += geom.Render()
		Next
		Return numRenderCalls
	End
Private
	Field mMaterial	: Material
	Field mGeoms	: List<RenderGeom>
End

Public
Class RenderList Final
Public
	Function Create:RenderList()
		Return New RenderList
	End
	
	Method Free:Void()
		mRendeLists.RemoveFirst(Self)
	End

	Method AddSurface:Void(surface:Surface, transform:Mat4, overrideMaterial:Material = Null)
		If overrideMaterial = Null Then overrideMaterial = surface.Material
		RenderGeomForSurface(surface, overrideMaterial, mTempArray).AddTransform(transform)
	End
	
	Method AddSurface:Void(surface:Surface, transform:Mat4, overrideMaterial:Material = Null, animMatrices:Mat4[])
		If overrideMaterial = Null Then overrideMaterial = surface.Material
		RenderGeomForSurface(surface, overrideMaterial, animMatrices).AddTransform(transform)
	End
	
	Method RemoveSurface:Void(surface:Surface, transform:Mat4)
		Local geoms:RenderGeom[] = RenderGeomsForSurface(surface)
		For Local geom:RenderGeom = Eachin geoms
			geom.RemoveTransform(transform)
			'If Not geom.HasTransforms() Then mOps.RemoveFirst(op)
		End
	End
	
	Method AddMesh:Void(mesh:Mesh, transform:Mat4)
		For Local i:Int = 0 Until mesh.NumSurfaces
			AddSurface(mesh.GetSurface(i), transform)
		Next
	End
	
	Method AddMesh:Void(mesh:Mesh, transform:Mat4, animMatrices:Mat4[])
		For Local i:Int = 0 Until mesh.NumSurfaces
			AddSurface(mesh.GetSurface(i), transform, Null, animMatrices)
		Next
	End
	
	Method RemoveMesh:Void(mesh:Mesh, transform:Mat4)
		For Local i:Int = 0 Until mesh.NumSurfaces
			RemoveSurface(mesh.GetSurface(i), transform)
		Next
	End
	
	Method Render:Int()
		Local numRenderCalls:Int = 0
		For Local op:RenderOp = Eachin mOps
			numRenderCalls += op.Render()
		Next
		Return numRenderCalls
	End
	
	Function Sort:Void(mat:Material)
		For Local renderList:RenderList = Eachin mRenderLists
			Local op:RenderOp = renderList.RenderOpForMaterial(mat)
			If op
				renderList.mOps.RemoveFirst(op)
				If mat.DepthWrite = False
					renderList.mOps.AddLast(op)
				Else
					renderList.mOps.AddFirst(op)
				End
			End
		Next
	End
Private
	Method New()
		mOps = New List<RenderOp>
		mRenderLists.AddLast(Self)
	End
	
	Method RenderOpForMaterial:RenderOp(material:Material)
		For Local op:RenderOp = Eachin mOps
			If op.mMaterial.IsEqual(material)
				Return op
			End
		Next
		Return Null
	End
	
	Method RenderGeomForSurface:RenderGeom(surface:Surface, material:Material, animMatrices:Mat4[])
		Local op:RenderOp = RenderOpForMaterial(material)
		If op
			For Local geom:RenderGeom = Eachin op.mGeoms
				If geom.mSurface = surface Then Return geom
			Next
		End
		
		Local geom:RenderGeom = New RenderGeom(surface, animMatrices)
		If material.DepthWrite = False
			mOps.AddLast(New RenderOp(material, geom))
		Else
			mOps.AddFirst(New RenderOp(material, geom))
		End
		Return geom
	End
	
	Method RenderGeomsForSurface:RenderGeom[](surface:Surface)
		Local geoms:RenderGeom[0]
		For Local op:RenderOp = Eachin mOps
			For Local geom:RenderGeom = Eachin op.mGeoms
				If geom.mSurface = surface
					geoms = geoms.Resize(geoms.Length() + 1)
					geoms[geoms.Length()-1] = geom
				End
			Next
		Next
		Return geoms
	End

	Field mOps			: List<RenderOp>
	Global mRenderLists	: List<RenderList> = New List<RenderList>
	Global mTempArray	: Mat4[0]
End
