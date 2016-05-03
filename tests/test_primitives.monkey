Strict

Private
Import mojo.app
Import test
Import vortex

Const PRIM_POINT% = 0
Const PRIM_LINE% = 1
Const PRIM_RECT% = 2
Const PRIM_ELLIPSE% = 3

Class Prim Final
	Field type%
	Field x#, y#, z#, w#
	Field r#, g#, b#
End

Public
Class PrimitivesTest Extends Test Final
	Method New()
		'Init primitives array
		For Local i:Int = 0 Until mPrimitives.Length()
			mPrimitives[i] = New Prim
		Next
	End
	
	Method Init:Void()
		mNumPrimitives = 0
	End
	
	Method Update:Void(deltaTime:Float)
		mNumPrimitives += 1
		If mNumPrimitives > mPrimitives.Length() Then mNumPrimitives = mPrimitives.Length()
		mPrimitives[mNumPrimitives-1].type =Int(Rnd(0, 4))
		mPrimitives[mNumPrimitives-1].x = Rnd(DeviceWidth())
		mPrimitives[mNumPrimitives-1].y = Rnd(DeviceHeight())
		mPrimitives[mNumPrimitives-1].z = Rnd(DeviceWidth())
		mPrimitives[mNumPrimitives-1].w = Rnd(DeviceHeight())
		mPrimitives[mNumPrimitives-1].r = Rnd()
		mPrimitives[mNumPrimitives-1].g = Rnd()
		mPrimitives[mNumPrimitives-1].b = Rnd()
	End
	
	Method Draw:Void()
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.ClearColorBuffer()
		For Local i:Int = 0 Until mNumPrimitives
			Local prim:Prim = mPrimitives[i]
			Renderer.SetColor(prim.r, prim.g, prim.b)
			Select prim.type
				Case PRIM_POINT
					Renderer.DrawPoint(prim.x, prim.y, 0)
				Case PRIM_LINE
					Renderer.DrawLine(prim.x, prim.y, 0, prim.z, prim.w, 0)
				Case PRIM_RECT
					Renderer.DrawRect(prim.x, prim.y, 0, prim.z, prim.w)
				Case PRIM_ELLIPSE
					Renderer.DrawEllipse(prim.x, prim.y, 0, prim.z, prim.w)
			End
		Next
		Renderer.SetColor(Rnd(), Rnd(), Rnd())
	End
Private
	Field mNumPrimitives	: Int
	Field mPrimitives		: Prim[1000]
End