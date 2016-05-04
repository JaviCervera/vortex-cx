Strict

Import src.config
Import src.bone
Import src.brush
Import src.cache
Import src.font
Import src.lighting
Import src.math3d
Import src.mesh
Import src.renderer
Import src.surface
Import src.texture

Class Vortex Final
Public
	Function Init:Bool()
		Return Renderer.Init()
	End

	Function GetShaderError:String()
		Return Renderer.GetProgramError()
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
