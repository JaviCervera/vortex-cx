Strict

Private
Import renderer
Import texture

Public
Class Framebuffer
Public
	Function Create:Framebuffer(colorTex:Texture, depthTex:Texture)
		Local colorHandle:Int = 0
		Local depthHandle:Int = 0
		If colorTex Then colorHandle = colorTex.Handle
		If depthTex Then depthHandle = depthTex.Handle
		
		Local fb:Framebuffer = New Framebuffer
		fb.mHandle = Renderer.CreateFramebuffer(colorHandle, depthHandle)
		fb.mColorTex = colorTex
		fb.mDepthTex = depthTex
		Return fb
	End
	
	Method Free:Void(freeTextures:Bool = True)
		If freeTextures
			If mColorTex Then mColorTex.Free()
			If mDepthTex Then mDepthTex.Free()
		End
		Renderer.FreeFramebuffer(mHandle)
	End
	
	Method Set:Void()
		Renderer.SetFramebuffer(mHandle)
	End
	
	Function SetScreen:Void()
		Renderer.SetFramebuffer(0)
	End
	
	Method Handle:Int() Property
		Return mHandle
	End
	
	Method ColorTexture:Texture() Property
		Return mColorTex
	End
	
	Method DepthTexture:Texture() Property
		Return mDepthTex
	End
Private
	Method New()
	End
	
	Field mHandle	: Int
	Field mColorTex	: Texture
	Field mDepthTex	: Texture
End
