#OPENGL_DEPTH_BUFFER_ENABLED=True

Strict

Private

Import brl.databuffer
Import mojo.app
Import mojo.graphics
Import opengl.gles20
Import vortex.src.math3d
Import vortex.src.renderer_gles20_shaders

'#If TARGET="html5"
Const GLSL_VERSION$ = ""
'#Else
'Const GLSL_VERSION$ = "#version 120~n"
'#EndIf

Public

Class Renderer Final
Public
	Const BASETEX_UNIT% = 0
	Const BLEND_ALPHA% = 0
	Const BLEND_ADD% = 1
	Const BLEND_MUL% = 2
	Const ELLIPSEPOINTS% = 64
	Const FILTER_NONE% = 0
	Const FILTER_LINEAR% = 1
	Const FILTER_BILINEAR% = 2
	Const FILTER_TRILINEAR% = 3
	Const MAX_LIGHTS% = 8
	Const TEXTURE_DISABLED% = 0
	Const TEXTURE_2D% = 1
	Const MAX_BONES% = 128

	'---------------------------------------------------------------------------
	'Setup
	'---------------------------------------------------------------------------

	Function Init:Bool()
		'Get GL and GLSL versions
#If LANG = "js"
		Local glVersionStr$[] = glGetString(GL_VERSION).Split(" ")
		Local glslVersionStr$[] = glGetString(GL_SHADING_LANGUAGE_VERSION).Split(" ")
		mVersion = Float(glVersionStr[glVersionStr.Length() - 1])
		mShadingVersion = Float(glslVersionStr[glslVersionStr.Length() - 1])
#Else
		mVersion = Float(glGetString(GL_VERSION).Split(" ")[0])
		mShadingVersion = Float(glGetString(GL_SHADING_LANGUAGE_VERSION).Split(" ")[0])
