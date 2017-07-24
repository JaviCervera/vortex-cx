Strict

Private
Import vortex.src.math3d
Import vortex.src.renderer
Import vortex.src.surface

Public
Class Bone Final
Public
	Function Create:Bone(name:String, parentIndex:Int)
		Local bone:Bone = New Bone
		bone.mName = name
		bone.mParentIndex = parentIndex
		bone.mInvPoseMatrix = Mat4.Create()
		bone.mPositionKeys = New Int[0]
		bone.mRotationKeys = New Int[0]
		bone.mScaleKeys = New Int[0]
		bone.mPositions = New Vec3[0]
		bone.mRotations = New Quat[0]
		bone.mScales = New Vec3[0]
		Return bone
	End
	
	Function Create:Bone(other:Bone)
		Local bone:Bone = Bone.Create(other.mName, other.mParentIndex)
		bone.mInvPoseMatrix = Mat4.Create(other.mInvPoseMatrix)
		bone.mPositionKeys = other.mPositionKeys[..]
		bone.mRotationKeys = other.mRotationKeys[..]
		bone.mScaleKeys = other.mScaleKeys[..]
		bone.mPositions = New Vec3[other.mPositions.Length()]
		For Local i:Int = 0 Until other.mPositions.Length()
			bone.mPositions[i] = Vec3.Create(other.mPositions[i])
		Next
		bone.mRotations = New Quat[other.mRotations.Length()]
		For Local i:Int = 0 Until other.mRotations.Length()
			bone.mRotations[i] = Quat.Create(other.mRotations[i])
		Next
		bone.mScales = New Vec3[other.mScales.Length()]
		For Local i:Int = 0 Until other.mScales.Length()
			bone.mScales[i] = Vec3.Create(other.mScales[i])
		Next
		Return bone
	End

	Method Name:String() Property
		Return mName
	End

	Method ParentIndex:Int() Property
		Return mParentIndex
	End
	
	Method InversePoseMatrix:Void(m:Mat4) Property
		mInvPoseMatrix.Set(m)
	End
	
	Method InversePoseMatrix:Mat4() Property
		Return mInvPoseMatrix
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

	Method NumPositionKeys:Int() Property
		Return mPositionKeys.Length
	End

	Method PositionKeyFrame:Int(index:Int)
		Return mPositionKeys[index]
	End

	Method PositionKeyX:Float(index:Int)
		Return mPositions[index].X
	End

	Method PositionKeyY:Float(index:Int)
		Return mPositions[index].Y
	End

	Method PositionKeyZ:Float(index:Int)
		Return mPositions[index].Z
	End

	Method NumRotationKeys:Int() Property
		Return mRotationKeys.Length
	End

	Method RotationKeyFrame:Int(index:Int)
		Return mRotationKeys[index]
	End

	Method RotationKeyW:Float(index:Int)
		Return mRotations[index].W
	End

	Method RotationKeyX:Float(index:Int)
		Return mRotations[index].X
	End

	Method RotationKeyY:Float(index:Int)
		Return mRotations[index].Y
	End

	Method RotationKeyZ:Float(index:Int)
		Return mRotations[index].Z
	End

	Method NumScaleKeys:Int() Property
		Return mScaleKeys.Length
	End

	Method ScaleKeyFrame:Int(index:Int)
		Return mScaleKeys[index]
	End

	Method ScaleKeyX:Float(index:Int)
		Return mScales[index].X
	End

	Method ScaleKeyY:Float(index:Int)
		Return mScales[index].Y
	End

	Method ScaleKeyZ:Float(index:Int)
		Return mScales[index].Z
	End
	
	Method CalculateAnimMatrix:Void(animMatrix:Mat4, frame:Float, firstFrame:Int, lastFrame:Int)
		'Check if there is a keyframe within range
		Local keyInRange:Bool = False
		For Local i:Int = Eachin mPositionKeys
			If i >= firstFrame And i <= lastFrame
				keyInRange = True
				Exit
			End
		Next

		'If there are keyframes in the sequence, interpolate
		If keyInRange
			Local px#, py#, pz#, sx#, sy#, sz#

			'Calculate interpolated position
			CalcPosition(frame, firstFrame, lastFrame)
			px = mTempVec.X
			py = mTempVec.Y
			pz = mTempVec.Z

			'Calculate interpolated rotation
			CalcRotation(frame, firstFrame, lastFrame)
			mTempQuat.CalcAxis()

			'Calculate interpolated scale
			CalcScale(frame, firstFrame, lastFrame)
			sx = mTempVec.X
			sy = mTempVec.Y
			sz = mTempVec.Z

			'Set matrix
			animMatrix.SetIdentity()
			animMatrix.Translate(px, py, pz)
			animMatrix.Rotate(mTempQuat.Angle(), mTempQuat.ResultVector().X, mTempQuat.ResultVector().Y, mTempQuat.ResultVector().Z)
			animMatrix.Scale(sx, sy, sz)
		'If not, define default transform
		Else
			'animMatrix.Set(mPoseMatrix)
			animMatrix.SetIdentity()
		End
	End
Private
	Method New()
	End

	Method CalcPosition:Void(frame:Float, firstSeqFrame:Int, lastSeqFrame:Int)
		Local firstFrameIndex:Int = -1
		For Local i:Int = 0 Until mPositionKeys.Length()
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
		Local firstFrameIndex:Int = -1
		For Local i:Int = 0 Until mRotationKeys.Length()
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
		Local firstFrameIndex:Int = -1
		For Local i:Int = 0 Until mScaleKeys.Length()
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
	Field mParentIndex		: Int
	Field mInvPoseMatrix	: Mat4
	Field mPositionKeys		: Int[]
	Field mRotationKeys		: Int[]
	Field mScaleKeys		: Int[]
	Field mPositions		: Vec3[]
	Field mRotations		: Quat[]
	Field mScales			: Vec3[]
	Global mTempVec			: Vec3 = Vec3.Create()	'Used for temp operations
	Global mTempQuat		: Quat = Quat.Create()	'Used for temp operations
End
