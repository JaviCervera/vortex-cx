Strict

Private
Import brl.databuffer
Import vortex.src.renderer

Public
Class Texture Final
Public
	Function Create:Texture(width:Int, height:Int, isDepth:Bool = False)
		Local tex:Texture = New Texture
		tex.mHandle = Renderer.CreateTexture(width, height, isDepth)
		tex.mWidth = width
		tex.mHeight = height
		tex.mIsDepth = isDepth
		tex.mIsCubic = False
		Return tex
	End

	Function Create:Texture(buffer:DataBuffer, width:Int, height:Int, filter:Int = Renderer.FILTER_NONE)
		Local tex:Texture = New Texture
		tex.mHandle = Renderer.CreateTexture(buffer, width, height, filter)
		tex.mWidth = width
		tex.mHeight = height
		tex.mIsDepth = False
		tex.mIsCubic = False
		Return tex
	End
	
	Function Load:Texture(filename:String, filter:Int = Renderer.FILTER_TRILINEAR)
		filename = filename.Replace("\", "/")
		Local handle:Int = Renderer.LoadTexture(filename, mSizeArr, filter)
		If mSizeArr[0] > 0
			Local tex:Texture = New Texture
			tex.mFilename = filename
			tex.mHandle = handle
			tex.mWidth = mSizeArr[0]
			tex.mHeight = mSizeArr[1]
			tex.mIsDepth = False
			tex.mIsCubic = False
			Return tex
		Else
			Return Null
		End
	End
	
	Function Load:Texture(left:String, right:String, front:String, back:String, top:String, bottom:String, filter:Int = Renderer.FILTER_TRILINEAR)
		left = left.Replace("\", "/")
		right = right.Replace("\", "/")
		front = front.Replace("\", "/")
		back = back.Replace("\", "/")
		top = top.Replace("\", "/")
		bottom = bottom.Replace("\", "/")
		Local handle:Int = Renderer.LoadCubicTexture(left, right, front, back, top, bottom, mSizeArr, filter)
		If mSizeArr[0] > 0
			Local tex:Texture = New Texture
			tex.mFilename = left + "," + right + "," + front + "," + back + "," + top + "," + bottom
			tex.mHandle = handle
			tex.mWidth = mSizeArr[0]
			tex.mHeight = mSizeArr[1]
			tex.mIsDepth = False
			tex.mIsCubic = True
			Return tex
		Else
			Return Null
		End
	End

	Method Free:Void()
		If mHandle <> 0 Then Renderer.FreeTexture(mHandle)
		mHandle = 0
	End

	Method Filename:String() Property
		Return mFilename
	End
	
	Method Filename:Void(filename:String) Property
		mFilename = filename
	End

	Method Handle:Int() Property
		Return mHandle
	End

	Method Width:Int() Property
		Return mWidth
	End

	Method Height:Int() Property
		Return mHeight
	End
	
	Method Depth:Bool() Property
		Return mIsDepth
	End
	
	Method Cubic:Bool() Property
		Return mIsCubic
	End

	Method Draw:Void(x:Float, y:Float, width:Float = 0, height:Float = 0, rectx:Float = 0, recty:Float = 0, rectwidth:Float = 0, rectheight:Float = 0)
		If rectwidth = 0 Then rectwidth = Width
		If rectheight = 0 Then rectheight = Height
		If width = 0 Then width = rectwidth
		If height = 0 Then height = rectheight

		'Calculate texcoords in 0..1 range, independently from frame
		Local u0:Float = rectx / Width * Sgn(width)
		Local v0:Float = recty / Height * Sgn(height)
		Local u1:Float = (rectx + rectwidth) / Width * Sgn(width)
		Local v1:Float = (recty + rectheight) / Height * Sgn(height)

		'Render
		Renderer.SetTextures(mHandle, 0, 0, 0, 0, False)
		Renderer.DrawRectEx(x, y, Abs(width), Abs(height), u0, v0, u1, v1)
		Renderer.SetTextures(0, 0, 0, 0, 0, False)
	End
Private
	Method New()
	End

	Field mFilename	: String
	Field mHandle	: Int
	Field mWidth	: Int
	Field mHeight	: Int
	Field mIsDepth	: Bool
	Field mIsCubic	: Bool
	Global mSizeArr	: Int[2]
End
