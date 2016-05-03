Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class LevelTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer.Create(0, 0, DeviceWidth(), DeviceHeight())
		mViewer.SetClearColor(0, 0, 0)
		mViewer.SetPosition(0, 100, 0)
		
		'Load level
		Local levelMesh:Mesh = Cache.GetMesh("simple-dm5.msh.xml")
		mLevel = Drawable.Create(levelMesh)
	End
	
	Method Update:Void(deltaTime:Float)
		mViewer.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 1000)
		mViewer.SetViewport(0, 0, DeviceWidth(), DeviceHeight())
		mViewer.SetEuler(0, mViewer.GetEulerY() - 32 * deltaTime, 0)
	End
	
	Method Draw:Void()
		mViewer.Prepare()
		mLevel.Draw()
	End
Private
	Field mViewer	: Viewer
	Field mLevel	: Drawable
End
