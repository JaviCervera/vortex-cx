Strict

Private
Import vortex.core.math3d
Import vortex.core.renderer
Import vortex.core.surface

Public
Class Bone Final
Public
	Function Create:Bone(name$)
		Local bone:Bone = New Bone
		bone.mName = name
		bone.mParent = Null
		bone.mDefaultTransform = Mat4.Create()
		bone.mCurrentTransform = Mat4.Create()
		bone.mSurfaces = New Surface[0]
		bone.mChildren = New Bone[0]
		bone.mPositionKeys = New Int[0]
		bone.mRotationKeys = New Int[0]
		bone.mScaleKeys = New Int[0]
		bone.mPositions = New Vec3[0]
		bone.mRotations = New Quat[0]
		bone.mScales = New Vec3[0]
		bone.mPrevMatrix = Mat4.Create()
		Return bone
	End
	
	Method GetName$()
		Return mName
	End
	
	Method SetDefaultTransform:Void(px#, py#, pz#, rw#, rx#, ry#, rz#, sx#, sy#, sz#)
		mTempQuat.Set(rw, rx, ry, rz)
		mTempQuat.CalcAxis()
		mDefaultTransform.SetIdentity()
		mDefaultTransform.Translate(px, py, pz)
		mDefaultTransform.Rotate(mTempQuat.Angle(), mTempQuat.ResultVector().x, mTempQuat.ResultVector().y, mTempQuat.ResultVector().z)
		mDefaultTransform.Scale(sx, sy, sz)
	End
	
	Method GetDefaultTransform#[]()
		Return mDefaultTransform.m
	End
	
	Method GetCurrentTransform#[]()
		Return mCurrentTransform.m
	End
	
	Method CalcCurrentTransform:Void(frame#, firstSeqFrame%, lastSeqFrame%)
		'Check if there is a keyframe within range
		Local keyInRange:Bool = False
		For Local i% = Eachin mPositionKeys
			If i >= firstSeqFrame And i <= lastSeqFrame
				keyInRange = True
				Exit
			End
		Next
		
		'If there are keyframes in the sequence, interpolate
		If keyInRange
			Local px#, py#, pz#, sx#, sy#, sz#
			
			'Calculate inteprolated position
			CalcPosition(frame, firstSeqFrame, lastSeqFrame)
			px = mTempVec.x
			py = mTempVec.y
			pz = mTempVec.z
			
			'Calculate interpolated rotation
			CalcRotation(frame, firstSeqFrame, lastSeqFrame)
			mTempQuat.CalcAxis()
			
			'Calculate interpolated scale
			CalcScale(frame, firstSeqFrame, lastSeqFrame)
			sx = mTempVec.x
			sy = mTempVec.y
			sz = mTempVec.z
			
			'Set matrix
			mCurrentTransform.SetIdentity()
			mCurrentTransform.Translate(px, py, pz)
			mCurrentTransform.Rotate(mTempQuat.Angle(), mTempQuat.ResultVector().x, mTempQuat.ResultVector().y, mTempQuat.ResultVector().z)
			mCurrentTransform.Scale(sx, sy, sz)
		'If not, define default transform
		Else
			mCurrentTransform.Set(mDefaultTransform)
		End
	End
	
	Method AddSurface:Void(surf:Surface)
		mSurfaces = mSurfaces.Resize(mSurfaces.Length() + 1)
		mSurfaces[mSurfaces.Length() - 1] = surf
	End
	
	Method GetNumSurfaces%()
		Return mSurfaces.Length()
	End
	
	Method GetSurface:Surface(index%)
		Return mSurfaces[index]
	End
	
	Method AddChild:Void(bone:Bone)
		If bone.mParent = Null
			bone.mParent = Self
			mChildren = mChildren.Resize(mChildren.Length() + 1)
			mChildren[mChildren.Length() - 1] = bone
		End
	End
	
	Method GetNumChildren%()
		Return mChildren.Length()
	End
	
	Method GetChild:Bone(index%)
		Return mChildren[index]
	End
	
	Method Find:Bone(name$)
		If mName = name Return Self
		For Local child:Bone = Eachin mChildren
			Local bone:Bone = child.Find(name)
			If bone <> Null Then Return bone
		Next
		Return Null
	End
	
	Method AddPositionKey:Void(keyframe%, x#, y#, z#)
		mPositionKeys = mPositionKeys.Resize(mPositionKeys.Length() + 1)
		mPositions = mPositions.Resize(mPositions.Length() + 1)
		mPositionKeys[mPositionKeys.Length() - 1] = keyframe
		mPositions[mPositions.Length() - 1] = Vec3.Create(x, y, z)
	End
	
	Method AddRotationKey:Void(keyframe%, w#, x#, y#, z#)
		mRotationKeys = mRotationKeys.Resize(mRotationKeys.Length() + 1)
		mRotations = mRotations.Resize(mRotations.Length() + 1)
		mRotationKeys[mRotationKeys.Length() - 1] = keyframe
		mRotations[mRotations.Length() - 1] = Quat.Create(w, x, y, z)
	End
	
	Method AddScaleKey:Void(keyframe%, x#, y#, z#)
		mScaleKeys = mScaleKeys.Resize(mScaleKeys.Length() + 1)
		mScales = mScales.Resize(mScales.Length() + 1)
		mScaleKeys[mScaleKeys.Length() - 1] = keyframe
		mScales[mScales.Length() - 1] = Vec3.Create(x, y, z)
	End
	
	Method Draw:Void(animated:Bool, frame#, firstSeqFrame%, lastSeqFrame%)
		'Store model matrix
		mPrevMatrix.Set(Renderer.GetModelMatrix())
		
		'Set new model matrix
		If animated
			CalcCurrentTransform(frame, firstSeqFrame, lastSeqFrame)
			Renderer.GetModelMatrix().Mul(GetCurrentTransform())
		Else
			Renderer.GetModelMatrix().Mul(GetDefaultTransform())
		End
		Renderer.SetModelMatrix(Renderer.GetModelMatrix())
		
		'Draw surfaces
		For Local surf:Surface = Eachin mSurfaces
			surf.Draw()
		Next
		
		'Draw children
		For Local child:Bone = Eachin mChildren
			child.Draw(animated, frame, firstSeqFrame, lastSeqFrame)
		Next
		
		'Restore previous model matrix
		Renderer.SetModelMatrix(mPrevMatrix)
	End
Private
	Method New()
	End
	
	Method CalcPosition:Void(frame#, firstSeqFrame%, lastSeqFrame%)
		Local firstFrameIndex% = -1
		For Local i% = 0 Until mPositionKeys.Length()
			'Find first frame
			If mPositionKeys[i] < firstSeqFrame
				Continue
			Elseif mPositionKeys[i] = firstSeqFrame
				firstFrameIndex = i
			End
			
			'Found frame
			If mPositionKeys[i] = frame
				mTempVec.Set(mPositions[i])
				Return
			'Found next frame
			Elseif mPositionKeys[i] > frame
				mTempVec.Set(mPositions[i-1])
				mTempVec.Mix(mPositions[i], (frame - mPositionKeys[i-1]) / (mPositionKeys[i] - mPositionKeys[i-1]))
				Return
			'Found first frame outside sequence
			Elseif mPositionKeys[i] > lastSeqFrame
				mTempVec.Set(mPositions[i-1])
				mTempVec.Mix(mPositions[firstFrameIndex], frame - Int(frame))
				Return
			End
		Next
		mTempVec.Set(mPositions[mPositions.Length()-1])
		mTempVec.Mix(mPositions[firstFrameIndex], frame - Int(frame))
	End
	
	Method CalcRotation:Void(frame#, firstSeqFrame%, lastSeqFrame%)
		Local firstFrameIndex% = -1
		For Local i% = 0 Until mRotationKeys.Length()
			'Find first frame
			If mRotationKeys[i] < firstSeqFrame
				Continue
			Elseif mRotationKeys[i] = firstSeqFrame
				firstFrameIndex = i
			End
			
			'Found frame
			If mRotationKeys[i] = frame
				mTempQuat.Set(mRotations[i])
				Return
			'Found next frame
			Elseif mRotationKeys[i] > frame
				mTempQuat.Set(mRotations[i-1])
				mTempQuat.Slerp(mRotations[i], (frame - mRotationKeys[i-1]) / (mRotationKeys[i] - mRotationKeys[i-1]))
				Return
			'Found first frame outside sequence
			Elseif mRotationKeys[i] > lastSeqFrame
				mTempQuat.Set(mRotations[i-1])
				mTempQuat.Slerp(mRotations[firstFrameIndex], frame - Int(frame))
				Return
			End
		Next
		mTempQuat.Set(mRotations[mRotations.Length()-1])
		mTempQuat.Slerp(mRotations[firstFrameIndex], frame - Int(frame))
	End
	
	Method CalcScale:Void(frame#, firstSeqFrame%, lastSeqFrame%)
		Local firstFrameIndex% = -1
		For Local i% = 0 Until mScaleKeys.Length()
			'Find first frame
			If mScaleKeys[i] < firstSeqFrame
				Continue
			Elseif mScaleKeys[i] = firstSeqFrame
				firstFrameIndex = i
			End
			
			'Found frame
			If mScaleKeys[i] = frame
				mTempVec.Set(mScales[i])
				Return
			'Found next frame
			Elseif mScaleKeys[i] > frame
				mTempVec.Set(mScales[i-1])
				mTempVec.Mix(mScales[i], (frame - mScaleKeys[i-1]) / (mScaleKeys[i] - mScaleKeys[i-1]))
				Return
			'Found first frame outside sequence
			Elseif mScaleKeys[i] > lastSeqFrame
				mTempVec.Set(mScales[i-1])
				mTempVec.Mix(mScales[firstFrameIndex], frame - Int(frame))
				Return
			End
		Next
		mTempVec.Set(mScales[mScales.Length()-1])
		mTempVec.Mix(mScales[firstFrameIndex], frame - Int(frame))
	End

	Field mName				: String
	Field mParent			: Bone
	Field mDefaultTransform	: Mat4
	Field mCurrentTransform	: Mat4
	Field mSurfaces			: Surface[]
	Field mChildren			: Bone[]
	Field mPositionKeys		: Int[]
	Field mRotationKeys		: Int[]
	Field mScaleKeys		: Int[]
	Field mPositions		: Vec3[]
	Field mRotations		: Quat[]
	Field mScales			: Vec3[]
	Field mPrevMatrix		: Mat4	'Used to store previous model matrix when rendering, so it can be restored later
	Global mTempVec			: Vec3 = Vec3.Create()	'Used for temp operations
	Global mTempQuat		: Quat = Quat.Create()	'Used for temp operations
End
