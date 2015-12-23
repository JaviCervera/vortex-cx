Strict

Private
Import vortex.core.bone
Import vortex.core.renderer
Import vortex.core.surface

Public
Class Mesh Final
Public
	Function Create:Mesh()
		Local mesh:Mesh = New Mesh
		mesh.mSurfaces = New Surface[0]
		mesh.mLastFrame = 0
		mesh.mRootBone = Null
		Return mesh
	End
	
	Method Discard:Void()
		For Local surf:Surface = Eachin mSurfaces
			surf.Discard()
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
	
	Method Draw:Void(animated:Bool, frame:Float, firstFrame:Int = 0, lastFrame:Int = 0)
		If mRootBone <> Null
			If animated And lastFrame = 0 Then lastFrame = mLastFrame
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
	Field mLastFrame	: Int
	Field mRootBone		: Bone
End
