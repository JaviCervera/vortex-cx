Strict

Private
Import brl.filepath
Import dialog
Import font
Import guifuncs
Import mojo.app
Import mojo.input

Public
Class Gui
Public
	Method New()
		'Load resources
		mFont = Font.Load("system.fnt")
		mOpenTex = Texture.Load("folder.png", Renderer.FILTER_NONE)
		mSaveTex = Texture.Load("disk.png", Renderer.FILTER_NONE)
	
		mPanelRect = New Rect(8, 8, 48, 24)
		mOpenRect = New Rect(8 + 4, 8 + 4, 16, 16)
		mSaveRect = New Rect(8 + 24, 8 + 4, 16, 16)
		mSizeRect = New Rect(60, 8, 100, 24)
		
		mFontSizes = [8, 16, 32]
		mSelSize = 1
		mDisplayText = "The quick brown fox jumps over the lazy dog"
	End
	
	Method Update:Font(currentFont:Font)
		'Update GUI controls
		If MouseHit(MOUSE_LEFT)
			'Load font
			If mOpenRect.IsPointInside(MouseX(), MouseY())
				Local filename:String = RequestFile("Load font")
				If filename <> ""
					filename = filename.Replace("\", "/")
					Local font:Font = LoadFont(filename, mFontSizes[mSelSize])
					If font <> Null
						Return font
					Else
						Notify "Error", "Could not load font '" + filename + "'", True
					End
				End
			'Save font
			Elseif mSaveRect.IsPointInside(MouseX(), MouseY())
				Local filename:String = currentFont.Filename
				If filename = ""
					filename = RequestFile("Save font", "Font Files:fnt;All Files:*", True)
					currentFont.Filename = filename
				Else
					filename = StripExt(filename) + ".fnt"
				End
				If filename <> ""
					'Save font
					SaveFont(currentFont, filename)
					
					'Save texture
					SaveFontTexture(currentFont, StripExt(filename) + ".png")
				End
			'Size
			Elseif mSizeRect.IsPointInside(MouseX(), MouseY())
				mSelSize += 1
				If mSelSize = mFontSizes.Length Then mSelSize = 0
				
				If currentFont And ExtractExt(currentFont.Filename).ToLower() <> "xml" And ExtractExt(currentFont.Filename).ToLower() <> "fnt"
					Local font:Font = LoadFont(currentFont.Filename, mFontSizes[mSelSize])
					If font <> Null Then Return font
				End
			End
		End
		
		Return Null
	End
	
	Method Render:Void(currentFont:Font)
		Renderer.Setup2D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetBlendMode(Renderer.BLEND_ALPHA)
		Renderer.ClearColorBuffer(0.2, 0.2, 0.2)
		DrawPanel(mPanelRect)
		Renderer.SetColor(1, 1, 1)
		mOpenTex.Draw(mOpenRect.x, mOpenRect.y)
		mSaveTex.Draw(mSaveRect.x, mSaveRect.y)
		DrawPanel(mSizeRect, "Size: " + mFontSizes[mSelSize], mFont)
		
		If currentFont
			Renderer.SetColor(1, 1, 1)
			currentFont.Texture.Draw((DeviceWidth() - currentFont.Texture.Width)/2, (DeviceHeight() - currentFont.Texture.Height)/2)
			currentFont.Draw(8, 40, mDisplayText)
		End
	End
Private
	'Resources
	Field mFont					: Font
	Field mOpenTex				: Texture
	Field mSaveTex				: Texture
	
	'Widgets
	Field mPanelRect			: Rect
	Field mOpenRect				: Rect
	Field mSaveRect				: Rect
	Field mSizeRect				: Rect
	
	'Misc
	Field mFontSizes			: Int[]
	Field mSelSize				: Int
	Field mDisplayText			: String
End
