Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class TriangleTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer.Create(0, 0, DeviceWidth(), DeviceHeight())
		mViewer.SetClearColor(1, 1, 1)
		mViewer.SetPosition(0, 0, -4)
		mViewer.SetEuler(0, 0, 0)
		
		'Make triangle
		Local mesh:Mesh = Mesh.Create(False)
		Local surf:Surface = Surface.Create()
		surf.GetBrush().SetCulling(False)
		surf.AddTriangle(0, 1, 2)
		surf.AddVertex(0,0.5,0,     0,0,-1, 1,0,0,1, 0,0)
		surf.AddVertex(0.5,-0.5,0,  0,0,-1, 0,1,0,1, 0,0)
		surf.AddVertex(-0.5,-0.5,0, 0,0,-1, 0,0,1,1, 0,0)
		mesh.AddSurface(surf)
		mTri = Drawable.Create(mesh)
	End
	
	Method Update:Void(deltaTime:Float)
		mViewer.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 10)
		mViewer.SetViewport(0, 0, DeviceWidth(), DeviceHeight())
		
		mTri.SetEuler(0, mTri.GetEulerY() + 64 * deltaTime, 0)
	End
	
	Method Draw:Void()
		mViewer.Prepare()
		mTri.Draw()
	End
Private
	Field mViewer	: Viewer
	Field mTri		: Drawable
End