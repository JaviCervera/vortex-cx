Strict

Private

Import vortex.src.material
Import vortex.src.math3d
Import vortex.src.mesh
Import vortex.src.renderer
Import vortex.src.surface

Class RenderOp Final
	Field mSurface:Surface
	Field mMaterial:Material
	Field mSkinned:Bool
	Field mAnimMatrices:Mat4[]
	Field mTransforms:List<Mat4>
	
	Method New(surface:Surface, material:Material, skinned:Bool, animMatrices:Mat4[])
		mSurface = surface
		mMaterial = material
		mSkinned = skinned
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
		mMaterial.Prepare()
		Renderer.SetSkinned(mSkinned)
		If mSkinned Then Renderer.SetBoneMatrices(mAnimMatrices)
		For Local transform:Mat4 = Eachin mTransforms
			Renderer.SetModelMatrix(transform)
			mSurface.Draw()
			numRenderCalls += 1
		Next
		Return numRenderCalls
	End
End

Public
Class RenderBatch Final
Public
	Function Create:RenderBatch()
		Return New RenderBatch
	End

	Method AddSurface:Void(surface:Surface, transform:Mat4, overrideMaterial:Material = Null, skinned:Bool = False, animMatrices:Mat4[] = [])
		If overrideMaterial = Null Then overrideMaterial = surface.GetMaterial()
		RenderOpForSurface(surface, overrideMaterial, skinned, animMatrices).AddTransform(transform)
	End
	
	Method RemoveSurface:Void(surface:Surface, transform:Mat4)
		Local ops:RenderOp[] = RenderOpsForSurface(surface)
		For Local op:RenderOp = Eachin ops
			op.RemoveTransform(transform)
			If Not op.HasTransforms() Then mOps.RemoveFirst(op)
		End
	End
	
	Method AddMesh:Void(mesh:Mesh, transform:Mat4)
		For Local i:Int = 0 Until mesh.GetNumSurfaces()
			AddSurface(mesh.GetSurface(i), transform, Null, mesh.IsSkinned())
		Next
	End
	
	Method AddMesh:Void(mesh:Mesh, transform:Mat4, animMatrices:Mat4[])
		For Local i:Int = 0 Until mesh.GetNumSurfaces()
			AddSurface(mesh.GetSurface(i), transform, Null, mesh.IsSkinned(), animMatrices)
		Next
	End
	
	Method RemoveMesh:Void(mesh:Mesh, transform:Mat4)
		For Local i:Int = 0 Until mesh.GetNumSurfaces()
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
Private
	Method New()
	End
	
	Method RenderOpForSurface:RenderOp(surface:Surface, material:Material, skinned:Bool, animMatrices:Mat4[])
		For Local op:RenderOp = Eachin mOps
			If op.mSurface = surface And op.mMaterial = material Then Return op
		Next
		mOps.AddLast(New RenderOp(surface, material, skinned, animMatrices))
		Return mOps.Last()
	End
	
	Method RenderOpsForSurface:RenderOp[](surface:Surface)
		Local ops:RenderOp[0]
		For Local op:RenderOp = Eachin mOps
			If op.mSurface = surface
				ops = ops.Resize(ops.Length() + 1)
				ops[ops.Length()-1] = op
			End
		Next
		Return ops
	End

	Field mOps:List<RenderOp> = New List<RenderOp>
End
