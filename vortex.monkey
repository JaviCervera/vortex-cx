Strict

Import src.bone
Import src.cache
Import src.font
Import src.lighting
Import src.material
Import src.math3d
Import src.mesh
Import src.renderbatch
Import src.renderer
Import src.surface
Import src.texture

Class Vortex Final
Public
	Function Init:Bool()
		If Renderer.Init()
			Cache.Push()
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
