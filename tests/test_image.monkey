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
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.ClearColorBuffer()
		mImage.Draw((DeviceWidth() - mImage.GetWidth())/2, (DeviceHeight() - mImage.GetHeight())/2)
	End
	
	Method GetNumRenderCalls:Int()
		Return 1
	End
Private
	Field mImage	: Texture
End