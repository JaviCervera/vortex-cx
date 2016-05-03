Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class BillboardsTest Extends Test Final
	Method New()
		'Create viewer
		mViewer = Viewer.Create(0, 0, DeviceWidth(), DeviceHeight())
		mViewer.SetClearColor(1, 1, 1)
		
		'Load texture
		mTexture = Cache.GetTexture("smile.png")
		
		'Create billboards
		mBillboards = New Drawable[64]
		Local x:Int = -8, z:Int = -8
		For Local i:Int = 0 Until mBillboards.Length()
			mBillboards[i] = Drawable.Create(Brush.Create(mTexture), 1, 1, Drawable.BILLBOARD_SPHERICAL)
			mBillboards[i].GetSurface().GetBrush().SetBaseColor(Rnd(0, 1), Rnd(0, 1), Rnd(0, 1))
			mBillboards[i].SetPosition(x, 0, z)
			x += 2; If x >= 8 Then x = -8; z += 2
		Next
	End
	
	Method Update:Void(deltaTime:Float)
		mViewer.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 100)
		mViewer.SetViewport(0, 0, DeviceWidth(), DeviceHeight())
		mViewer.SetEuler(45, mViewer.GetEulerY() + 32 * deltaTime, 0)
		mViewer.SetPosition(0, 0, 0)
		mViewer.Move(0, 0, -8)
	End
	
	Method Draw:Void()
		mViewer.Prepare()
		For Local bb:Drawable = Eachin mBillboards
			bb.Draw()
		Next
	End
Private
	Field mViewer		: Viewer
	Field mTexture		: Texture
	Field mBillboards	: Drawable[]
End