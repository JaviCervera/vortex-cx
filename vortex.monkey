Strict

Private

Import src.renderer

Public

Import src.config
Import src.bone
Import src.brush
Import src.cache
Import src.drawable
Import src.font
Import src.lighting
Import src.mesh
Import src.painter
Import src.surface
Import src.texture
Import src.viewer

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
