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
Const GLSL_VERSION : String = ""
'#Else
'Const GLSL_VERSION$ = "#version 120~n"
'#EndIf

Public

Class Renderer Final
Public
	Const BLEND_ALPHA% = 0
	Const BLEND_ADD% = 1
	Const BLEND_MUL% = 2
	Const ELLIPSEPOINTS% = 64
	Const FILTER_NONE% = 0
	Const FILTER_LINEAR% = 1
	Const FILTER_BILINEAR% = 2
	Const FILTER_TRILINEAR% = 3
	Const TEXTURE_DISABLED% = 0
	Const TEXTURE_2D% = 1
	Const BASETEX_UNIT% = 0
	Const BASECUBE_UNIT% = 1
	Const NORMALTEX_UNIT% = 2
	Const REFLECTTEX_UNIT% = 3
	Const REFRACTTEX_UNIT% = 4

	'---------------------------------------------------------------------------
	'Setup
	'---------------------------------------------------------------------------

	Function Init:Bool(numLights:Int, numBones:Int)
		'Set the max number of lights and bones supported
		mMaxLights = numLights
		mMaxBones = numBones
	
		'Get GL and GLSL versions
		mVendor = glGetString(GL_VENDOR)
		mRenderer = glGetString(GL_RENDERER)
		mVersionStr = glGetString(GL_VERSION)
		mShadingVersionStr = glGetString(GL_SHADING_LANGUAGE_VERSION)
#If LANG = "js"
		Local glVersionStr$[] = mVersionStr.Split(" ")
		Local glslVersionStr$[] = mShadingVersionStr.Split(" ")
		mVersion = Float(glVersionStr[glVersionStr.Length() - 1])
		mShadingVersion = Float(glslVersionStr[glslVersionStr.Length() - 1])
#Else
		mVersion = Float(mVersionStr.Split(" ")[0])
		mShadingVersion = Float(mShadingVersionStr.Split(" ")[0])
