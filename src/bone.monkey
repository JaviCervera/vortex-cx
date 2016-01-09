Strict

Private
Import vortex.src.math3d
Import vortex.src.renderer
Import vortex.src.surface

Public
Class Bone Final
Public
	Function Create:Bone(name:String)
		Local bone:Bone = New Bone
		bone.mName = name
		bone.mParent = Null
		bone.mPoseMatrix = Mat4.Create()
		bone.mInvPoseMatrix = Mat4.Create()
		bone.mSurfaces = New Surface[0]
		bone.mPositionKeys = New Int[0]
		bone.mRotationKeys = New Int[0]
		bone.mScaleKeys = New Int[0]
		bone.mPositions = New Vec3[0]
		bone.mRotations = New Quat[0]
		bone.mScales = New Vec3[0]
		bone.mTempMatrix = Mat4.Create()
		Return bone
	End

	Method GetName:String()
		Return mName
	End
	
	Method SetParent:Void(parent:Bone)
		mParent = parent
	End

	Method GetParent:Bone()
		Return mParent
	End
	
	Method CalcPoseMatrix:Void(px:Float, py:Float, pz:Float, rw:Float, rx:Float, ry:Float, rz:Float, sx:Float, sy:Float, sz:Float)
		mTempQuat.Set(rw, rx, ry, rz)
		mTempQuat.CalcAxis()
		mTempMatrix.SetIdentity()
		mTempMatrix.Translate(px, py, pz)
		mTempMatrix.Rotate(mTempQuat.Angle(), mTempQuat.ResultVector().x, mTempQuat.ResultVector().y, mTempQuat.ResultVector().z)
		mTempMatrix.Scale(sx, sy, sz)
		
		If mParent = Null
			mPoseMatrix.Set(mTempMatrix)
			mInvPoseMatrix.Set(mPoseMatrix)
			mInvPoseMatrix.Invert()
		Else
			mPoseMatrix.Set(mParent.mPoseMatrix)
			mPoseMatrix.Mul(mTempMatrix)
			mInvPoseMatrix.Set(mPoseMatrix)
			mInvPoseMatrix.Invert()
		End
	End
	
	Method GetPoseMatrix:Float[]()
		Return mPoseMatrix.m
	End
	
	Method GetInversePoseMatrix:Float[]()
		Return mInvPoseMatrix.m
	End

	Method AddSurface:Void(surf:Surface)
		mSurfaces = mSurfaces.Resize(mSurfaces.Length() + 1)
		mSurfaces[mSurfaces.Length() - 1] = surf
	End

	Method GetNumSurfaces:Int()
		Return mSurfaces.Length()
	End

	Method GetSurface:Surface(index:Int)
		Return mSurfaces[index]
	End

	Method AddPositionKey:Void(keyframe:Int, x:Float, y:Float, z:Float)
		mPositionKeys = mPositionKeys.Resize(mPositionKeys.Length() + 1)
		mPositions = mPositions.Resize(mPositions.Length() + 1)
		mPositionKeys[mPositionKeys.Length() - 1] = keyframe
		mPositions[mPositions.Length() - 1] = Vec3.Create(x, y, z)
	End

	Method AddRotationKey:Void(keyframe:Int, w:Float, x:Float, y:Float, z:Float)
		mRotationKeys = mRotationKeys.Resize(mRotationKeys.Length() + 1)
		mRotations = mRotations.Resize(mRotations.Length() + 1)
		mRotationKeys[mRotationKeys.Length() - 1] = keyframe
		mRotations[mRotations.Length() - 1] = Quat.Create(w, x, y, z)
	End

	Method AddScaleKey:Void(keyframe:Int, x:Float, y:Float, z:Float)
		mScaleKeys = mScaleKeys.Resize(mScaleKeys.Length() + 1)
		mScales = mScales.Resize(mScales.Length() + 1)
		mScaleKeys[mScaleKeys.Length() - 1] = keyframe
		mScales[mScales.Length() - 1] = Vec3.Create(x, y, z)
	End

	Method GetNumPositionKeys:Int()
		Return mPositionKeys.Length()
	End

	Method GetPositionKeyFrame:Int(index:Int)
		Return mPositionKeys[index]
	End

	Method GetPositionKeyX:Float(index:Int)
		Return mPositions[index].x
	End

	Method GetPositionKeyY:Float(index:Int)
		Return mPositions[index].y
	End

	Method GetPositionKeyZ:Float(index:Int)
		Return mPositions[index].z
	End

	Method GetNumRotationKeys:Int()
		Return mRotationsKeys.Length()
	End

	Method GetRotationKeyFrame:Int(index:Int)
		Return mRotationKeys[index]
	End

	Method GetRotationKeyW:Float(index:Int)
		Return mRotations[index].w
	End

	Method GetRotationKeyX:Float(index:Int)
		Return mRotations[index].x
	End

	Method GetRotationKeyY:Float(index:Int)
		Return mRotations[index].y
	End

	Method GetRotationKeyZ:Float(index:Int)
		Return mRotations[index].z
	End

	Method GetNumScaleKeys:Int()
		Return mScaleKeys.Length()
	End

	Method GetScaleKeyFrame:Int(index:Int)
		Return mScaleKeys[index]
	End

	Method GetScaleKeyX:Float(index:Int)
		Return mScales[index].x
	End

	Method GetScaleKeyY:Float(index:Int)
		Return mScales[index].y
	End

	Method GetScaleKeyZ:Float(index:Int)
		Return mScales[index].z
	End
	
	Method Animate:Void(animMatrix:Mat4, parentAnimMatrix:Mat4, frame:Float, firstFrame:Int, lastFrame:Int)
		CalcAnimMatrix(animMatrix, parentAnimMatrix, frame, firstFrame, lastFrame)
	End

	Method Draw:Void(animated:Bool, animMatrix:Mat4)
		If mSurfaces.Length() > 0
			'Store model matrix
			mTempMatrix.Set(Renderer.GetModelMatrix())

			'Set new model matrix
			If animated
				Renderer.GetModelMatrix().Mul(animMatrix)
			Else
				Renderer.GetModelMatrix().Mul(GetPoseMatrix())
			End
			Renderer.SetModelMatrix(Renderer.GetModelMatrix())	'Load the updated model matrix into the shader

			'Draw surfaces
			For Local surf:Surface = Eachin mSurfaces
				surf.Draw()
			Next

			'Restore previous model matrix
			Renderer.SetModelMatrix(mTempMatrix)
		End
	End
