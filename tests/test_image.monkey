Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class ImageTest Extends Test Final
	Method New()
		mImage = Texture_Cache("smile.png")
	End
	
	Method Draw:Void()
		Painter_Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Painter_Cls()
		Texture_Draw(mImage, (DeviceWidth() - Texture_GetWidth(mImage))/2, (DeviceHeight() - Texture_GetHeight(mImage))/2)
	End
Private
	Field mImage	: Object
End