#End

		'Prepare default program
		mDefaultProgram = CreateProgram(STD_VERTEX_SHADER, STD_FRAGMENT_SHADER)
		If mDefaultProgram = Null Then Return False
		m2DProgram = CreateProgram(_2D_VERTEX_SHADER, _2D_FRAGMENT_SHADER)
		If m2DProgram = Null Then Return False
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
		mTempMatrix.SetOrthoLH(0, x+w, bottom, top, 0, 100)
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

		SetPixelLighting(False)
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
		mInvViewMatrix.Set(m)
		mInvViewMatrix.Invert()
	End

	Function GetViewMatrix:Mat4()
		Return mViewMatrix
	End

	Function SetModelMatrix:Void(m:Mat4)
		If m <> mModelMatrix Then mModelMatrix.Set(m)

		'Calculate ModelView
		If mActiveProgram.mModelViewLoc <> -1 Or mActiveProgram.mNormalMatrixLoc <> -1
			mTempMatrix.Set(mViewMatrix)
			mTempMatrix.Mul(mModelMatrix)
			glUniformMatrix4fv(mActiveProgram.mModelViewLoc, 1, False, mTempMatrix.M)
		End

		'Calculate normal
		If mActiveProgram.mNormalMatrixLoc <> -1
			mTempMatrix.Invert()
			mTempMatrix.Transpose()
			glUniformMatrix4fv(mActiveProgram.mNormalMatrixLoc, 1, False, mTempMatrix.M)
		End
		
		'Set inverse view
		If mActiveProgram.mInvViewLoc <> -1 Then glUniformMatrix4fv(mActiveProgram.mInvViewLoc, 1, False, mInvViewMatrix.M)

		'Calculate MVP
		If mActiveProgram.mMVPLoc <> -1
			mTempMatrix.Set(mProjectionMatrix)
			mTempMatrix.Mul(mViewMatrix)
			mTempMatrix.Mul(mModelMatrix)
			glUniformMatrix4fv(mActiveProgram.mMVPLoc, 1, False, mTempMatrix.M)
		End
	End

	Function GetModelMatrix:Mat4()
		Return mModelMatrix
	End
	
	Function SetBoneMatrices:Void(matrices:Mat4[])
		If mActiveProgram.mBonesLoc[0] <> -1
			Local lastIndex:Int = Min(mMaxBones, matrices.Length())
			For Local i:Int = 0 Until lastIndex
				If mActiveProgram.mBonesLoc[i] <> -1 Then glUniformMatrix4fv(mActiveProgram.mBonesLoc[i], 1, False, matrices[i].M)
			Next
		End
	End
	
	Function SetSkinned:Void(enable:Bool)
		If mActiveProgram.mSkinnedLoc <> -1 Then glUniform1i(mActiveProgram.mSkinnedLoc, enable)
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
		If mActiveProgram.mBaseColorLoc <> -1 Then glUniform4f(mActiveProgram.mBaseColorLoc, r, g, b, a)
	End

	Function SetAmbient:Void(r#, g#, b#)
		If mActiveProgram.mAmbientLoc <> -1 Then glUniform3f(mActiveProgram.mAmbientLoc, r, g, b)
	End

	Function SetShininess:Void(shininess%)
		If mActiveProgram.mShininessLoc <> -1 Then glUniform1i(mActiveProgram.mShininessLoc, shininess)
	End
	
	Function SetFog:Void(enable:Bool, minDist:Float, maxDist:Float, r:Float, g:Float, b:Float)
		glUniform1i(mActiveProgram.mFogEnabledLoc, enable)
		If enable
			glUniform2f(mActiveProgram.mFogDistLoc, minDist, maxDist)
			glUniform3f(mActiveProgram.mFogColorLoc, r, g, b)
		End
	End

	Function SetCulling:Void(enable:Bool)
		If enable Then glEnable(GL_CULL_FACE) Else glDisable(GL_CULL_FACE)
	End

	Function SetDepthWrite:Void(enable:Bool)
		glDepthMask(enable)
	End
	
	Function SetRefractCoef:Void(coef:Float)
		If mActiveProgram.mRefractCoefLoc <> -1 Then glUniform1f(mActiveProgram.mRefractCoefLoc, coef)
	End
	
	Function SetPixelLighting:Void(enable:Bool)
		If mActiveProgram.mUsePixelLightingLoc <> -1 Then glUniform1i(mActiveProgram.mUsePixelLightingLoc, enable)
	End

	Function SetLighting:Void(enable:Bool)
		If mActiveProgram.mLightingEnabledLoc <> -1 Then glUniform1i(mActiveProgram.mLightingEnabledLoc, enable)
	End

	Function SetLight:Void(index%, enable:Bool, x#, y#, z#, w#, r#, g#, b#, att#)
		If mActiveProgram.mLightEnabledLoc[index] <> -1 Then glUniform1i(mActiveProgram.mLightEnabledLoc[index], enable)
		If enable
			If mActiveProgram.mLightPosLoc[index] <> -1 Then glUniform4f(mActiveProgram.mLightPosLoc[index], x, y, z, w)
			If mActiveProgram.mLightColorLoc[index] <> -1 Then glUniform3f(mActiveProgram.mLightColorLoc[index], r, g, b)
			If mActiveProgram.mLightAttenuationLoc[index] <> -1 Then glUniform1f(mActiveProgram.mLightAttenuationLoc[index], att)
		End
	End
	
	Function GetMaxLights:Int()
		Return mMaxLights
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
		glEnableVertexAttribArray(mActiveProgram.mVPosLoc)
		glVertexAttribPointer(mActiveProgram.mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glDrawArrays(GL_POINTS, 0, 1)
		glDisableVertexAttribArray(mActiveProgram.mVPosLoc)
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
		glEnableVertexAttribArray(mActiveProgram.mVPosLoc)
		glVertexAttribPointer(mActiveProgram.mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glDrawArrays(GL_LINES, 0, 2)
		glDisableVertexAttribArray(mActiveProgram.mVPosLoc)
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
		glEnableVertexAttribArray(mActiveProgram.mVPosLoc)
		glVertexAttribPointer(mActiveProgram.mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
		glDisableVertexAttribArray(mActiveProgram.mVPosLoc)
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
		glEnableVertexAttribArray(mActiveProgram.mVPosLoc)
		glVertexAttribPointer(mActiveProgram.mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glDrawArrays(GL_TRIANGLE_FAN, 0, ELLIPSEPOINTS)
		glDisableVertexAttribArray(mActiveProgram.mVPosLoc)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
	End

	Function DrawTexRect:Void(buffer:DataBuffer)
		SetVertexBufferData(mVertexBuffer2D, buffer, buffer.Length())
		glBindBuffer(GL_ARRAY_BUFFER, mVertexBuffer2D)
		glEnableVertexAttribArray(mActiveProgram.mVPosLoc)
		glEnableVertexAttribArray(mActiveProgram.mVTexLoc)
		glVertexAttribPointer(mActiveProgram.mVPosLoc, 3, GL_FLOAT, False, 0, 0)
		glVertexAttribPointer(mActiveProgram.mVTexLoc, 2, GL_FLOAT, False, 0, 48)
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
		glDisableVertexAttribArray(mActiveProgram.mVPosLoc)
		glDisableVertexAttribArray(mActiveProgram.mVTexLoc)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
	End

	'---------------------------------------------------------------------------
	' Texture
	'---------------------------------------------------------------------------
	
	Function GenTexture%(buffer:DataBuffer, width%, height%, filter%)
		Local texture% = glCreateTexture()
		glBindTexture(GL_TEXTURE_2D, texture)
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GetMagFilter(filter))
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GetMinFilter(filter))
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer)
#If TARGET<>"html5"
		If filter > FILTER_LINEAR Then glGenerateMipmap(GL_TEXTURE_2D)
#EndIf
		'glBindTexture(GL_TEXTURE_2D, 0)
		Return texture
	End

	Function LoadTexture%(filename$, size%[], filter%)
		Local texture% = glCreateTexture()
		glBindTexture(GL_TEXTURE_2D, texture)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GetMagFilter(filter))
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GetMinFilter(filter))
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, "monkey://data/" + filename)
#If TARGET<>"html5"
		If filter > FILTER_LINEAR Then glGenerateMipmap(GL_TEXTURE_2D)
