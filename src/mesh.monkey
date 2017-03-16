Strict

Private
Import vortex.src.bone
Import vortex.src.math3d
Import vortex.src.renderer
Import vortex.src.surface

Public
Class Mesh Final
Public
	Function Create:Mesh(filename:String = "")
		Local mesh:Mesh = New Mesh
		mesh.mFilename = filename
		mesh.mSurfaces = New Surface[0]
		mesh.mBones = New Bone[0]
		mesh.mLastFrame = 0
		Return mesh
	End
	
	Function Create:Mesh(other:Mesh)
		Local mesh:Mesh = Mesh.Create(other.mFilename)
		mesh.mSurfaces = New Surface[other.mSurfaces.Length()]
		For Local i:Int = 0 Until other.mSurfaces.Length()
			mesh.mSurfaces[i] = Surface.Create(other.mSurfaces[i])
		Next
		mesh.mBones	= New Bone[other.mBones.Length()]
		For Local i:Int = 0 Until other.mBones.Length()
			mesh.mBones[i] = Bone.Create(other.mBones[i])
		Next
		mesh.mLastFrame = other.mLastFrame
		Return mesh
	End

	Method Free:Void()
		For Local surf:Surface = Eachin mSurfaces
			surf.Free()
		Next
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

	Method LastFrame:Void(lastFrame:Int) Property
		mLastFrame = lastFrame
	End

	Method LastFrame:Int() Property
		Return mLastFrame
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
			If lastFrame = 0 Then lastFrame = mLastFrame
			
			'Calculate animation matrix for all bones
			For Local i:Int = 0 Until NumBones
				Local parentIndex:Int = GetBone(i).ParentIndex
				If parentIndex > -1 Then mTempMatrix.Set(animMatrices[parentIndex]) Else mTempMatrix.SetIdentity()
				GetBone(i).CalculateAnimMatrix(mTempMatrix, frame, firstFrame, lastFrame)
				animMatrices[i].Mul(mTempMatrix)
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
	Field mLastFrame	: Int
	Global mTempMatrix	: Mat4 = Mat4.Create()
End
