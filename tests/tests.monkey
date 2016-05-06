Strict

#GLFW_WINDOW_TITLE="Vortex Tests"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#GLFW_WINDOW_SAMPLES=2
#OPENGL_DEPTH_BUFFER_ENABLED=True

Import mojo.app
Import mojo.input
Import test
Import test_primitives
Import test_image
Import test_triangle
Import test_billboards
Import test_lighting
Import test_animation
Import test_level
Import vortex

Class TestApp Extends App Final
Public
	Method OnCreate:Int()
		SetUpdateRate(0)
		Seed = Millisecs()
		lastMillisecs = Millisecs()
	
		'Init vortex
		Vortex.Init()
		Print "API version: " + Vortex.GetAPIVersion()
		Print "Shading version: " + Vortex.GetShadingVersion()
		Print "Shader compilation: " + Vortex.GetShaderError()
		
		mTests = New Test[7]
		mTests[0] = New PrimitivesTest
		mTests[1] = New ImageTest
		mTests[2] = New TriangleTest
		mTests[3] = New BillboardsTest
		mTests[4] = New LightingTest
		mTests[5] = New AnimationTest
		mTests[6] = New LevelTest
		mCurrentTest = 0
		
		'Load font
		mFont = Cache.GetFont("system_16.fnt.xml")
			
		Return False
	End
	
	Method OnUpdate:Int()
		'Update delta time
		deltaTime = (Millisecs() - lastMillisecs) / 1000.0
		lastMillisecs = Millisecs()
	
		'End with escape key
		#If TARGET<>"html5"
		If KeyHit(KEY_ESCAPE) Then EndApp()
		#End
		
		'Change test with space key
		If KeyHit(KEY_SPACE) Or TouchHit(0)
			mCurrentTest += 1
			If mCurrentTest >= mTests.Length() Then mCurrentTest = 0
			mTests[mCurrentTest].Init()
		End
		
		mTests[mCurrentTest].Update(deltaTime)

		Return False
	End
	
	Method OnRender:Int()
		'Update FPS
		fpsCounter += 1
		fpsAccum += deltaTime
		If fpsAccum >= 1
			currentFPS = fpsCounter
			fpsCounter = 0
			fpsAccum = 0
		End
		
		mTests[mCurrentTest].Draw()
		
		'Setup painter for 2D graphics
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		
		'Paint black margin on top of screen
		Renderer.SetColor(0, 0, 0)
		Renderer.DrawRect(0, 0, 0, DeviceWidth(), 24)
		
		'Draw FPS
		Renderer.SetColor(1, 0, 0)
		Local text$ = currentFPS + " FPS"
		mFont.Draw(2, 6, text)
		
		'Draw RenderCalls
		Renderer.SetColor(1, 0, 1)
		text = "Render calls: " + mTests[mCurrentTest].GetNumRenderCalls()
		mFont.Draw(2, 22, text)
		
		'Draw info
		Renderer.SetColor(1, 1, 0)
		text = "<Press space key or touch screen to change test>"
		mFont.Draw((DeviceWidth() - mFont.GetTextWidth(text))/2, 6, text)
	
		Return False
	End
Private
	Global lastMillisecs	: Int
	Global deltaTime		: Float
	Global currentFPS		: Int
	Global fpsCounter		: Int
	Global fpsAccum			: Float
	
	Field mTests			: Test[]
	Field mCurrentTest		: Int
	
	Field mFont				: Font
End

Function Main:Int()
	New TestApp()
	Return False
End