#EndIf
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
	
	Function LoadCubicTexture:Int(left:String, right:String, front:String, back:String, top:String, bottom:String, size:Int[], filter:Int)
		Local texture% = glCreateTexture()
		glBindTexture(GL_TEXTURE_CUBE_MAP, texture)
		glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
		glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
		glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GetMagFilter(filter))
		glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GetMinFilter(filter))
		glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, "monkey://data/" + left)
		glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, "monkey://data/" + right)
		glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, "monkey://data/" + front)
		glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, "monkey://data/" + back)
		glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, "monkey://data/" + top)
		glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, "monkey://data/" + bottom)
#If TARGET<>"html5"
		If filter > FILTER_LINEAR Then glGenerateMipmap(GL_TEXTURE_CUBE_MAP)
#Endif
		'glBindTexture(GL_TEXTURE_2D, 0)

		'Trick to get texture size
		If size.Length() >= 2
			Local img:Image = LoadImage(left)
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

	Function FreeTexture:Void(texture%)
		glDeleteTexture(texture)
	End

	Function SetTextures:Void(diffuseTex:Int, normalTex:Int, reflectionTex:Int, refractionTex:Int, isDiffuseCubic:Bool)
		If diffuseTex <> 0
			If Not isDiffuseCubic
				glActiveTexture(GL_TEXTURE0 + BASETEX_UNIT)
				glBindTexture(GL_TEXTURE_2D, diffuseTex)
			Else
				glActiveTexture(GL_TEXTURE0 + BASECUBE_UNIT)
				glBindTexture(GL_TEXTURE_CUBE_MAP, diffuseTex)
			End
		End
		If normalTex <> 0
			glActiveTexture(GL_TEXTURE0 + NORMALTEX_UNIT)
			glBindTexture(GL_TEXTURE_2D, normalTex)
		End
		If reflectionTex <> 0
			glActiveTexture(GL_TEXTURE0 + REFLECTTEX_UNIT)
			glBindTexture(GL_TEXTURE_CUBE_MAP, reflectionTex)
		End
		If refractionTex <> 0
			glActiveTexture(GL_TEXTURE0 + REFRACTTEX_UNIT)
			glBindTexture(GL_TEXTURE_CUBE_MAP, refractionTex)
		End
		
		If mActiveProgram.mBaseTexModeLoc <> -1
			If diffuseTex = 0
				glUniform1i(mActiveProgram.mBaseTexModeLoc, 0)
			Elseif Not isDiffuseCubic
				glUniform1i(mActiveProgram.mBaseTexModeLoc, 1)
			Else
				glUniform1i(mActiveProgram.mBaseTexModeLoc, 2)
			End
		End
		If mActiveProgram.mUseNormalTexLoc <> -1 Then glUniform1i(mActiveProgram.mUseNormalTexLoc, normalTex <> 0)
		If mActiveProgram.mUseReflectTexLoc <> -1 Then glUniform1i(mActiveProgram.mUseReflectTexLoc, reflectionTex <> 0)
		If mActiveProgram.mUseRefractTexLoc <> -1 Then glUniform1i(mActiveProgram.mUseRefractTexLoc, refractionTex <> 0)
		
		glActiveTexture(GL_TEXTURE0)
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

	Function DrawBuffers:Void(vertexBuffer%, indexBuffer%, numIndices%, coordsOffset%, normalsOffset%, tangentsOffset%, colorsOffset%, texCoordsOffset%, boneIndicesOffset%, boneWeightsOffset%, stride%)
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer)
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer)
		If coordsOffset >= 0 And mActiveProgram.mVPosLoc > -1 Then glEnableVertexAttribArray(mActiveProgram.mVPosLoc); glVertexAttribPointer(mActiveProgram.mVPosLoc, 3, GL_FLOAT, False, stride, coordsOffset)
		If normalsOffset >= 0 And mActiveProgram.mVNormalLoc > -1 Then glEnableVertexAttribArray(mActiveProgram.mVNormalLoc); glVertexAttribPointer(mActiveProgram.mVNormalLoc, 3, GL_FLOAT, False, stride, normalsOffset)
		If tangentsOffset >= 0 And mActiveProgram.mVTangentLoc > -1 Then glEnableVertexAttribArray(mActiveProgram.mVTangentLoc); glVertexAttribPointer(mActiveProgram.mVTangentLoc, 3, GL_FLOAT, False, stride, tangentsOffset)
		If colorsOffset >= 0 And mActiveProgram.mVColorLoc > -1 Then glEnableVertexAttribArray(mActiveProgram.mVColorLoc); glVertexAttribPointer(mActiveProgram.mVColorLoc, 4, GL_FLOAT, False, stride, colorsOffset)
		If texCoordsOffset >= 0 And mActiveProgram.mVTexLoc > -1 Then glEnableVertexAttribArray(mActiveProgram.mVTexLoc); glVertexAttribPointer(mActiveProgram.mVTexLoc, 2, GL_FLOAT, False, stride, texCoordsOffset)
		If boneIndicesOffset >= 0 And mActiveProgram.mVBoneIndicesLoc > -1 Then glEnableVertexAttribArray(mActiveProgram.mVBoneIndicesLoc); glVertexAttribPointer(mActiveProgram.mVBoneIndicesLoc, 4, GL_FLOAT, False, stride, boneIndicesOffset)
		If boneWeightsOffset >= 0 And mActiveProgram.mVBoneWeightsLoc > -1 Then glEnableVertexAttribArray(mActiveProgram.mVBoneWeightsLoc); glVertexAttribPointer(mActiveProgram.mVBoneWeightsLoc, 4, GL_FLOAT, False, stride, boneWeightsOffset)
		glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, 0)
		If mActiveProgram.mVPosLoc > -1 Then glDisableVertexAttribArray(mActiveProgram.mVPosLoc)
		If mActiveProgram.mVNormalLoc > -1 Then glDisableVertexAttribArray(mActiveProgram.mVNormalLoc)
		If mActiveProgram.mVTangentLoc > -1 Then glDisableVertexAttribArray(mActiveProgram.mVTangentLoc)
		If mActiveProgram.mVColorLoc > -1 Then glDisableVertexAttribArray(mActiveProgram.mVColorLoc)
		If mActiveProgram.mVTexLoc > -1 Then glDisableVertexAttribArray(mActiveProgram.mVTexLoc)
		If mActiveProgram.mVBoneIndicesLoc > -1 Then glDisableVertexAttribArray(mActiveProgram.mVBoneIndicesLoc)
		If mActiveProgram.mVBoneWeightsLoc > -1 Then glDisableVertexAttribArray(mActiveProgram.mVBoneWeightsLoc)
		glBindBuffer(GL_ARRAY_BUFFER, 0)
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
	End

	'---------------------------------------------------------------------------
	' Shaders
	'---------------------------------------------------------------------------

	Function CreateProgram:GpuProgram(vertex$, fragment$)
		vertex = GLSL_VERSION + "#define MAX_LIGHTS " + mMaxLights + "~n#define MAX_BONES " + mMaxBones + "~n" + vertex
		fragment = GLSL_VERSION + "#define MAX_LIGHTS " + mMaxLights + "~n" + fragment

		Local retCode%[1]

		'Create vertex shader
		Local vshader% = glCreateShader(GL_VERTEX_SHADER)
		glShaderSource(vshader, vertex)
		glCompileShader(vshader)
		mProgramError = glGetShaderInfoLog(vshader)
		glGetShaderiv(vshader, GL_COMPILE_STATUS, retCode)
		If retCode[0] = GL_FALSE
			glDeleteShader(vshader)
			Return Null
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
			Return Null
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
			Return Null
		End
		
		Return New GpuProgram(program)
	End

	Function FreeProgram:Void(program:GpuProgram)
		program.Free()
	End

	Function UseProgram:Void(program:GpuProgram)
		If program = Null Then program = mDefaultProgram
		program.Use()
		mActiveProgram = program
	End

	Function GetDefaultProgram:GpuProgram()
		Return mDefaultProgram
	End

	Function GetProgramError$()
		Return mProgramError
	End
	
	Function GetVendorName:String()
		Return mVendor
	End
	
	Function GetRendererName:String()
		Return mRenderer
	End
	
	Function GetAPIVersionName:String()
		Return mVersionStr
	End
	
	Function GetShadingVersionName:String()
		Return mShadingVersionStr
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
#If TARGET<>"html5"
		Case FILTER_BILINEAR
			Return GL_LINEAR_MIPMAP_NEAREST
		Case FILTER_TRILINEAR
			Return GL_LINEAR_MIPMAP_LINEAR
