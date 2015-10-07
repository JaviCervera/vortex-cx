Strict

Private
Import vortex.core.bone
Import vortex.core.renderer
Import vortex.core.sequence
Import vortex.core.surface

Public
Class Mesh Final
Public
	Function Create:Mesh(filename$ = "")
		Local mesh:Mesh = New Mesh
		mesh.mFilename = filename
		mesh.mSurfaces = New Surface[0]
		mesh.mSequences = New Sequence[0]
		mesh.mRootBone = Null
		Return mesh
	End
	
	Method Discard:Void()
		For Local surf:Surface = Eachin mSurfaces
			surf.Discard()
		Next
	End
	
	Method GetFilename$()
		Return mFilename
	End
	
	Method AddSurface:Void(surf:Surface)
		mSurfaces = mSurfaces.Resize(mSurfaces.Length() + 1)
		mSurfaces[mSurfaces.Length()-1] = surf
		surf.Rebuild()
	End
	
	Method GetNumSurfaces%()
		Return mSurfaces.Length()
	End
	
	Method GetSurface:Surface(index%)
		Return mSurfaces[index]
	End
	
	Method AddSequence%(name$, firstFrame%, lastFrame%)
		mSequences = mSequences.Resize(mSequences.Length() + 1)
		mSequences[mSequences.Length()-1] = Sequence.Create(name, firstFrame, lastFrame)
		Return GetNumSequences()-1
	End
	
	Method GetNumSequences%()
		Return mSequences.Length()
	End
	
	Method FindSequence%(name$)
		For Local i% = 0 Until GetNumSequences()
			If GetSequenceName(i) = name Then Return i
		Next
		Return -1
	End
	
	Method GetSequenceName$(index%)
		Return mSequences[index].GetName()
	End
	
	Method GetSequenceFirstFrame%(index%)
		Return mSequences[index].GetFirstFrame()
	End
	
	Method GetSequenceLastFrame%(index%)
		Return mSequences[index].GetLastFrame()
	End
	
	Method GetSequenceNumFrames%(index%)
		Return mSequences[index].GetNumFrames()
	End
	
	Method SetRootBone:Bool(bone:Bone)
		If GetRootBone() = Null
			mRootBone = bone
			Return True
		Else
			Return False
		End
	End
	
	Method GetRootBone:Bone()
		Return mRootBone
	End
	
	Method Draw:Void(animated:Bool, frame#, sequence%)
		If mRootBone <> Null
			Local firstFrame% = 0
			Local lastFrame% = 0
			If animated
				firstFrame = mSequences[sequence].GetFirstFrame()
				lastFrame = mSequences[sequence].GetLastFrame()
			End
			mRootBone.Draw(animated, frame, firstFrame, lastFrame)
		Else
			For Local i% = 0 Until GetNumSurfaces()
				GetSurface(i).Draw()
			Next
		End
	End
Private
	Method New()
	End

	Field mFilename		: String
	Field mSurfaces		: Surface[]
	Field mSequences	: Sequence[]
	Field mRootBone		: Bone
End
