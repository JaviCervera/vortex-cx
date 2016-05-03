Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class ImageTest Extends Test Final
	Method New()
		mImage = Cache.GetTexture("smile.png")
	End
	
	Method Draw:Void()
		Painter.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Painter.Cls()
		mImage.Draw((DeviceWidth() - mImage.GetWidth())/2, (DeviceHeight() - mImage.GetHeight())/2)
	End
Private
	Field mImage	: Texture
End