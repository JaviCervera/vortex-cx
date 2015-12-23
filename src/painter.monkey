Strict

Private
Import vortex.src.math3d
Import vortex.src.renderer

Public
Class Painter Final
Public
	Function Setup2D:Void(x:Int, y:Int, width:Int, height:Int)
		Renderer.Setup2D(x, y, width, height)
	End

	Function Setup3D:Void(x:Int, y:Int, width:Int, height:Int)
		Renderer.Setup3D(x, y, width, height)
	End

	Function SetProjectionMatrix:Void(m:Float[])
		mMatrix.Set(m)
		Renderer.SetProjectionMatrix(mMatrix)
	End

	Function GetProjectionMatrix:Void(m:Float[])
		For Local i:Int = 0 Until 16
			m[i] = Renderer.GetProjectionMatrix().m[i]
		Next
	End

	Function SetViewMatrix:Void(m:Float[])
		mMatrix.Set(m)
		Renderer.SetViewMatrix(mMatrix)
	End

	Function GetViewMatrix:Void(m:Float[])
		For Local i:Int = 0 Until 16
			m[i] = Renderer.GetViewMatrix().m[i]
		Next
	End

	Function SetModelMatrix:Void(m:Float[])
		mMatrix.Set(m)
		Renderer.SetModelMatrix(mMatrix)
	End

	Function GetModelMatrix:Void(m:Float[])
		For Local i:Int = 0 Until 16
			m[i] = Renderer.GetModelMatrix().m[i]
		Next
	End

	Function SetBlendMode:Void(mode:Int)
		Renderer.SetBlendMode(mode)
	End

	Function SetColor:Void(r:Float, g:Float, b:Float, opacity:Float = 1)
		Renderer.SetBaseColor(r, g, b, opacity)
	End

	Function Cls:Void(r:Float = 0, g:Float = 0, b:Float = 0)
		Renderer.ClearColorBuffer(r, g, b)
	End

	Function PaintPoint:Void(x:Float, y:Float)
		Renderer.DrawPoint(x, y, 0)
	End

	Function PaintLine:Void(x1:Float, y1:Float, x2:Float, y2:Float)
		Renderer.DrawLine(x1, y1, 0, x2, y2, 0)
	End

	Function PaintRect:Void(x:Float, y:Float, width:Float, height:Float)
		Renderer.DrawRect(x, y, 0, width, height)
	End

	Function PaintEllipse:Void(x:Float, y:Float, width:Float, height:Float)
		Renderer.DrawEllipse(x, y, 0, width, height)
	End
Private
	Method New()
	End

	Global mMatrix	: Mat4 = Mat4.Create()
End