Private
	Method New()
	End
	
	Method CalcAnimMatrix:Void(animMatrix:Mat4, parentAnimMatrix:Mat4, frame:Float, firstSeqFrame:Int, lastSeqFrame:Int)
		'NOTE: On a skinned mesh, after calculating this matrix for all bones,
		'you need to multiply whatever all of them by the inverse pose matrix!
	
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
			If parentAnimMatrix Then animMatrix.Set(parentAnimMatrix) Else animMatrix.SetIdentity()
			animMatrix.Translate(px, py, pz)
			animMatrix.Rotate(mTempQuat.Angle(), mTempQuat.ResultVector().x, mTempQuat.ResultVector().y, mTempQuat.ResultVector().z)
			animMatrix.Scale(sx, sy, sz)
		'If not, define default transform
		Else
			animMatrix.Set(mPoseMatrix)
		End
	End

	Method CalcPosition:Void(frame:Float, firstSeqFrame:Int, lastSeqFrame:Int)
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

	Method CalcRotation:Void(frame:Float, firstSeqFrame:Int, lastSeqFrame:Int)
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

	Method CalcScale:Void(frame:Float, firstSeqFrame:Int, lastSeqFrame:Int)
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
	Field mPoseMatrix		: Mat4
	Field mInvPoseMatrix	: Mat4
	Field mSurfaces			: Surface[]
	Field mPositionKeys		: Int[]
	Field mRotationKeys		: Int[]
	Field mScaleKeys		: Int[]
	Field mPositions		: Vec3[]
	Field mRotations		: Quat[]
	Field mScales			: Vec3[]
	Field mTempMatrix		: Mat4	'Used to store previous model matrix when rendering, so it can be restored later
	Global mTempVec			: Vec3 = Vec3.Create()	'Used for temp operations
	Global mTempQuat		: Quat = Quat.Create()	'Used for temp operations
End
