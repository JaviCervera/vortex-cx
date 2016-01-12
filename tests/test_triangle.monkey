Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class TriangleTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer_Create(0, 0, DeviceWidth(), DeviceHeight())
		Viewer_SetClearColor(mViewer, 1, 1, 1)
		Viewer_SetPosition(mViewer, 0, 0, -4)
		Viewer_SetEuler(mViewer, 0, 0, 0)
		
		'Make triangle
		Local mesh:Object = Mesh_Create(False)
		Local surf:Object = Mesh_AddSurface(mesh)
		Brush_SetCulling(Surface_GetBrush(surf), False)
		Surface_AddTriangle(surf, 0, 1, 2)
		Surface_AddVertex(surf, 0,0.5,0,     0,0,-1, 1,0,0,1, 0,0)
		Surface_AddVertex(surf, 0.5,-0.5,0,  0,0,-1, 0,1,0,1, 0,0)
		Surface_AddVertex(surf, -0.5,-0.5,0, 0,0,-1, 0,0,1,1, 0,0)
		Surface_Rebuild(surf)
		mTri = Drawable_CreateWithMesh(mesh)
	End
	
	Method Update:Void(deltaTime:Float)
		Viewer_SetPerspective(mViewer, 45, Float(DeviceWidth()) / DeviceHeight(), 1, 10)
		Viewer_SetViewport(mViewer, 0, 0, DeviceWidth(), DeviceHeight())
		
		Drawable_SetEuler(mTri, 0, Drawable_GetEulerY(mTri) + 64 * deltaTime, 0)
	End
	
	Method Draw:Void()
		Viewer_Prepare(mViewer)
		Drawable_Draw(mTri)
	End
Private
	Field mViewer	: Object
	Field mTri		: Object
End