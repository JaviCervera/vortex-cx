Strict

Class Sequence Final
Public
	Function Create:Sequence(name$, firstFrame%, lastFrame%)
		Local seq:Sequence = New Sequence
		seq.mName = name
		seq.mFirstFrame = firstFrame
		seq.mLastFrame = lastFrame
		Return seq
	End
	
	Method GetName$()
		Return mName
	End
	
	Method GetFirstFrame%()
		Return mFirstFrame
	End
	
	Method GetLastFrame%()
		Return mLastFrame
	End
	
	Method GetNumFrames%()
		Return mLastFrame - mFirstFrame
	End
Private
	Method New()
	End
	
	Field mName			: String
	Field mFirstFrame	: Int
	Field mLastFrame	: Int
End