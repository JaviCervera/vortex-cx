Strict

#GLFW_WINDOW_TITLE="Vortex Tests"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#OPENGL_DEPTH_BUFFER_ENABLED=True

'We want a left handed coordinate system
'Import vortex.core.handedness
'#VORTEX_HANDEDNESS=VORTEX_LH

Import vortex
Import mojo.app
Import mojo.input

Const TEST_PRIMITIVES% = 0
Const TEST_IMAGE% = 1
Const TEST_TRIANGLE% = 2
Const TEST_BILLBOARDS% = 3
Const TEST_LIGHTS% = 4
Const TEST_ANIMATION% = 5
Const TEST_FIRST% = 0
Const TEST_LAST% = 5

Const PRIM_POINT% = 0
Const PRIM_LINE% = 1
Const PRIM_RECT% = 2
Const PRIM_ELLIPSE% = 3

Class Prim Final
	Field type%
	Field x#, y#, z#, w#
	Field r#, g#, b#
End

Class TestApp Extends App Final
Public
	Method OnCreate%()
		SetUpdateRate(0)
		Seed = Millisecs()
		currentTest = TEST_FIRST
		lastMillisecs = Millisecs()
	
		'Init vortex
		Vortex.Init()
		Print "API version: " + Vortex.GetAPIVersion()
		Print "Shading version: " + Vortex.GetShadingVersion()
		Print "Shader compilation: " + Vortex.GetShaderError()
		
		'Initialize cache
		Cache.Push()
		
		'Init primitive array
		For Local i% = 0 Until primitives.Length()
			primitives[i] = New Prim
		Next
		
		'Load texture
		tex = Cache.GetTexture("smile.png")
		
		'Load font
		font = Cache.GetFont("eurofurence_24.fnt.json")
		
		'Create viewer
		viewer = Viewer.Create(0, 0, DeviceWidth(), DeviceHeight())
		
		'Make triangle
		Local surf:Surface = Surface.Create()
		surf.GetBrush().SetCulling(False)
		surf.AddTriangle(0, 1, 2)
		surf.AddVertex(0,0.5,0,     0,0,-1, 1,0,0,1, 0,0)
		surf.AddVertex(0.5,-0.5,0,  0,0,-1, 0,1,0,1, 0,0)
		surf.AddVertex(-0.5,-0.5,0, 0,0,-1, 0,0,1,1, 0,0)
		Local mesh:Mesh = Mesh.Create()
		mesh.AddSurface(surf)
		tri = Drawable.Create(mesh)
		
		'Load sphere mesh
		Local sphere:Mesh = Cache.GetMesh("sphere.msh.xml")
		spheres = New Drawable[81]
		Local x% = -32, z% = -32
		For Local i% = 0 Until spheres.Length()
			spheres[i] = Drawable.Create(sphere)
			spheres[i].SetPosition(x, 0, z)
			x += 8; If x > 32 Then x = -32; z += 8
		Next
		
		'Create billboards
		Local brush:Brush = Brush.Create(tex)
		billboards = New Drawable[64]
		x = -8; z = -8
		For Local i% = 0 Until billboards.Length()
			brush.SetBaseColor(Rnd(0, 1), Rnd(0, 1), Rnd(0, 1))
			billboards[i] = Drawable.Create(brush, 1, 1, Drawable.BILLBOARD_SPHERICAL)
			'billboards[i].SetScale(Rnd(0.1, 2), 1, Rnd(0.1, 2))
			'billboards[i].SetEuler(0, Rnd(0, 360), 0)
			billboards[i].SetPosition(x, 0, z)
			x += 2; If x >= 8 Then x = -8; z += 2
		Next
		
		'Prepare lights
		Lighting.SetLightEnabled(0, True)
		Lighting.SetLightEnabled(1, True)
		Lighting.SetLightEnabled(2, True)
		Lighting.SetLightType(0, Lighting.POINT)
		Lighting.SetLightType(1, Lighting.POINT)
		Lighting.SetLightType(2, Lighting.POINT)
		Lighting.SetLightAttenuation(0, 0.05)
		Lighting.SetLightAttenuation(1, 0.05)
		Lighting.SetLightAttenuation(2, 0.05)
		Lighting.SetLightColor(0, 1, 0, 0)
		Lighting.SetLightColor(1, 0, 1, 0)
		Lighting.SetLightColor(2, 0, 0, 1)
		lightsEulerY[0] = 0
		lightsEulerY[1] = 120
		lightsEulerY[2] = 240
		
		'Create swat
		swatMesh = Cache.GetMesh("swat.msh.xml")
		swat = Drawable.Create(swatMesh)
			
		Return False
	End
	
	Method OnUpdate%()
		'DebugLog "Update"
		
		'Update delta time
		deltaTime = (Millisecs() - lastMillisecs) / 1000.0
		lastMillisecs = Millisecs()
	
		'End with escape key
		#If TARGET<>"html5"
		If KeyHit(KEY_ESCAPE) Then EndApp()
		#End
		
		'Change test with space key
		If KeyHit(KEY_SPACE) Or TouchHit(0) Then SetNextTest()
		
		'Update viewer perspective and viewport
		viewer.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 0.001, 1000)
		viewer.SetViewport(0, 0, DeviceWidth(), DeviceHeight())
		
		'Update current test
		Select currentTest
		Case TEST_PRIMITIVES
			numPrimitives += 1
			If numPrimitives > primitives.Length() Then numPrimitives = primitives.Length()
			primitives[numPrimitives-1].type =Int(Rnd(0, 4))
			primitives[numPrimitives-1].x = Rnd(DeviceWidth())
			primitives[numPrimitives-1].y = Rnd(DeviceHeight())
			primitives[numPrimitives-1].z = Rnd(DeviceWidth())
			primitives[numPrimitives-1].w = Rnd(DeviceHeight())
			primitives[numPrimitives-1].r = Rnd()
			primitives[numPrimitives-1].g = Rnd()
			primitives[numPrimitives-1].b = Rnd()
		Case TEST_TRIANGLE
			viewer.SetPosition(0, 0, -4)
			viewer.SetEuler(0, 0, 0)
			tri.SetEuler(0, tri.GetEulerY() + 64 * GetDeltaTime(), 0)
		Case TEST_BILLBOARDS
			viewer.SetPosition(0, 0, 0)
			viewer.SetEuler(45, viewer.GetEulerY() + 32 * GetDeltaTime(), 0)
			viewer.Move(0, 0, -8)
		Case TEST_LIGHTS
			viewer.SetPosition(0, 32, -90)
			viewer.SetEuler(20, 0, 0)
			For Local i% = 0 Until lightsEulerY.Length()
				lightsEulerY[i] += 32 * GetDeltaTime()
				Lighting.SetLightPosition(i, 48 * Cos(lightsEulerY[i]), 0, 48 * Sin(lightsEulerY[i]))
			Next
		Case TEST_ANIMATION
			viewer.SetPosition(0, 2, -4)
			viewer.SetEuler(15, 0, 0)
			currentFrame += 16 * GetDeltaTime()
			If currentFrame > swatMesh.GetLastFrame()+1 Then currentFrame = currentFrame - Int(currentFrame)
		End

		Return False
	End
	
	Method OnRender%()
		'DebugLog "Render"
		
		'Update FPS
		fpsCounter += 1
		fpsAccum += deltaTime
		If fpsAccum >= 1
			currentFPS = fpsCounter
			fpsCounter = 0
			fpsAccum = 0
		End
	
		viewer.Prepare()
		viewer.SetClearColor(1,1,1)
		
		Select currentTest
		Case TEST_PRIMITIVES
			Painter.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
			Painter.Cls()
			For Local i% = 0 Until numPrimitives
				Local prim:Prim = primitives[i]
				Painter.SetColor(prim.r, prim.g, prim.b)
				Select prim.type
					Case PRIM_POINT
						Painter.PaintPoint(prim.x, prim.y)
					Case PRIM_LINE
						Painter.PaintLine(prim.x, prim.y, prim.z, prim.w)
					Case PRIM_RECT
						Painter.PaintRect(prim.x, prim.y, prim.z, prim.w)
					Case PRIM_ELLIPSE
						Painter.PaintEllipse(prim.x, prim.y, prim.z, prim.w)
				End
			Next
			Painter.SetColor(Rnd(), Rnd(), Rnd())
		Case TEST_IMAGE
			Painter.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
			Painter.Cls()
			tex.Draw((DeviceWidth() - tex.GetWidth())/2, (DeviceHeight() - tex.GetHeight())/2)
		Case TEST_TRIANGLE
			tri.Draw()
		Case TEST_BILLBOARDS
			For Local bb:Drawable = Eachin billboards
				bb.Draw()
			Next
		Case TEST_LIGHTS
			viewer.SetClearColor(0, 0, 0)
			Lighting.Prepare(0, 0, 0)
			For Local sphere:Drawable = Eachin spheres
				sphere.Draw()
			Next
		Case TEST_ANIMATION
			swat.Draw(True, currentFrame)
		End
		
		Painter.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Painter.SetColor(0, 0, 0)
		Painter.PaintRect(0, DeviceHeight() - 24, DeviceWidth(), 24)
		Painter.SetColor(0, 1, 0)
		Local text$ = "<Press space key or touch screen to change test>"
		font.Draw((DeviceWidth() - font.GetTextWidth(text))/2, DeviceHeight() - font.GetTextHeight(text), text)
		Painter.SetColor(1, 0, 0)
		text = GetFPS() + " FPS"
		font.Draw(0, DeviceHeight() - font.GetTextHeight(text), text)
		
		If currentTest = TEST_ANIMATION
			Painter.SetColor(0, 0, 0)
			font.Draw(4, 4, "Frame: " + currentFrame)
		End
	
		Return False
	End
	
	Method SetNextTest:Void()
		currentTest += 1
		If currentTest > TEST_LAST Then currentTest = TEST_FIRST
		
		Select currentTest
		Case TEST_PRIMITIVES
			numPrimitives = 0
		Case TEST_ANIMATION
			currentFrame = 0
		End
	End
	
	Method GetDeltaTime#()
		Return deltaTime
	End
	
	Method GetFPS%()
		Return currentFPS
	End
Private
	Field currentTest%
	Global lastMillisecs%
	Global deltaTime#
	Global currentFPS%
	Global fpsCounter%
	Global fpsAccum#
	
	Field viewer:Viewer
	Field numPrimitives%
	Field primitives:Prim[1000]
	Field tex:Texture
	Field font:Font
	Field tri:Drawable
	Field billboards:Drawable[]
	Field spheres:Drawable[]
	Field lightsEulerY#[3]
	Field swatMesh:Mesh
	Field swat:Drawable
	Field currentFrame#
End

Function Main:Int()
	New TestApp()
	Return False
End
