Strict

Private

Import vortex.src.material
Import vortex.src.math3d
Import vortex.src.mesh
Import vortex.src.renderer
Import vortex.src.surface

Class RenderGeom Final
Public
	Method New(op:RenderOp, surface:Surface, animMatrices:Mat4[])
		mOp = op
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
	
	Field mOp:RenderOp
	Field mSurface:Surface
	Field mAnimMatrices:Mat4[]
	Field mTransforms:List<Mat4>
End

Class RenderOp Final
Public
	Method New(material:Material)
		mMaterial = Material.Create(material)
		mGeoms = New List<RenderGeom>
	End
	
	Method Render:Int()
		Local numRenderCalls:Int = 0
		mMaterial.Prepare()
		For Local geom:RenderGeom = Eachin mGeoms
			numRenderCalls += geom.Render()
		Next
		Return numRenderCalls
	End
	
	Method AddGeom:Void(geom:RenderGeom)
		mGeoms.AddLast(geom)
	End
	
	Method RemoveGeom:Void(geom:RenderGeom)
		mGeoms.Remove(geom)
	End
	
	Method HasGeoms:Bool()
		Return Not mGeoms.IsEmpty()
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
	
	Method AddSurface:Void(surface:Surface, transform:Mat4, animMatrices:Mat4[], overrideMaterial:Material = Null)
		If overrideMaterial = Null Then overrideMaterial = surface.Material
		RenderGeomForSurface(surface, overrideMaterial, animMatrices).AddTransform(transform)
	End
	
	Method RemoveSurface:Void(surface:Surface, transform:Mat4, overrideMaterial:Material = Null)
		Local geoms:RenderGeom[] = RenderGeomsForSurface(surface, overrideMaterial, mTempArray)
		For Local geom:RenderGeom = Eachin geoms
			geom.RemoveTransform(transform)
			If Not geom.HasTransforms()
				geom.mOp.RemoveGeom(geom)
				If Not geom.mOp.HasGeoms() Then RemoveOp(geom.mOp)
			End
		End
	End
	
	Method RemoveSurface:Void(surface:Surface, transform:Mat4, animMatrices:Mat4[], overrideMaterial:Material = Null)
		Local geoms:RenderGeom[] = RenderGeomsForSurface(surface, overrideMaterial, animMatrices)
		For Local geom:RenderGeom = Eachin geoms
			geom.RemoveTransform(transform)
			If Not geom.HasTransforms()
				geom.mOp.RemoveGeom(geom)
				If Not geom.mOp.HasGeoms() Then RemoveOp(geom.mOp)
			End
		End
	End
	
	Method AddMesh:Void(mesh:Mesh, transform:Mat4)
		For Local i:Int = 0 Until mesh.NumSurfaces
			AddSurface(mesh.Surface(i), transform)
		Next
	End
	
	Method AddMesh:Void(mesh:Mesh, transform:Mat4, animMatrices:Mat4[])
		For Local i:Int = 0 Until mesh.NumSurfaces
			AddSurface(mesh.Surface(i), transform, animMatrices, Null)
		Next
	End
	
	Method RemoveMesh:Void(mesh:Mesh, transform:Mat4)
		For Local i:Int = 0 Until mesh.NumSurfaces
			RemoveSurface(mesh.Surface(i), transform)
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
		'Check for op with requested material
		Local op:RenderOp = RenderOpForMaterial(material)
		If op
			'If the op has the geom, return it
			For Local geom:RenderGeom = Eachin op.mGeoms
				If geom.mSurface = surface
					Local differ:Bool = False
					Local len:Int = Min(animMatrices.Length, geom.mAnimMatrices.Length)
					For Local i:Int = 0 Until len
						If animMatrices[i] <> geom.mAnimMatrices[i] Then differ = True; Exit
					Next
					If Not differ Then Return geom
				End
			Next
		End
		
		'If there is no op for the material, create one
		If Not op
			op = New RenderOp(material)
			If material.DepthWrite = False
				mOps.AddLast(op)
			Else
				mOps.AddFirst(op)
			End
		End
		
		'Create new geom
		Local geom:RenderGeom = New RenderGeom(op, surface, animMatrices)
		
		'Add geom to op
		op.AddGeom(geom)
		'Otherwise, insert a new op
		
		Return geom
	End
	
	Method RenderGeomsForSurface:RenderGeom[](surface:Surface, material:Material, animMatrices:Mat4[])
		Local geoms:RenderGeom[0]
		For Local op:RenderOp = Eachin mOps
			'If material And Not material.IsEqual(op.mMaterial) Then Continue
			For Local geom:RenderGeom = Eachin op.mGeoms
				If geom.mSurface = surface
					Local differ:Bool = False
					Local len:Int = Min(animMatrices.Length, geom.mAnimMatrices.Length)
					For Local i:Int = 0 Until len
						If animMatrices[i] <> geom.mAnimMatrices[i] Then differ = True; Exit
					Next
					If Not differ
						geoms = geoms.Resize(geoms.Length() + 1)
						geoms[geoms.Length()-1] = geom
					End
				End
			Next
		Next
		Return geoms
	End
	
	Method RemoveOp:Void(op:RenderOp)
		mOps.Remove(op)
	End

	Field mOps			: List<RenderOp>
	Global mRenderLists	: List<RenderList> = New List<RenderList>
	Global mTempArray	: Mat4[0]
End
