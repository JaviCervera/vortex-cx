Strict

Private

Class XMLTokenizer
Public
	Method New(buffer$, line%)
		mBuffer = buffer
		mLine = line
		mOffset = 0
		mTokens = New XMLToken[0]
		mError = ""
	End
	
	Method Tokenize:Bool()
		'Parse all tokens
		Local dataAllowed:Bool = False
		While True
			Local token:XMLToken = ParseToken(dataAllowed)
			If Not token Then Exit
			mTokens = mTokens.Resize(mTokens.Length()+1)
			mTokens[mTokens.Length()-1] = token
			
			'We allow for data tokens after the ">" symbol (which indicates the beginning or end of a node,
			'although only the first one is really valid)
			If token.mType = XMLToken.XML_GREATERTHAN
				dataAllowed = True
			Else
				dataAllowed = False
			End
		End
	
		'Check if error
		If mError = ""
			Return True
		Else
			Return False
		End
	End
	
	Method GetTokens:XMLToken[]()
		Return mTokens
	End
	
	Method GetError$()
		Return mError
	End
Private
	Method ParseToken:XMLToken(dataAllowed:Bool)
		'If data is allowed, parse it if it is not a node
		Local s$ = ""
		Local startOffset% = 0
		If dataAllowed
			startOffset = mOffset
			While mOffset < mBuffer.Length() And mBuffer[mOffset] <> 60 '<
				Local c% = mBuffer[mOffset]
				s += String.FromChar(c)
				If c = 10 Then mLine += 1
				mOffset += 1
			Wend
			
			'If something has been parsed, return it
			If s.Replace("~n", "").Trim().Length() > 0
				Return New XMLToken(XMLToken.XML_DATA, s, mLine, startOffset)
			EndIf
		EndIf
	
		'Skip white spaces
		While mOffset < mBuffer.Length() And (mBuffer[mOffset] = 32 Or mBuffer[mOffset] = 9 Or mBuffer[mOffset] = 10)
			If mBuffer[mOffset] = 10 Then mLine += 1
			mOffset += 1
		Wend
	
		'Check end of file
		If mOffset >= mBuffer.Length() Then Return Null
	
		'Check symbol
		Select mBuffer[mOffset]
		Case 60 '<
			mOffset += 1
			Return New XMLToken(XMLToken.XML_LESSTHAN, "<", mLine, mOffset-1)
		Case 62 '>
			mOffset += 1
			Return New XMLToken(XMLToken.XML_GREATERTHAN, ">", mLine, mOffset-1)
		Case 47 '/
			mOffset += 1
			Return New XMLToken(XMLToken.XML_SLASH, "/", mLine, mOffset-1)
		Case 61 '=
			mOffset += 1
			Return New XMLToken(XMLToken.XML_EQUALITY, "=", mLine, mOffset-1)
		End
	
		'Check identifier
		If IsValidIdBegin(mBuffer[mOffset])
			s = ""
			startOffset = mOffset
			While mOffset <= mBuffer.Length() And IsValidIdChar(mBuffer[mOffset])
				s += String.FromChar(mBuffer[mOffset])
				mOffset += 1
			Wend
		Return New XMLToken(XMLToken.XML_IDENTIFIER, s, mLine, startOffset)
		EndIf
	
		'Check string
		If mBuffer[mOffset] = 34 '"
			s = ""
			startOffset = mOffset
			mOffset += 1	'Skip "
			While mOffset <= mBuffer.Length() And mBuffer[mOffset] <> 34 Or mBuffer[mOffset] = 10
				s += String.FromChar(mBuffer[mOffset])
				mOffset += 1
			Wend
			If mOffset >= mBuffer.Length() Or mBuffer[mOffset] <> 34
				mError = "String in XML file must be closed at line " + mLine
				Return Null
			End
			mOffset += 1	'Skip "
			Return New XMLToken(XMLToken.XML_STRING, s, mLine, startOffset)
		EndIf
	
		'Unrecognized
		mError = "Unrecognized token '" + String.FromChar(mBuffer[mOffset]) + "' at line " + mLine
		Return Null
	End
	
	Method IsValidIdBegin:Bool(c%)
		If c = 95 Or (c >= 65 And c <= 90) Or (c >= 97 And c <= 122)
			Return True
		Else
			Return False
		End
	End
	
	Method IsValidIdChar:Bool(c%)
		If IsValidIdBegin(c) Or (c >= 48 And c <= 57) Or c = 45 Or c = 46 Or c = 58
			Return True
		Else
			Return False
		End
	End
	
	Field mBuffer$
	Field mLine%
	Field mOffset%
	Field mTokens:XMLToken[]
	Field mError$

	Method New()
	End
