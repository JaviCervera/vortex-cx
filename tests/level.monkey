Strict

#GLFW_WINDOW_TITLE="Vortex Tests"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#OPENGL_DEPTH_BUFFER_ENABLED=True

Import vortex
Import mojo.app
Import mojo.input

Class LevelApp Extends App Final
Public
	Method OnCreate%()
		SetUpdateRate(0)
		Seed = Millisecs()
		lastMillisecs = Millisecs()
	
		'Init vortex
		Vortex.Init()
		Print "API version: " + Vortex.GetAPIVersion()
		Print "Shading version: " + Vortex.GetShadingVersion()
		Print "Shader compilation: " + Vortex.GetShaderError()
		
		'Initialize cache
		Cache.Push()
		
		'Create viewer
		viewer = Viewer.Create(0, 0, DeviceWidth(), DeviceHeight())
		viewer.SetClearColor(0,0,0)
		viewer.SetPosition(0, 100, -100)
		
		'Load level mesh
		Local mesh:Mesh = Cache.GetMesh("simple-dm5.msh.xml")
		level = Drawable.Create(mesh)
			
		Return False
	End
	
	Method OnUpdate%()
		'Update delta time
		deltaTime = (Millisecs() - lastMillisecs) / 1000.0
		lastMillisecs = Millisecs()
	
		'End with escape key
		#If TARGET<>"html5"
		If KeyHit(KEY_ESCAPE) Then EndApp()
		#End
		
		'Update viewer perspective and viewport
		viewer.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 10000)
		viewer.SetViewport(0, 0, DeviceWidth(), DeviceHeight())
		viewer.SetEuler(viewer.GetEulerX(), viewer.GetEulerY() + 32 * GetDeltaTime(), viewer.GetEulerZ())

		Return False
	End
	
	Method OnRender%()
		'Update FPS
		fpsCounter += 1
		fpsAccum += deltaTime
		If fpsAccum >= 1
			currentFPS = fpsCounter
			fpsCounter = 0
			fpsAccum = 0
		End
	
		viewer.Prepare()
		level.Draw()
	
		Return False
	End
	
	Method GetDeltaTime#()
		Return deltaTime
	End
	
	Method GetFPS%()
		Return currentFPS
	End
Private
	Global lastMillisecs%
	Global deltaTime#
	Global currentFPS%
	Global fpsCounter%
	Global fpsAccum#
	
	Field viewer:Viewer
	Field level:Drawable
End

Function Main:Int()
	New LevelApp()
	Return False
End
