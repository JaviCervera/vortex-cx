Strict

Import vortex

Class Rect
	Field x:Float
	Field y:Float
	Field width:Float
	Field height:Float
	Method New(x:Float, y:Float, w:Float, h:Float)
		Self.x = x
		Self.y = y
		Self.width = w
		Self.height = h
	End
	
	Method IsPointInside:Bool(x:Float, y:Float)
		If InRange(x, Self.x, Self.x+width) And InRange(y, Self.y, Self.y+height) Then Return True Else Return False
	End
	
	Method InRange:Bool(val:Float, min:Float, max:Float)
		If val >= min And val <= max Then Return True Else Return False
	End
	
	Method Set:Void(other:Rect)
		x = other.x
		y = other.y
		width = other.width
		height = other.height
	End
End

Function DrawRectOutline:Void(r:Rect)
	DrawRectOutline(r.x, r.y, r.width, r.height)
End

Function DrawRectOutline:Void(x:Float, y:Float, width:Float, height:Float)
	Renderer.SetColor(0.2, 0.2, 0.2)
	Renderer.DrawLine(x, y, x+width, y)
	Renderer.DrawLine(x, y+height, x+width, y+height)
	Renderer.DrawLine(x, y, x, y+height)
	Renderer.DrawLine(x+width, y, x+width, y+height)
End

Function DrawPanel:Void(r:Rect, text:String = "", font:Font = Null, red:Float = 0.8, green:Float = 0.8, blue:Float = 0.8)
	DrawPanel(r.x, r.y, r.width, r.height, text, font, red, green, blue)
End

Function DrawPanel:Void(x:Float, y:Float, width:Float, height:Float, text:String = "", font:Font = Null, red:Float = 0.8, green:Float = 0.8, blue:Float = 0.8)
	Renderer.SetColor(red, green, blue)
	Renderer.DrawRect(x, y, width, height)
	DrawRectOutline(x, y, width, height)
	If text <> "" And font <> Null
		Renderer.SetColor(red * 0.3, green * 0.3, blue * 0.3)
		font.Draw(x + width/2 - font.TextWidth(text)/2, y + height/2 - font.TextHeight(text)/2, text)
	End
End

Function DrawCheckbox:Void(r:Rect, text:String, font:Font, checked:Bool)
	DrawCheckbox(r.x, r.y, r.width, r.height, text, font, checked)
End

Function DrawCheckbox:Void(x:Float, y:Float, width:Float, height:Float, text:String, font:Font, checked:Bool)
	DrawPanel(x, y, width, height)
	DrawRectOutline(x + 4, y + 4, 16, 16)
	If checked
		Renderer.DrawLine(x + 4, y + 4, x + 20, y + 20)
		Renderer.DrawLine(x + 4, y + 20, x + 20, y + 4)
	End
	Renderer.SetColor(0.25, 0.25, 0.25)
	font.Draw(x + 24, y + height/2 - font.TextHeight(text)/2, text)
End