#EndIf
		Default
			Return GL_LINEAR
		End
	End
	
	Global mMaxLights	: Int
	Global mMaxBones	: Int

	'GL and GLSL version
	Global mVendor:String
	Global mRenderer:String
	Global mVersionStr:String
	Global mShadingVersionStr:String
	Global mVersion#
	Global mShadingVersion#

	Global mDataBuffer:DataBuffer
	Global mVertexBuffer2D%
	Global mModelMatrix:Mat4 = Mat4.Create()
	Global mViewMatrix:Mat4 = Mat4.Create()
	Global mProjectionMatrix:Mat4 = Mat4.Create()
	Global mInvViewMatrix:Mat4 = Mat4.Create()
	Global mTempMatrix:Mat4 = Mat4.Create()
	Global mDefaultProgram:GpuProgram			'Default program id
	Global m2DProgram:GpuProgram				'Default 2D program id
	Global mActiveProgram:GpuProgram			'Currently active program
	Global mProgramError$						'Last error occured when compiling or linking a shader
End

Private

Class GpuProgram
	Field mProgramId%
	Field mMVPLoc%
	Field mModelViewLoc%
	Field mNormalMatrixLoc%
	Field mInvViewLoc%
	Field mBaseTexModeLoc%
	Field mUseNormalTexLoc%
	Field mUseReflectTexLoc%
	Field mUseRefractTexLoc%
	Field mBaseTexSamplerLoc%
	Field mBaseCubeSamplerLoc%
	Field mNormalTexSamplerLoc%
	Field mReflectCubeSamplerLoc%
	Field mRefractCubeSamplerLoc%
	Field mUsePixelLightingLoc%
	Field mLightingEnabledLoc%
	Field mLightEnabledLoc%[Renderer.mMaxLights]
	Field mLightPosLoc%[Renderer.mMaxLights]
	Field mLightColorLoc%[Renderer.mMaxLights]
	Field mLightAttenuationLoc%[Renderer.mMaxLights]
	Field mBaseColorLoc%
	Field mAmbientLoc%
	Field mShininessLoc%
	Field mRefractCoefLoc%
	Field mFogEnabledLoc%
	Field mFogDistLoc%
	Field mFogColorLoc%
	Field mSkinnedLoc%
	Field mBonesLoc%[Renderer.mMaxBones]
	Field mVPosLoc%
	Field mVNormalLoc%
	Field mVTangentLoc%
	Field mVColorLoc%
	Field mVTexLoc%
	Field mVBoneIndicesLoc%
	Field mVBoneWeightsLoc%
	
	Method New(program%)
		mProgramId = program
		glUseProgram(program)
		mMVPLoc = glGetUniformLocation(program, "mvp")
		mModelViewLoc = glGetUniformLocation(program, "modelView")
		mNormalMatrixLoc = glGetUniformLocation(program, "normalMatrix")
		mInvViewLoc = glGetUniformLocation(program, "invView")
		mBaseTexModeLoc = glGetUniformLocation(program, "baseTexMode")
		mUseNormalTexLoc = glGetUniformLocation(program, "useNormalTex")
		mUseReflectTexLoc = glGetUniformLocation(program, "useReflectTex")
		mUseRefractTexLoc = glGetUniformLocation(program, "useRefractTex")
		mUsePixelLightingLoc = glGetUniformLocation(program, "usePixelLighting")
		mLightingEnabledLoc = glGetUniformLocation(program, "lightingEnabled")
		For Local i% = 0 Until Renderer.mMaxLights
			mLightEnabledLoc[i] = glGetUniformLocation(program, "lightEnabled[" + i + "]")
			mLightPosLoc[i] = glGetUniformLocation(program, "lightPos[" + i + "]")
			mLightColorLoc[i] = glGetUniformLocation(program, "lightColor[" + i + "]")
			mLightAttenuationLoc[i] = glGetUniformLocation(program, "lightAttenuation[" + i + "]")
		Next
		mBaseColorLoc = glGetUniformLocation(program, "baseColor")
		mAmbientLoc = glGetUniformLocation(program, "ambient")
		mShininessLoc = glGetUniformLocation(program, "shininess")
		mRefractCoefLoc = glGetUniformLocation(program, "refractCoef")
		mFogEnabledLoc = glGetUniformLocation(program, "fogEnabled")
		mFogDistLoc = glGetUniformLocation(program, "fogDist")
		mFogColorLoc = glGetUniformLocation(program, "fogColor")
		mSkinnedLoc = glGetUniformLocation(program, "skinned")
		For Local i% = 0 Until Renderer.mMaxBones
			mBonesLoc[i] = glGetUniformLocation(program, "bones[" + i + "]")
		Next
		mVPosLoc = glGetAttribLocation(program, "vpos")
		mVNormalLoc = glGetAttribLocation(program, "vnormal")
		mVTangentLoc = glGetAttribLocation(program, "vtangent")
		mVColorLoc = glGetAttribLocation(program, "vcolor")
		mVTexLoc = glGetAttribLocation(program, "vtex")
		mVBoneIndicesLoc = glGetAttribLocation(program, "vboneIndices")
		mVBoneWeightsLoc = glGetAttribLocation(program, "vboneWeights")

		mBaseTexSamplerLoc = glGetUniformLocation(program, "baseTexSampler")
		mBaseCubeSamplerLoc = glGetUniformLocation(program, "baseCubeSampler")
		mNormalTexSamplerLoc = glGetUniformLocation(program, "normalTexSampler")
		mReflectCubeSamplerLoc = glGetUniformLocation(program, "reflectCubeSampler")
		mRefractCubeSamplerLoc = glGetUniformLocation(program, "refractCubeSampler")
	End
	
	Method Free:Void()
		glDeleteProgram(mProgramId)
	End
	
	Method Use:Void()
		glUseProgram(mProgramId)		
		If mBaseTexSamplerLoc <> -1 Then glUniform1i(mBaseTexSamplerLoc, Renderer.BASETEX_UNIT)
		If mBaseCubeSamplerLoc <> -1 Then glUniform1i(mBaseCubeSamplerLoc, Renderer.BASECUBE_UNIT)
		If mNormalTexSamplerLoc <> -1 Then glUniform1i(mNormalTexSamplerLoc, Renderer.NORMALTEX_UNIT)
		If mReflectCubeSamplerLoc <> -1 Then glUniform1i(mReflectCubeSamplerLoc, Renderer.REFLECTTEX_UNIT)
		If mRefractCubeSamplerLoc <> -1 Then glUniform1i(mRefractCubeSamplerLoc, Renderer.REFRACTTEX_UNIT)
	End
End
