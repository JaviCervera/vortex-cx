Strict

Private
Import vortex.src.bone
Import vortex.src.math3d
Import vortex.src.renderer
Import vortex.src.surface

Public
Class Mesh Final
Public
	Function Create:Mesh(skinned:Bool = False)
		Local mesh:Mesh = New Mesh
		mesh.mSurfaces = New Surface[0]
		mesh.mLastFrame = 0
		mesh.mBones = New Bone[0]
		mesh.mIsSkinned = skinned
		Return mesh
	End

	Method Free:Void()
		For Local surf:Surface = Eachin mSurfaces
			surf.Free()
		Next
	End

	Method GetFilename:String()
		Return mFilename
	End

	Method SetFilename:Void(filename:String)
		mFilename = filename
	End

	Method AddSurface:Void(surf:Surface)
		mSurfaces = mSurfaces.Resize(mSurfaces.Length() + 1)
		mSurfaces[mSurfaces.Length()-1] = surf
		surf.Rebuild()
	End

	Method GetNumSurfaces:Int()
		Return mSurfaces.Length()
	End

	Method GetSurface:Surface(index:Int)
		Return mSurfaces[index]
	End

	Method SetLastFrame:Void(lastFrame:Int)
		mLastFrame = lastFrame
	End

	Method GetLastFrame:Int()
		Return mLastFrame
	End
	
	Method AddBone:Void(bone:Bone)
		mBones = mBones.Resize(mBones.Length() + 1)
		mBones[mBones.Length() - 1] = bone
	End
	
	Method GetNumBones:Int()
		Return mBones.Length()
	End
	
	Method GetBone:Bone(index:Int)
		If index = -1 Then Return Null
		Return mBones[index]
	End
	
	Method FindBone:Bone(name:String)
		For Local bone:Bone = Eachin mBones
			If bone.GetName() = name Then Return bone
		Next
		Return Null
	End
	
	Method Animate:Void(animMatrices:Mat4[], frame:Float, firstFrame:Int = 0, lastFrame:Int = 0)
		'We can only animate if the mesh has bones
		If mBones.Length() > 0
			'If we have not specified the ending frame of the sequence, take the last frame in the entire animation
			If lastFrame = 0 Then lastFrame = mLastFrame
			
			'Calculate animation matrix for all bones
			For Local i:Int = 0 Until GetNumBones()
				Local parentIndex:Int = GetBoneIndex(GetBone(i).GetParent())
				If parentIndex > -1
					GetBone(i).Animate(animMatrices[i], animMatrices[parentIndex], frame, firstFrame, lastFrame)
				Else
					GetBone(i).Animate(animMatrices[i], Null, frame, firstFrame, lastFrame)
				End
			Next
			
			'If the mesh is skinned, multiply every animation matrix by the inverse of the pose matrix
			If mIsSkinned
				For Local i:Int = 0 Until GetNumBones()
					animMatrices[i].Mul(GetBone(i).GetInversePoseMatrix())
				Next
			End
		End
	End
	
	Method Draw:Void()
		Draw(False, mTempArray)
	End
	
	Method Draw:Void(animMatrices:Mat4[])
		Draw(True, animMatrices)
	End
Private
	Method New()
	End
	
	Method GetBoneIndex:Int(bone:Bone)
		For Local i:Int = 0 Until mBones.Length()
			If mBones[i] = bone Then Return i
		Next
		Return -1
	End
	
	Method Draw:Void(animated:Bool, animMatrices:Mat4[])
		'Simple hierarchical animation
		If mBones.Length() > 0 And Not mIsSkinned
			Renderer.SetSkinned(False)
			For Local i:Int = 0 Until GetNumBones()
				If animated Then GetBone(i).Draw(True, animMatrices[i]) Else GetBone(i).Draw(False, Null)
			Next
		Else
			'Skinned animation
			If mIsSkinned And animated
				Renderer.SetSkinned(True)
				Renderer.SetBoneMatrices(animMatrices)
			Else
				Renderer.SetSkinned(False)
			End
			
			'Static mesh
			For Local i:Int = 0 Until GetNumSurfaces()
				GetSurface(i).Draw()
			Next
		End
	End

	Field mFilename		: String
	Field mSurfaces		: Surface[]
	Field mLastFrame	: Int
	Field mBones		: Bone[]
	Field mIsSkinned	: Bool
	
	'Empty animation matrix array used in static drawing
	Global mTempArray	: Mat4[]
End
