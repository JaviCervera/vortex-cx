Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class AnimationTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer_Create(0, 0, DeviceWidth(), DeviceHeight())
		Viewer_SetClearColor(mViewer, 1, 1, 1)
		Viewer_SetPosition(mViewer, 0, 64, -128)
		Viewer_SetEuler(mViewer, 15, 0, 0)
		
		'Load font
		mFont = Font_Cache("system_16.fnt.xml")
		
		'Load anim model
		mAnimMesh = Mesh_Cache("dwarf.msh.xml")
		mAnimModel = Drawable_CreateWithMesh(mAnimMesh)
	End
	
	Method Init:Void()
		mCurrentFrame = 0
	End
	
	Method Update:Void(deltaTime:Float)
		Viewer_SetPerspective(mViewer, 45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		Viewer_SetViewport(mViewer, 0, 0, DeviceWidth(), DeviceHeight())
		
		mCurrentFrame += 16 * deltaTime
		If mCurrentFrame > Mesh_GetLastFrame(mAnimMesh)+1 Then mCurrentFrame = mCurrentFrame - Int(mCurrentFrame)
		Drawable_Animate(mAnimModel, mCurrentFrame)
	End
	
	Method Draw:Void()
		Viewer_Prepare(mViewer)
		Drawable_Draw(mAnimModel, True)
		
		Painter_Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Painter_SetColor(0, 0, 0)
		Font_Draw(mFont, 4, DeviceHeight() - 20, "Frame: " + Int(mCurrentFrame))
	End
Private
	Field mViewer		: Object
	Field mFont			: Object
	Field mAnimMesh		: Object
	Field mAnimModel	: Object
	Field mCurrentFrame	: Float
End
