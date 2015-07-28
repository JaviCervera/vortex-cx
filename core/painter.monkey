Strict

Private
Import vortex.core.math3d
Import vortex.core.renderer

Public
Class Painter Final
Public
	Function Setup2D:Void(x%, y%, width%, height%)
		Renderer.Setup2D(x, y, width, height)
	End
	
	Function Setup3D:Void(x%, y%, width%, height%)
		Renderer.Setup3D(x, y, width, height)
	End
	
	Function SetProjectionMatrix:Void(m#[])
		mMatrix.Set(m)
		Renderer.SetProjectionMatrix(mMatrix)
	End
	
	Function GetProjectionMatrix:Void(m#[])
		For Local i% = 0 Until 16
			m[i] = Renderer.GetProjectionMatrix().m[i]
		Next
	End
	
	Function SetViewMatrix:Void(m#[])
		mMatrix.Set(m)
		Renderer.SetViewMatrix(mMatrix)
	End
	
	Function GetViewMatrix:Void(m#[])
		For Local i% = 0 Until 16
			m[i] = Renderer.GetViewMatrix().m[i]
		Next
	End
	
	Function SetModelMatrix:Void(m#[])
		mMatrix.Set(m)
		Renderer.SetModelMatrix(mMatrix)
	End
	
	Function GetModelMatrix:Void(m#[])
		For Local i% = 0 Until 16
			m[i] = Renderer.GetModelMatrix().m[i]
		Next
	End
	
	Function SetBlendMode:Void(mode%)
		Renderer.SetBlendMode(mode)
	End
	
	Function SetColor:Void(r#, g#, b#, opacity# = 1)
		Renderer.SetBaseColor(r, g, b, opacity)
	End
	
	Function Cls:Void(r# = 0, g# = 0, b# = 0)
		Renderer.ClearColorBuffer(r, g, b)
	End
	
	Function PaintPoint:Void(x#, y#)
		Renderer.DrawPoint(x, y, 0)
	End
	
	Function PaintLine:Void(x1#, y1#, x2#, y2#)
		Renderer.DrawLine(x1, y1, 0, x2, y2, 0)
	End
	
	Function PaintRect:Void(x#, y#, width#, height#)
		Renderer.DrawRect(x, y, 0, width, height)
	End
	
	Function PaintEllipse:Void(x#, y#, width#, height#)
		Renderer.DrawEllipse(x, y, 0, width, height)
	End
Private
	Method New()
	End
	
	Global mMatrix	: Mat4 = Mat4.Create()
End