End

Class XMLToken
	Method New(type%, data$, line%, offset%)
		mType = type
		mData = data
		mLine = line
		mOffset = offset
	End

	Const XML_LESSTHAN% = 1
	Const XML_GREATERTHAN% = 2
	Const XML_SLASH% = 3
	Const XML_EQUALITY% = 4
	Const XML_IDENTIFIER% = 5
	Const XML_STRING% = 6
	Const XML_DATA% = 7

	Field mType%
	Field mData$
	Field mLine%
	Field mOffset%
Private
	Method New()
	End
End

Class XMLAttribute
Public
	Method New(name$, value$)
		mName = name
		mValue = value
	End
	
	Field mName$
	Field mValue$
Private
	Method New()
	End
End

Public

Class XMLParser
Public
	Method New(buffer$)
		mBuffer = buffer.Replace("~r~n", "~n").Replace("~r", "~n")
		mOffset = 0
		mError = ""
	End
	
	Method Parse:Bool()
		'Remove first line if header
		Local firstLine% = 0
		If mBuffer[.. 6].ToLower() = "<?xml "
			mBuffer = mBuffer[mBuffer.Find("~n")+1 ..]
			firstLine = 1
		Endif
	
		'Tokenize buffer
		Local tokenizer:XMLTokenizer = New XMLTokenizer(mBuffer, firstLine)
		If Not tokenizer.Tokenize()
			mError = tokenizer.GetError()
			Return False
		End
		mTokens = tokenizer.GetTokens()
		tokenizer = Null
	
		'Get root node
		mRootNode = ParseNode()
		If Not mRootNode Then Return False
	
		'Check if there is garbage after the root node (sets error but returns correctly)
		If mOffset < mTokens.Length()-1 Then mError = "Expected end of file at line " + mTokens[mOffset].mLine
	
		mBuffer = ""
		mTokens = New XMLToken[0]
		mOffset = 0
		Return True
	End
	
	Method GetRootNode:XMLNode()
		Return mRootNode
	End
	
	Method GetError$()
		Return mError
	End
