Strict

#GLFW_WINDOW_TITLE="Vortex Tests"
#GLFW_WINDOW_WIDTH=800
#GLFW_WINDOW_HEIGHT=600
#GLFW_WINDOW_RESIZABLE=True
#OPENGL_DEPTH_BUFFER_ENABLED=True

'We want a left handed coordinate system
'Import vortex.handedness
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
Const TEST_LEVEL% = 6
Const TEST_FIRST% = 0
Const TEST_LAST% = 6

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
		Vortex_Init()
		Print "API version: " + Vortex_GetAPIVersion()
		Print "Shading version: " + Vortex_GetShadingVersion()
		Print "Shader compilation: " + Vortex_GetShaderError()
		
		'Init primitive array
		For Local i% = 0 Until primitives.Length()
			primitives[i] = New Prim
		Next
		
		'Load texture
		tex = Texture_Cache("smile.png")
		
		'Load font
		font = Font_Cache("system_16.fnt.xml")
		
		'Create viewer
		viewer = Viewer_Create(0, 0, DeviceWidth(), DeviceHeight())
		
		'Make triangle
		Local mesh:Object = Mesh_Create()
		Local surf:Object = Mesh_AddSurface(mesh)
		Brush_SetCulling(Surface_GetBrush(surf), False)
		Surface_AddTriangle(surf, 0, 1, 2)
		Surface_AddVertex(surf, 0,0.5,0,     0,0,-1, 1,0,0,1, 0,0)
		Surface_AddVertex(surf, 0.5,-0.5,0,  0,0,-1, 0,1,0,1, 0,0)
		Surface_AddVertex(surf, -0.5,-0.5,0, 0,0,-1, 0,0,1,1, 0,0)
		Surface_Rebuild(surf)
		tri = Drawable_CreateWithMesh(mesh)
		
		'Load sphere mesh
		Local sphere:Object = Mesh_Cache("sphere.msh.xml")
		spheres = New Object[81]
		Local x% = -32, z% = -32
		For Local i% = 0 Until spheres.Length()
			spheres[i] = Drawable_CreateWithMesh(sphere)
			Drawable_SetPosition(spheres[i], x, 0, z)
			x += 8; If x > 32 Then x = -32; z += 8
		Next
		
		'Create billboards
		billboards = New Object[64]
		x = -8; z = -8
		For Local i% = 0 Until billboards.Length()
			billboards[i] = Drawable_CreateBillboard(tex, 1, 1, BILLBOARD_SPHERICAL)
			Brush_SetBaseColor(Surface_GetBrush(Drawable_GetSurface(billboards[i])), Rnd(0, 1), Rnd(0, 1), Rnd(0, 1))
			Drawable_SetPosition(billboards[i], x, 0, z)
			x += 2; If x >= 8 Then x = -8; z += 2
		Next
		
		'Prepare lights
		Lighting_SetLightEnabled(0, True)
		Lighting_SetLightEnabled(1, True)
		Lighting_SetLightEnabled(2, True)
		Lighting_SetLightType(0, LIGHT_POINT)
		Lighting_SetLightType(1, LIGHT_POINT)
		Lighting_SetLightType(2, LIGHT_POINT)
		Lighting_SetLightAttenuation(0, 0.05)
		Lighting_SetLightAttenuation(1, 0.05)
		Lighting_SetLightAttenuation(2, 0.05)
		Lighting_SetLightColor(0, 1, 0, 0)
		Lighting_SetLightColor(1, 0, 1, 0)
		Lighting_SetLightColor(2, 0, 0, 1)
		lightsEulerY[0] = 0
		lightsEulerY[1] = 120
		lightsEulerY[2] = 240
		
		'Load swat
		swatMesh = Mesh_Cache("swat.msh.xml")
		swat = Drawable_CreateWithMesh(swatMesh)
		
		'Load level
		Local levelMesh:Object = Mesh_Cache("simple-dm5.msh.xml")
		level = Drawable_CreateWithMesh(levelMesh)
			
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
		
		'Change test with space key
		If KeyHit(KEY_SPACE) Or TouchHit(0) Then SetNextTest()
		
		'Update viewer perspective and viewport
		Viewer_SetPerspective(viewer, 45, Float(DeviceWidth()) / DeviceHeight(), 0.1, 10000)
		Viewer_SetViewport(viewer, 0, 0, DeviceWidth(), DeviceHeight())
		
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
			Viewer_SetPosition(viewer, 0, 0, -4)
			Viewer_SetEuler(viewer, 0, 0, 0)
			Drawable_SetEuler(tri, 0, Drawable_GetEulerY(tri) + 64 * GetDeltaTime(), 0)
		Case TEST_BILLBOARDS
			Viewer_SetPosition(viewer, 0, 0, 0)
			Viewer_SetEuler(viewer, 45, Viewer_GetEulerY(viewer) + 32 * GetDeltaTime(), 0)
			Viewer_Move(viewer, 0, 0, -8)
		Case TEST_LIGHTS
			Viewer_SetPosition(viewer, 0, 32, -90)
			Viewer_SetEuler(viewer, 20, 0, 0)
			For Local i% = 0 Until lightsEulerY.Length()
				lightsEulerY[i] += 32 * GetDeltaTime()
				Lighting_SetLightPosition(i, 48 * Cos(lightsEulerY[i]), 0, 48 * Sin(lightsEulerY[i]))
			Next
		Case TEST_ANIMATION
			Viewer_SetPosition(viewer, 0, 2, -4)
			Viewer_SetEuler(viewer, 15, 0, 0)
			currentFrame += 16 * GetDeltaTime()
			If currentFrame > Mesh_GetLastFrame(swatMesh)+1 Then currentFrame = currentFrame - Int(currentFrame)
		Case TEST_LEVEL
			Viewer_SetPosition(viewer, 0, 100, 0)
			Viewer_SetEuler(viewer, 0, Viewer_GetEulerY(viewer) + 32 * GetDeltaTime(), 0)
		End

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
	
		'Prepare viewer
		If currentTest = TEST_LIGHTS Or currentTest = TEST_LEVEL
			Viewer_SetClearColor(viewer, 0,0,0)
		Else
			Viewer_SetClearColor(viewer, 1,1,1)
		End
		Viewer_Prepare(viewer)
		
		'Render depending on current test
		Select currentTest
		Case TEST_PRIMITIVES
			Painter_Setup2D(0, 0, DeviceWidth(), DeviceHeight())
			Painter_Cls()
			For Local i% = 0 Until numPrimitives
				Local prim:Prim = primitives[i]
				Painter_SetColor(prim.r, prim.g, prim.b)
				Select prim.type
					Case PRIM_POINT
						Painter_PaintPoint(prim.x, prim.y)
					Case PRIM_LINE
						Painter_PaintLine(prim.x, prim.y, prim.z, prim.w)
					Case PRIM_RECT
						Painter_PaintRect(prim.x, prim.y, prim.z, prim.w)
					Case PRIM_ELLIPSE
						Painter_PaintEllipse(prim.x, prim.y, prim.z, prim.w)
				End
			Next
			Painter_SetColor(Rnd(), Rnd(), Rnd())
		Case TEST_IMAGE
			Painter_Setup2D(0, 0, DeviceWidth(), DeviceHeight())
			Painter_Cls()
			Texture_Draw(tex, (DeviceWidth() - Texture_GetWidth(tex))/2, (DeviceHeight() - Texture_GetHeight(tex))/2)
		Case TEST_TRIANGLE
			Drawable_Draw(tri)
		Case TEST_BILLBOARDS
			For Local bb:Object = Eachin billboards
				Drawable_Draw(bb)
			Next
		Case TEST_LIGHTS
			Lighting_Prepare(0, 0, 0)
			For Local sphere:Object = Eachin spheres
				Drawable_Draw(sphere)
			Next
		Case TEST_ANIMATION
			Drawable_Draw(swat, True, currentFrame)
		Case TEST_LEVEL
			Drawable_Draw(level)
		End
		
		'Setup painter for 2D graphics
		Painter_Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		
		'Paint black margin on top of screen
		Painter_SetColor(0, 0, 0)
		Painter_PaintRect(0, DeviceHeight() - 24, DeviceWidth(), 24)
		
		'Draw FPS
		Painter_SetColor(1, 0, 0)
		Local text$ = GetFPS() + " FPS"
		Font_Draw(font, 2, DeviceHeight() - Font_GetTextHeight(font, text) - (24 - Font_GetTextHeight(font, text))/2, text)
		
		'Draw info
		Painter_SetColor(1, 1, 0)
		text = "<Press space key or touch screen to change test>"
		Font_Draw(font, (DeviceWidth() - Font_GetTextWidth(font, text))/2, DeviceHeight() - Font_GetTextHeight(font, text) - (24 - Font_GetTextHeight(font, text))/2, text)
		
		If currentTest = TEST_ANIMATION
			Painter_SetColor(0, 0, 0)
			Font_Draw(font, 4, 4, "Frame: " + Int(currentFrame))
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
	
	Field viewer:Object
	Field numPrimitives%
	Field primitives:Prim[1000]
	Field tex:Object
	Field font:Object
	Field tri:Object
	Field billboards:Object[]
	Field spheres:Object[]
	Field lightsEulerY#[3]
	Field swatMesh:Object
	Field swat:Object
	Field currentFrame#
	Field level:Object
End

Function Main:Int()
	New TestApp()
	Return False
End
