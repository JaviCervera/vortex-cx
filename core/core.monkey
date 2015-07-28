Strict

Private
Import vortex.core.renderer

Public
Import vortex.core.bone
Import vortex.core.brush
Import vortex.core.drawable
Import vortex.core.font
Import vortex.core.lighting
Import vortex.core.mesh
Import vortex.core.painter
Import vortex.core.surface
Import vortex.core.texture
Import vortex.core.viewer

Class Vortex Final
Public
	Function Init:Bool()
		Return Renderer.Init()
	End
	
	Function GetShaderError$()
		Return Renderer.GetProgramError()
	End
Private
	Method New()
	End
End