Private
	Method ParseNode:XMLNode()
		'Check that node begins with "<"
		Local token:XMLToken = NextToken()
		If token.mType <> XMLToken.XML_LESSTHAN
			mError = "Expected node at line " + token.mLine
			Return Null
		End
	
		'Name
		token = NextToken()
		If token.mType <> XMLToken.XML_IDENTIFIER
			mError = "Expected node name at line " + token.mLine + ", found '" + token.mData + "'"
			Return Null
		End
		Local name$ = token.mData
	
		'Optional attributes
		Local attributes:XMLAttribute[0]
		token = PeekToken(0)
		While token.mType = XMLToken.XML_IDENTIFIER
			'Attribute name
			token = NextToken()
			Local attrName$ = token.mData
	
			'Check "="
			token = NextToken()
			If token.mType <> XMLToken.XML_EQUALITY
				mError = "Expected '=' at line " + token.mLine + ", found '" + token.mData + "'"
				Return Null
			End
	
			'Atttribute value
			token = NextToken()
			If token.mType <> XMLToken.XML_STRING
				mError = "Expected string at line " + token.mLine + ", found '" + token.mData + "'"
				Return Null
			End
			Local attrValue$ = token.mData
	
			'Add attribute
			attributes = attributes.Resize(attributes.Length()+1)
			attributes[attributes.Length()-1] = New XMLAttribute(attrName, attrValue)
	
			'Prepare for next iteration
			token = PeekToken(0)
		Wend
	
		'Node end (opened or closed)
		token = NextToken()
	
		'Closed node
		Select token.mType
		Case XMLToken.XML_SLASH
			token = NextToken()
			If token.mType <> XMLToken.XML_GREATERTHAN
				mError = "Expected node end at line " + token.mLine + ", found '" + token.mData + "'"
				Return Null
			EndIf
			Return New XMLNode(name, "", attributes, New XMLNode[0])
		'Opened node
		Case XMLToken.XML_GREATERTHAN
			'Get first token for the value
			Local firstToken:XMLToken = PeekToken(0)
	
			'Parse children
			Local children:XMLNode[] = ParseChildren(name)
			If mError <> "" Then Return Null
	
			'Get last token for the value
			Local lastToken:XMLToken = PeekToken(-4)	'Move before <, /, name, >
	
			'Parse value
			Local value$ = mBuffer[firstToken.mOffset .. lastToken.mOffset]
			If mError <> "" Then Return Null
	
			Return New XMLNode(name, value, attributes, children)
		'Error
		Default
			mError = "Expected node end at line " + token.mLine + ", found '" + token.mData + "'"
			Return Null
		End
	End
	
	Method ParseChildren:XMLNode[](name$)
		Local token1:XMLToken = PeekToken(0)
		'Skip if it's a data token
		If token1.mType = XMLToken.XML_DATA
			NextToken()
			token1 = PeekToken(0)
		End
		Local token2:XMLToken = PeekToken(1)
		
		Local children:XMLNode[0]
		While token1.mType = XMLToken.XML_LESSTHAN And token2.mType <> XMLToken.XML_SLASH
			'Parse node
			Local node:XMLNode = ParseNode()
			If node = Null Then Return New XMLNode[0]
	
			'Add to children list
			children = children.Resize(children.Length() + 1)
			children[children.Length() - 1] = node
	
			'Prepare for next iteration (skip if it's a data token)
			token1 = PeekToken(0)
			If token1.mType = XMLToken.XML_DATA
				NextToken()
				token1 = PeekToken(0)
			End
			token2 = PeekToken(1)
		Wend
	
		'Check that next 2 tokens begin closing a node
		If token1.mType <> XMLToken.XML_LESSTHAN Or token2.mType <> XMLToken.XML_SLASH
			mError = "Expected node end at line " + token1.mLine + ", found '" + token1.mData + "'"
			Return New XMLNode[0]
		EndIf
		mOffset += 2	'Skip < and /
	
		'Check that next token is an identifier
		Local token:XMLToken = NextToken()
		If token.mType <> XMLToken.XML_IDENTIFIER
			mError = "Expected identifier at line " + token.mLine + ", found '" + token.mData + "'"
			Return New XMLNode[0]
		EndIf
	
		'Check that node name is correct
		If token.mData <> name
			mError = "Expected node name '" + name + "' at line " + token1.mLine + ", found '" + token.mData + "'"
			Return New XMLNode[0]
		EndIf
	
		'Check that last token is ">"
		token = NextToken()
		If token.mType <> XMLToken.XML_GREATERTHAN
			mError = "Expected '>' at line " + token1.mLine + ", found '" + token.mData + "'"
			Return New XMLNode[0]
		EndIf
	
		Return children
	End
	
	Method PeekToken:XMLToken(offset%)
		Return mTokens[mOffset+offset]
	End
	
	Method NextToken:XMLToken()
		mOffset += 1
		Return mTokens[mOffset-1]
	End

	Field mBuffer$
	Field mTokens:XMLToken[]
	Field mOffset%
	Field mRootNode:XMLNode
	Field mError$
	
	Method New()
	End
End

Class XMLNode
Public
	Method New(name$, value$, attributes:XMLAttribute[], children:XMLNode[])
		mName = name
		mValue = value
		mAttributes = attributes
		mChildren = children
	End
	
	Method GetName$()
		Return mName
	End
	
	Method GetValue$()
		Return mValue
	End
	
	Method HasAttribute:Bool(name$)
		For Local attr:XMLAttribute = Eachin mAttributes
			If attr.mName = name Then Return True
		Next
		Return False
	End
	
	Method GetNumAttributes%()
		Return mAttributes.Length()
	End
	
	Method GetAttributeName$(index%)
		Return mAttributes[index].mName
	End
	
	Method GetAttribute$(index%)
		Return mAttributes[index].mValue
	End
	
	Method GetAttribute$(name$, defVal$ = "")
		For Local attr:XMLAttribute = Eachin mAttributes
			If attr.mName = name Then Return attr.mValue
		Next
		Return defVal
	End
	
	Method GetNumChildren%()
		Return mChildren.Length()
	End
	
	Method GetChild:XMLNode(index%)
		Return mChildren[index]
	End
	
	Method GetChild:XMLNode(name$)
		For Local node:XMLNode = Eachin mChildren
			If node.GetName() = name Then Return node
		Next
		Return Null
	End
	
	Method GetChildren:XMLNode[](name$)
		Local children:XMLNode[0]
		For Local child:XMLNode = Eachin mChildren
			If child.GetName() = name
				children = children.Resize(children.Length()+1)
				children[children.Length()-1] = child
			End
		Next
		Return children
	End
	
	Method GetChildValue$(name$, defValue$)
		Local child:XMLNode = GetChild(name)
		If child
			Return child.GetValue()
		Else
			Return defValue
		End
	End
Private
	Field mName$
	Field mValue$
	Field mAttributes:XMLAttribute[]
	Field mChildren:XMLNode[]
	
	Method New()
	End
End