#End

		'Prepare default program
		mDefaultProgram = CreateProgram(STD_VERTEX_SHADER, STD_FRAGMENT_SHADER)
		If mDefaultProgram = 0 Then Return False
		m2DProgram = CreateProgram(_2D_VERTEX_SHADER, _2D_FRAGMENT_SHADER)
		If m2DProgram = 0 Then Return False
		UseProgram(mDefaultProgram)

		'Create buffer for 2D rendering
		mDataBuffer = New DataBuffer(ELLIPSEPOINTS*12)
		mVertexBuffer2D = CreateBuffer()

		Return True
	End

	Function Setup2D:Void(x%, y%, w%, h%)
		'Switch to 2D program
		UseProgram(m2DProgram)

		'Disable 3D states
		SetCulling(False)
		glDisable(GL_DEPTH_TEST)
		'glBindTexture(GL_TEXTURE_2D, 0)

		'Setup 2D
		glEnable(GL_BLEND)
		glEnable(GL_SCISSOR_TEST)
		glFrontFace(GL_CCW)
		SetBlendMode(BLEND_ALPHA)
		SetColor(1,1,1,1)

		'Setup viewport
		glViewport(x, y, w, h)
		glScissor(x, y, w, h)

		'Setup matrices
		Local bottom# = y+h
		Local top# = 0
		mTempMatrix.SetIdentity()
		mTempMatrix.SetOrtho(0, x+w, bottom, top, 0, 100)
		Renderer.SetProjectionMatrix(mTempMatrix)
		mTempMatrix.SetIdentity()
		Renderer.SetViewMatrix(mTempMatrix)
		Renderer.SetModelMatrix(mTempMatrix)
	End

	Function Setup3D:Void(x%, y%, w%, h%)
		'Switch to 3D program
		UseProgram(mDefaultProgram)

		'Disable 2D & mojo states
		'glBindTexture(GL_TEXTURE_2D, 0)

		'Setup 3D
		glEnable(GL_BLEND)
		glEnable(GL_DEPTH_TEST)
		glEnable(GL_SCISSOR_TEST)
		glDepthFunc(GL_LEQUAL)

		SetLighting(False)
		SetCulling(True)
		glFrontFace(GL_CW)
		SetDepthWrite(True)
		SetBlendMode(BLEND_ALPHA)
		SetColor(1,1,1,1)
		SetSkinned(False)

		'Setup viewport
		glViewport(x, y, w, h)
		glScissor(x, y, w, h)
	End

	Function SetProjectionMatrix:Void(m:Mat4)
		mProjectionMatrix.Set(m)
	End

	Function GetProjectionMatrix:Mat4()
		Return mProjectionMatrix
	End

	Function SetViewMatrix:Void(m:Mat4)
		mViewMatrix.Set(m)
	End

	Function GetViewMatrix:Mat4()
		Return mViewMatrix
	End

	Function SetModelMatrix:Void(m:Mat4)
		If m <> mModelMatrix Then mModelMatrix.Set(m)

		'Calculate ModelView
		mTempMatrix.Set(mViewMatrix)
		mTempMatrix.Mul(mModelMatrix)
		If mModelViewLoc <> -1 Then glUniformMatrix4fv(mModelViewLoc, 1, False, mTempMatrix.m)

		'Calculate normal
		If mNormalMatrixLoc <> -1
			mTempMatrix.Invert()
			mTempMatrix.Transpose()
			glUniformMatrix4fv(mNormalMatrixLoc, 1, False, mTempMatrix.m)
		End

		'Calculate MVP
		mTempMatrix.Set(mProjectionMatrix)
		mTempMatrix.Mul(mViewMatrix)
		mTempMatrix.Mul(mModelMatrix)
		If mMVPLoc <> -1 Then glUniformMatrix4fv(mMVPLoc, 1, False, mTempMatrix.m)
	End

	Function GetModelMatrix:Mat4()
		Return mModelMatrix
	End
	
	Function SetBoneMatrices:Void(matrices:Mat4[])
		If mBonesLoc[0] <> -1
			Local lastIndex:Int = Min(MAX_BONES, matrices.Length())
			For Local i:Int = 0 Until lastIndex
				If mBonesLoc[i] <> -1 Then glUniformMatrix4fv(mBonesLoc[i], 1, False, matrices[i].m)
			Next
		End
	End
	
	Function SetSkinned:Void(enable:Bool)
		If mSkinnedLoc <> -1 Then glUniform1i(mSkinnedLoc, enable)
	End

	Function SetBlendMode:Void(mode%)
		Select mode
		Case BLEND_ALPHA
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
		Case BLEND_ADD
			glBlendFunc(GL_SRC_ALPHA, GL_ONE)
		Case BLEND_MUL
			glBlendFunc(GL_DST_COLOR, GL_ZERO)
		End
	End

	Function SetColor:Void(r#, g#, b#, a# = 1)
		If mBaseColorLoc <> -1 Then glUniform4f(mBaseColorLoc, r, g, b, a)
	End

	Function SetAmbient:Void(r#, g#, b#)
		If mAmbientLoc <> -1 Then glUniform3f(mAmbientLoc, r, g, b)
	End

	Function SetShininess:Void(shininess%)
		If mShininessLoc <> -1 Then glUniform1i(mShininessLoc, shininess)
	End
	
	Function SetFog:Void(enable:Bool, minDist:Float, maxDist:Float, r:Float, g:Float, b:Float)
		glUniform1i(mFogEnabledLoc, enable)
		If enable
			glUniform2f(mFogDistLoc, minDist, maxDist)
			glUniform3f(mFogColorLoc, r, g, b)
		End
	End

	Function SetCulling:Void(enable:Bool)
		If enable Then glEnable(GL_CULL_FACE) Else glDisable(GL_CULL_FACE)
	End

	Function SetDepthWrite:Void(enable:Bool)
		glDepthMask(enable)
	End

	Function SetLighting:Void(enable:Bool)
		If mLightingEnabledLoc <> -1 Then glUniform1i(mLightingEnabledLoc, enable)
	End

	Function SetLight:Void(index%, enable:Bool, x#, y#, z#, w#, r#, g#, b#, att#)
		If mLightEnabledLoc[index] <> -1 Then glUniform1i(mLightEnabledLoc[index], enable)
		If enable
			If mLightPosLoc[index] <> -1 Then glUniform4f(mLightPosLoc[index], x, y, z, w)
			If mLightColorLoc[index] <> -1 Then glUniform3f(mLightColorLoc[index], r, g, b)
			If mLightAttenuationLoc[index] <> -1 Then glUniform1f(mLightAttenuationLoc[index], att)
		End
	End

	'---------------------------------------------------------------------------
	' Drawing
	'---------------------------------------------------------------------------

	Function ClearColorBuffer:Void(r# = 0, g# = 0, b# = 0)
		glClearColor(r, g, b, 1)
		glClear(GL_COLOR_BUFFER_BIT)
	End

	Function ClearDepthBuffer:Void()
		glClear(GL_DEPTH_BUFFER_BIT)
	End

	Function DrawPoint:Void(x#, y#, z#)
		mDataBuffer.PokeFloat(0, x)
		mDataBuffer.PokeFloat(4, y)
		mDataBuffer.PokeFloat(8, z)
		SetVertexBufferData(mVertexBuffer2D, mDataBuffer, mDataBuffer.Length())
		glBindBuffer(GL_ARRAY_BUFFER, mVertexBuffer2D)
		glEnableVertexAttribArray(mVPosLoc)
		glVertexAttribPointer(mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glDrawArrays(GL_POINTS, 0, 1)
		glDisableVertexAttribArray(mVPosLoc)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
	End

	Function DrawLine:Void(x1#, y1#, z1#, x2#, y2#, z2#)
		mDataBuffer.PokeFloat(0, x1)
		mDataBuffer.PokeFloat(4, y1)
		mDataBuffer.PokeFloat(8, z1)
		mDataBuffer.PokeFloat(12, x2)
		mDataBuffer.PokeFloat(16, y2)
		mDataBuffer.PokeFloat(20, z2)
		SetVertexBufferData(mVertexBuffer2D, mDataBuffer, mDataBuffer.Length())
		glBindBuffer(GL_ARRAY_BUFFER, mVertexBuffer2D)
		glEnableVertexAttribArray(mVPosLoc)
		glVertexAttribPointer(mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glDrawArrays(GL_LINES, 0, 2)
		glDisableVertexAttribArray(mVPosLoc)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
	End

	Function DrawRect:Void(x#, y#, z#, width#, height#)
		mDataBuffer.PokeFloat(0, x)
		mDataBuffer.PokeFloat(4, y)
		mDataBuffer.PokeFloat(8, z)
		mDataBuffer.PokeFloat(12, x+width)
		mDataBuffer.PokeFloat(16, y)
		mDataBuffer.PokeFloat(20, z)
		mDataBuffer.PokeFloat(24, x)
		mDataBuffer.PokeFloat(28, y+height)
		mDataBuffer.PokeFloat(32, z)
		mDataBuffer.PokeFloat(36, x+width)
		mDataBuffer.PokeFloat(40, y+height)
		mDataBuffer.PokeFloat(44, z)
		SetVertexBufferData(mVertexBuffer2D, mDataBuffer, 48)
		glBindBuffer(GL_ARRAY_BUFFER, mVertexBuffer2D)
		glEnableVertexAttribArray(mVPosLoc)
		glVertexAttribPointer(mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
		glDisableVertexAttribArray(mVPosLoc)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
	End

	Function DrawEllipse:Void(x#, y#, z#, width#, height#)
		Local xradius# = width/2
		Local yradius# = height/2
		Local xcenter# = x + xradius
		Local ycenter# = y + yradius

		Local inc# = 360.0 / ELLIPSEPOINTS
		For Local i% = 0 Until ELLIPSEPOINTS
			Local c# = Cos(i * inc)
			Local s# = Sin(i * inc)
			mDataBuffer.PokeFloat(i*12, xcenter + c*xradius)
			mDataBuffer.PokeFloat(i*12 + 4, ycenter + s*yradius)
			mDataBuffer.PokeFloat(i*12 + 8, z)
		Next

		SetVertexBufferData(mVertexBuffer2D, mDataBuffer, ELLIPSEPOINTS * 12)
		glBindBuffer(GL_ARRAY_BUFFER, mVertexBuffer2D)
		glEnableVertexAttribArray(mVPosLoc)
		glVertexAttribPointer(mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glDrawArrays(GL_TRIANGLE_FAN, 0, ELLIPSEPOINTS)
		glDisableVertexAttribArray(mVPosLoc)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
	End

	Function DrawTexRect:Void(buffer:DataBuffer)
		SetVertexBufferData(mVertexBuffer2D, buffer, buffer.Length())
		glBindBuffer(GL_ARRAY_BUFFER, mVertexBuffer2D)
		glEnableVertexAttribArray(mVPosLoc)
		glEnableVertexAttribArray(mVTexLoc)
		glVertexAttribPointer(mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glVertexAttribPointer(mVTexLoc, 2, GL_FLOAT, False, 0, 48)
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
		glDisableVertexAttribArray(mVPosLoc)
		glDisableVertexAttribArray(mVTexLoc)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
	End

	'---------------------------------------------------------------------------
	' Texture
	'---------------------------------------------------------------------------

	Function LoadTexture%(filename$, size%[], filter%)
		Local texture% = glCreateTexture()
		glBindTexture(GL_TEXTURE_2D, texture)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GetMagFilter(filter))
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GetMinFilter(filter))
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, "monkey://data/" + filename)
		If filter > FILTER_LINEAR Then glGenerateMipmap(GL_TEXTURE_2D)
		'glBindTexture(GL_TEXTURE_2D, 0)

		'Trick to get texture size
		If size.Length() >= 2
			Local img:Image = LoadImage(filename)
			If img <> Null
				size[0] = img.Width()
				size[1] = img.Height()
				img.Discard()
			Else
				size[0] = 0
				size[1] = 0
			End
		End

		Return texture
	End

	Function GenTexture%(buffer:DataBuffer, width%, height%, filter%)
		Local texture% = glCreateTexture()
		glBindTexture(GL_TEXTURE_2D, texture)
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GetMagFilter(filter))
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GetMinFilter(filter))
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer)
		If filter > FILTER_LINEAR Then glGenerateMipmap(GL_TEXTURE_2D)
		'glBindTexture(GL_TEXTURE_2D, 0)
		Return texture
	End

	Function FreeTexture:Void(texture%)
		glDeleteTexture(texture)
	End

	Function SetTexture:Void(texture%)
		If texture <> 0 Then glBindTexture(GL_TEXTURE_2D, texture)
		If mBaseTexModeLoc <> -1 Then glUniform1i(mBaseTexModeLoc, texture <> 0)
	End

	'---------------------------------------------------------------------------
	' VBO
	'---------------------------------------------------------------------------

	Function CreateBuffer%()
		Return glCreateBuffer()
	End

	Function FreeBuffer:Void(buffer%)
		glDeleteBuffer(buffer)
	End

	Function SetVertexBufferData:Void(buffer%, data:DataBuffer, length%)
		glBindBuffer(GL_ARRAY_BUFFER, buffer)
		glBufferData(GL_ARRAY_BUFFER, length, data, GL_STATIC_DRAW)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
	End

	Function SetIndexBufferData:Void(buffer%, data:DataBuffer, length%)
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer)
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, length, data, GL_STATIC_DRAW)
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
	End

	Function DrawBuffers:Void(vertexBuffer%, indexBuffer%, numIndices%, coordsOffset%, normalsOffset%, colorsOffset%, texCoordsOffset%, boneIndicesOffset%, boneWeightsOffset%, stride%)
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer)
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer)
		If coordsOffset >= 0 And mVPosLoc > -1 Then glEnableVertexAttribArray(mVPosLoc); glVertexAttribPointer(mVPosLoc, 3, GL_FLOAT, False, stride, coordsOffset)
		If normalsOffset >= 0 And mVNormalLoc > -1 Then glEnableVertexAttribArray(mVNormalLoc); glVertexAttribPointer(mVNormalLoc, 3, GL_FLOAT, False, stride, normalsOffset)
		If colorsOffset >= 0 And mVColorLoc > -1 Then glEnableVertexAttribArray(mVColorLoc); glVertexAttribPointer(mVColorLoc, 4, GL_FLOAT, False, stride, colorsOffset)
		If texCoordsOffset >= 0 And mVTexLoc > -1 Then glEnableVertexAttribArray(mVTexLoc); glVertexAttribPointer(mVTexLoc, 2, GL_FLOAT, False, stride, texCoordsOffset)
		If boneIndicesOffset >= 0 And mVBoneIndicesLoc > -1 Then glEnableVertexAttribArray(mVBoneIndicesLoc); glVertexAttribPointer(mVBoneIndicesLoc, 4, GL_FLOAT, False, stride, boneIndicesOffset)
		If boneWeightsOffset >= 0 And mVBoneWeightsLoc > -1 Then glEnableVertexAttribArray(mVBoneWeightsLoc); glVertexAttribPointer(mVBoneWeightsLoc, 4, GL_FLOAT, False, stride, boneWeightsOffset)
		glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, 0)
		If mVPosLoc > -1 Then glDisableVertexAttribArray(mVPosLoc)
		If mVNormalLoc > -1 Then glDisableVertexAttribArray(mVNormalLoc)
		If mVColorLoc > -1 Then glDisableVertexAttribArray(mVColorLoc)
		If mVTexLoc > -1 Then glDisableVertexAttribArray(mVTexLoc)
		If mVBoneIndicesLoc > -1 Then glDisableVertexAttribArray(mVBoneIndicesLoc)
		If mVBoneWeightsLoc > -1 Then glDisableVertexAttribArray(mVBoneWeightsLoc)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
	End

	'---------------------------------------------------------------------------
	' Shaders
	'---------------------------------------------------------------------------

	Function CreateProgram%(vertex$, fragment$)
		vertex = GLSL_VERSION + "#define MAX_LIGHTS " + MAX_LIGHTS + "~n#define MAX_BONES " + MAX_BONES + "~n" + vertex
		fragment = GLSL_VERSION + "#define MAX_LIGHTS " + MAX_LIGHTS + "~n" + fragment

		Local retCode%[1]

		'Create vertex shader
		Local vshader% = glCreateShader(GL_VERTEX_SHADER)
		glShaderSource(vshader, vertex)
		glCompileShader(vshader)
		mProgramError = glGetShaderInfoLog(vshader)
		glGetShaderiv(vshader, GL_COMPILE_STATUS, retCode)
		If retCode[0] = GL_FALSE
			glDeleteShader(vshader)
			Return 0
		End

		'Create fragment shader
		Local fshader% = glCreateShader(GL_FRAGMENT_SHADER)
		glShaderSource(fshader, fragment)
		glCompileShader(fshader)
		mProgramError += "~n" + glGetShaderInfoLog(fshader)
		glGetShaderiv(fshader, GL_COMPILE_STATUS, retCode)
		If retCode[0] = GL_FALSE
			glDeleteShader(vshader)
			glDeleteShader(fshader)
			Return 0
		End

		'Create program
		Local program% = glCreateProgram()
		glAttachShader(program, vshader)
		glAttachShader(program, fshader)
		glLinkProgram(program)
		glDeleteShader(vshader)
		glDeleteShader(fshader)
		glGetProgramiv(program, GL_LINK_STATUS, retCode)
		If retCode[0] = GL_FALSE
			mProgramError = glGetProgramInfoLog(program)
			FreeProgram(program)
			Return 0
		End
		Return program
	End

	Function FreeProgram:Void(program%)
		glDeleteProgram(program)
	End

	Function UseProgram:Void(program%)
		If program = 0 Then program = mDefaultProgram
		glUseProgram(program)
		mMVPLoc = glGetUniformLocation(program, "mvp")
		mModelViewLoc = glGetUniformLocation(program, "modelView")
		mNormalMatrixLoc = glGetUniformLocation(program, "normalMatrix")
		mBaseTexModeLoc = glGetUniformLocation(program, "baseTexMode")
		mLightingEnabledLoc = glGetUniformLocation(program, "lightingEnabled")
		For Local i% = 0 Until MAX_LIGHTS
			mLightEnabledLoc[i] = glGetUniformLocation(program, "lightEnabled[" + i + "]")
			mLightPosLoc[i] = glGetUniformLocation(program, "lightPos[" + i + "]")
			mLightColorLoc[i] = glGetUniformLocation(program, "lightColor[" + i + "]")
			mLightAttenuationLoc[i] = glGetUniformLocation(program, "lightAttenuation[" + i + "]")
		Next
		mBaseColorLoc = glGetUniformLocation(program, "baseColor")
		mAmbientLoc = glGetUniformLocation(program, "ambient")
		mShininessLoc = glGetUniformLocation(program, "shininess")
		mFogEnabledLoc = glGetUniformLocation(program, "fogEnabled")
		mFogDistLoc = glGetUniformLocation(program, "fogDist")
		mFogColorLoc = glGetUniformLocation(program, "fogColor")
		mSkinnedLoc = glGetUniformLocation(program, "skinned")
		For Local i% = 0 Until MAX_BONES
			mBonesLoc[i] = glGetUniformLocation(program, "bones[" + i + "]")
		Next
		mVPosLoc = glGetAttribLocation(program, "vpos")
		mVNormalLoc = glGetAttribLocation(program, "vnormal")
		mVColorLoc = glGetAttribLocation(program, "vcolor")
		mVTexLoc = glGetAttribLocation(program, "vtex")
		mVBoneIndicesLoc = glGetAttribLocation(program, "vboneIndices")
		mVBoneWeightsLoc = glGetAttribLocation(program, "vboneWeights")

		Local baseTexSamplerLoc% = glGetUniformLocation(program, "baseTexSampler")
		If baseTexSamplerLoc <> -1 Then glUniform1i(baseTexSamplerLoc, 0)
	End

	Function GetDefaultProgram%()
		Return mDefaultProgram
	End

	Function GetProgramError$()
		Return mProgramError
	End

	Function GetAPIVersion:Float()
		Return mVersion
	End Function

	Function GetShadingVersion:Float()
		Return mShadingVersion
	End Function
Private
	Method New()
	End

	Function GetMagFilter%(filtering%)
		Select filtering
		Case FILTER_NONE
			Return GL_NEAREST
		Case FILTER_LINEAR
			Return GL_LINEAR
		Case FILTER_BILINEAR
			Return GL_LINEAR
		Case FILTER_TRILINEAR
			Return GL_LINEAR
		Default
			Return GL_LINEAR
		End
	End

	Function GetMinFilter%(filtering%)
		Select filtering
		Case FILTER_NONE
			Return GL_NEAREST
		Case FILTER_LINEAR
			Return GL_LINEAR
		Case FILTER_BILINEAR
			Return GL_LINEAR_MIPMAP_NEAREST
		Case FILTER_TRILINEAR
			Return GL_LINEAR_MIPMAP_LINEAR
		Default
			Return GL_LINEAR
		End
	End

	'GL and GLSL version
	Global mVersion#
	Global mShadingVersion#

	'Localization of vars in shaders
	Global mMVPLoc%
	Global mModelViewLoc%
	Global mNormalMatrixLoc%
	Global mBaseTexModeLoc%
	Global mLightingEnabledLoc%
	Global mLightEnabledLoc%[MAX_LIGHTS]
	Global mLightPosLoc%[MAX_LIGHTS]
	Global mLightColorLoc%[MAX_LIGHTS]
	Global mLightAttenuationLoc%[MAX_LIGHTS]
	Global mBaseColorLoc%
	Global mAmbientLoc%
	Global mShininessLoc%
	Global mFogEnabledLoc%
	Global mFogDistLoc%
	Global mFogColorLoc%
	Global mSkinnedLoc%
	Global mBonesLoc%[MAX_BONES]
	Global mVPosLoc%
	Global mVNormalLoc%
	Global mVColorLoc%
	Global mVTexLoc%
	Global mVBoneIndicesLoc%
	Global mVBoneWeightsLoc%

	Global mDataBuffer:DataBuffer
	Global mVertexBuffer2D%
	Global mModelMatrix:Mat4 = Mat4.Create()
	Global mViewMatrix:Mat4 = Mat4.Create()
	Global mProjectionMatrix:Mat4 = Mat4.Create()
	Global mTempMatrix:Mat4 = Mat4.Create()
	Global mDefaultProgram%						'Default program id
	Global m2DProgram%							'Default 2D program id
	Global mProgramError$						'Last error occured when compiling or linking a shader
End
