Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class BillboardsTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer_Create(0, 0, DeviceWidth(), DeviceHeight())
		Viewer_SetClearColor(mViewer, 1, 1, 1)
		
		'Load texture
		mTexture = Texture_Cache("smile.png")
		
		'Create billboards
		mBillboards = New Object[64]
		Local x:Int = -8, z:Int = -8
		For Local i:Int = 0 Until mBillboards.Length()
			mBillboards[i] = Drawable_CreateBillboard(mTexture, 1, 1, BILLBOARD_SPHERICAL)
			Brush_SetBaseColor(Surface_GetBrush(Drawable_GetSurface(mBillboards[i])), Rnd(0, 1), Rnd(0, 1), Rnd(0, 1))
			Drawable_SetPosition(mBillboards[i], x, 0, z)
			x += 2; If x >= 8 Then x = -8; z += 2
		Next
	End
	
	Method Update:Void(deltaTime:Float)
		Viewer_SetPerspective(mViewer, 45, Float(DeviceWidth()) / DeviceHeight(), 1, 100)
		Viewer_SetViewport(mViewer, 0, 0, DeviceWidth(), DeviceHeight())
		Viewer_SetEuler(mViewer, 45, Viewer_GetEulerY(mViewer) + 32 * deltaTime, 0)
		Viewer_SetPosition(mViewer, 0, 0, 0)
		Viewer_Move(mViewer, 0, 0, -8)
	End
	
	Method Draw:Void()
		Viewer_Prepare(mViewer)
		For Local bb:Object = Eachin mBillboards
			Drawable_Draw(bb)
		Next
	End
Private
	Field mViewer		: Object
	Field mTexture		: Object
	Field mBillboards	: Object[]
End