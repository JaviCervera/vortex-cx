Strict

Import vortex.src.bone
Import vortex.src.font
Import vortex.src.framebuffer
Import vortex.src.lighting
Import vortex.src.material
Import vortex.src.math3d
Import vortex.src.mesh
Import vortex.src.renderer
Import vortex.src.renderlist
Import vortex.src.surface
Import vortex.src.texture

Class Vortex Final
Public
	Function Init:Bool(numLights:Int = 8, numBones:Int = 75)
		If Renderer.Init(numLights, numBones)
			Return True
		Else
			Return False
		End
	End

	Function ShaderError:String()
		Return Renderer.ProgramError()
	End
	
	Function VendorName:String()
		Return Renderer.VendorName()
	End
	
	Function RendererName:String()
		Return Renderer.RendererName()
	End
	
	Function APIVersionName:String()
		Return Renderer.APIVersionName()
	End
	
	Function ShadingVersionName:String()
		Return Renderer.ShadingVersionName()
	End

	Function APIVersion:Float()
		Return Renderer.APIVersion()
	End Function

	Function ShadingVersion:Float()
		Return Renderer.ShadingVersion()
	End Function
Private
	Method New()
	End
End
