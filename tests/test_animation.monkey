Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class AnimationTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer.Create(0, 0, DeviceWidth(), DeviceHeight())
		mViewer.SetClearColor(1, 1, 1)
		mViewer.SetPosition(0, 64, -128)
		mViewer.SetEuler(15, 0, 0)
		
		'Load font
		mFont = Cache.GetFont("system_16.fnt.xml")
		
		'Load anim model
		mAnimMesh = Cache.GetMesh("dwarf.msh.xml")
		mAnimModel = Drawable.Create(mAnimMesh)
	End
	
	Method Init:Void()
		mCurrentFrame = 0
	End
	
	Method Update:Void(deltaTime:Float)
		mViewer.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mViewer.SetViewport(0, 0, DeviceWidth(), DeviceHeight())
		
		mCurrentFrame += 16 * deltaTime
		If mCurrentFrame > mAnimMesh.GetLastFrame()+1 Then mCurrentFrame = mCurrentFrame - Int(mCurrentFrame)
		mAnimModel.Animate(mCurrentFrame)
	End
	
	Method Draw:Void()
		mViewer.Prepare()
		mAnimModel.Draw(True)
		
		Painter.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Painter.SetColor(0, 0, 0)
		mFont.Draw(4, DeviceHeight() - 20, "Frame: " + Int(mCurrentFrame))
	End
Private
	Field mViewer		: Viewer
	Field mFont			: Font
	Field mAnimMesh		: Mesh
	Field mAnimModel	: Drawable
	Field mCurrentFrame	: Float
End
