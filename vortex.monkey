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
			'Cache.Push()
			Return True
		Else
			Return False
		End
	End

	Function GetShaderError:String()
		Return Renderer.GetProgramError()
	End
	
	Function GetVendorName:String()
		Return Renderer.GetVendorName()
	End
	
	Function GetRendererName:String()
		Return Renderer.GetRendererName()
	End
	
	Function GetAPIVersionName:String()
		Return Renderer.GetAPIVersionName()
	End
	
	Function GetShadingVersionName:String()
		Return Renderer.GetShadingVersionName()
	End

	Function GetAPIVersion:Float()
		Return Renderer.GetAPIVersion()
	End Function

	Function GetShadingVersion:Float()
		Return Renderer.GetShadingVersion()
	End Function
Private
	Method New()
	End
End
