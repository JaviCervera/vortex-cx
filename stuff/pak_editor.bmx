SuperStrict

Framework brl.appstub
Import brl.eventqueue
Import brl.filesystem
Import brl.retro
Import maxgui.maxgui
Import maxgui.drivers

Const WINWIDTH% = 640
Const WINHEIGHT% = 480

Local app:TApp = New TApp
app.Init()
While app.Update()
Wend
app.Finish()

Type TApp
	Method Init()
		'Create interface
		win = CreateWindow("Pak Editor", 0, 0, WINWIDTH, WINHEIGHT, Null, WINDOW_TITLEBAR | WINDOW_CLIENTCOORDS | WINDOW_CENTER | WINDOW_HIDDEN)
		listbox = CreateListBox(4, 4, WINWIDTH - 8, WINHEIGHT - 36, win)
		addFileButton = CreateButton("Add File", 4, WINHEIGHT - 28, 100, 24, win)
		addFolderButton = CreateButton("Add Folder", 108, WINHEIGHT - 28, 100, 24, win)
		packButton = CreateButton("Pack!", WINWIDTH - 74, WINHEIGHT - 28, 70, 24, win)
		ShowGadget win
	EndMethod
	
	Method Update%()
		Select WaitEvent()
		Case EVENT_APPTERMINATE
			Return False
		Case EVENT_WINDOWCLOSE
			Return False
		Case EVENT_GADGETACTION
			Select EventSource()
			Case addFileButton
				Local file$ = RequestFile("Select File", "All Files (*.*):*")
				If file <> "" Then AddFile(file)
				UpdateListBox()
			Case addFolderButton
				Local folder$ = RequestDir("Select Folder")
				If folder <> "" Then AddFolder(folder)
				UpdateListBox()
			Case packButton
				Local file$ = RequestFile("Package Name", "Package Files (*.pak):pak", True)
				If file <> "" Then MakePackage(file)
			EndSelect
		EndSelect
		Return True
	EndMethod
	
	Method Finish()
	EndMethod
	
	Method AddFolder(folder$)
		Local subfolders$[0]
	
		'Parse folder
		Local dir% = ReadDir(folder)
		Local file$ = NextFile(dir)
		While file$ <> ""
			If file <> "." And file <> ".."
				file = folder + "/" + file
				If FileType(file) = FILETYPE_FILE
					AddFile(file)
				Else
					subfolders = subfolders[.. subfolders.length+1]
					subfolders[subfolders.length-1] = file
				EndIf
			EndIf
			file = NextFile(dir)
		Wend
		CloseDir dir
		
		'Parse subfolders
		For Local subdir$ = EachIn subfolders
			AddFolder(subdir)
		Next
	EndMethod
	
	Method AddFile(file$)
		files = files[.. files.length+1]
		files[files.length-1] = file
	EndMethod
	
	Method UpdateListBox()
		ClearGadgetItems(listbox)
		For Local f$ = EachIn files
			AddGadgetItem listbox, f
		Next
	EndMethod
	
	Method MakePackage(pakname$)
		Local offset% = 12
		
		'Create file
		If FileType(pakname) <> FILETYPE_NONE Then DeleteFile pakname
		Local fhandle:TStream = WriteFile(pakname)
		
		'Write header
		WriteByte fhandle, Asc("P")
		WriteByte fhandle, Asc("A")
		WriteByte fhandle, Asc("C")
		WriteByte fhandle, Asc("K")
		WriteInt fhandle, offset
		WriteInt fhandle, files.length * 64
		
		'Write file table
		offset :+ files.length * 64
		For Local file$ = EachIn files
			Local stripName$ = StripDir(file)
			Local fsize% = FileSize(file)
			
			'Write filename (55 chars max + zero)
			Local writtenBytes% = 0
			For Local i% = 1 To Len(stripName)
				WriteByte fhandle, Asc(Mid(stripName,i, 1))
				writtenBytes :+ 1
				If writtenBytes = 55 Then Exit
			Next
			For Local i% = writtenBytes+1 To 56
				WriteByte fhandle, 0 'Pad with zeros
			Next
			
			'Write offset
			WriteInt fhandle, offset
			
			'Write size
			WriteInt fhandle, fsize
			
			offset :+ fsize
		Next
		
		'Write files
		For Local file$ = EachIn files
			Local fhandle2:TStream = ReadFile(file)
			CopyStream fhandle2, fhandle
			CloseStream fhandle2
		Next
		
		'Close file
		CloseStream fhandle
		
		Notify "Done"
	EndMethod

	'UI
	Field win:TGadget
	Field listbox:TGadget
	Field addFileButton:TGadget
	Field addFolderButton:TGadget
	Field packButton:TGadget
	
	'Logic
	Field files$[0]
EndType