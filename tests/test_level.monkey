Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class LevelTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer_Create(0, 0, DeviceWidth(), DeviceHeight())
		Viewer_SetClearColor(mViewer, 0, 0, 0)
		Viewer_SetPosition(mViewer, 0, 100, 0)
		
		'Load level
		Local levelMesh:Object = Mesh_Cache("simple-dm5.msh.xml")
		mLevel = Drawable_CreateWithMesh(levelMesh)
	End
	
	Method Update:Void(deltaTime:Float)
		Viewer_SetPerspective(mViewer, 45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		Viewer_SetViewport(mViewer, 0, 0, DeviceWidth(), DeviceHeight())
		Viewer_SetEuler(mViewer, 0, Viewer_GetEulerY(mViewer) - 32 * deltaTime, 0)
	End
	
	Method Draw:Void()
		Viewer_Prepare(mViewer)
		Drawable_Draw(mLevel)
	End
Private
	Field mViewer	: Object
	Field mLevel	: Object
End
