Strict

Private

Import src.config
Import src.bone
Import src.brush
Import src.cache
Import src.drawable
Import src.font
Import src.lighting
Import src.mesh
Import src.painter
Import src.renderer
Import src.surface
Import src.texture
Import src.viewer

Class Vortex Final
Public
	Function Init:Bool()
		Return Renderer.Init()
	End

	Function GetShaderError:String()
		Return Renderer.GetProgramError()
	End

	Function GetAPIVersion:Float()
		Return Renderer.GetAPIVersion()
	End Function

	Function GetShadingVersion:Float()
		Return Renderer.GetShadingVersion()
	End Function
Private
	Method New()
	End
End

Public

'Blend modes
Const BLEND_ALPHA:Int = Brush.BLEND_ALPHA
Const BLEND_ADD:Int = Brush.BLEND_ADD
Const BLEND_MUL:Int = Brush.BLEND_MUL

'Billboard modes
Const BILLBOARD_NONE:Int = Drawable.BILLBOARD_NONE
Const BILLBOARD_SPHERICAL:Int = Drawable.BILLBOARD_SPHERICAL
Const BILLBOARD_CYLINDRICAL:Int = Drawable.BILLBOARD_CYLINDRICAL

'Light types
Const LIGHT_DIRECTIONAL:Int = Lighting.DIRECTIONAL
Const LIGHT_POINT:Int = Lighting.POINT

'Texture filters
Const FILTER_NONE:Int = Texture.FILTER_NONE
Const FILTER_LINEAR:Int = Texture.FILTER_LINEAR
Const FILTER_BILINEAR:Int = Texture.FILTER_BILINEAR
Const FILTER_TRILINEAR:Int = Texture.FILTER_TRILINEAR

'--------------------------------------
'Bone
'--------------------------------------

Function Bone_Create:Object(name:String)
	Return Bone.Create(name)
End

Function Bone_GetName:String(bone:Object)
	Return Bone(bone).GetName()
End

Function Bone_SetParent:Void(bone:Object, parent:Object)
	Bone(bone).SetParent(Bone(parent))
End

Function Bone_GetParent:Object(bone:Object)
	Return Bone(bone).GetParent()
End

Function Bone_CalcPoseMatrix:Void(bone:Object, px:Float, py:Float, pz:Float, rw:Float, rx:Float, ry:Float, rz:Float, sx:Float, sy:Float, sz:Float)
	Bone(bone).CalcPoseMatrix(px, py, pz, rw, rx, ry, rz, sx, sy, sz)
End

Function Bone_GetPoseMatrix:Float[](bone:Object)
	Return Bone(bone).GetPoseMatrix()
End

Function Bone_AddSurface:Void(bone:Object, surf:Object)
	Bone(bone).AddSurface(Surface(surf))
End

Function Bone_GetNumSurfaces:Int(bone:Object)
	Return Bone(bone).GetNumSurfaces()
End

Function Bone_GetSurface:Object(bone:Object, index:Int)
	Return Bone(bone).GetSurface(index)
End

Function Bone_AddPositionKey:Void(bone:Object, keyframe:Int, x:Float, y:Float, z:Float)
	Bone(bone).AddPositionKey(keyframe, x, y, z)
End

Function Bone_AddRotationKey:Void(bone:Object, keyframe:Int, w:Float, x:Float, y:Float, z:Float)
	Bone(bone).AddRotationKey(keyframe, w, x, y, z)
End

Function Bone_AddScaleKey:Void(bone:Object, keyframe:Int, x:Float, y:Float, z:Float)
	Bone(bone).AddScaleKey(keyframe, x, y, z)
End

Function Bone_GetNumPositionKeys:Int(bone:Object)
	Return Bone(bone).GetNumPositionKeys()
End

Function Bone_GetPositionKeyFrame:Int(bone:Object, index:Int)
	Return Bone(bone).GetPositionKeyFrame(index)
End

Function Bone_GetPositionKeyX:Float(bone:Object, index:Int)
	Return Bone(bone).GetPositionKeyX(index)
End

Function Bone_GetPositionKeyY:Float(bone:Object, index:Int)
	Return Bone(bone).GetPositionKeyY(index)
End

Function Bone_GetPositionKeyZ:Float(bone:Object, index:Int)
	Return Bone(bone).GetPositionKeyZ(index)
End

Function Bone_GetNumRotationKeys:Int(bone:Object)
	Return Bone(bone).GetNumRotationKeys()
End

Function Bone_GetRotationKeyFrame:Int(bone:Object, index:Int)
	Return Bone(bone).GetRotationKeyFrame(index)
End

Function Bone_GetRotationKeyW:Float(bone:Object, index:Int)
	Return Bone(bone).GetRotationKeyW(index)
End

Function Bone_GetRotationKeyX:Float(bone:Object, index:Int)
	Return Bone(bone).GetRotationKeyX(index)
End

Function Bone_GetRotationKeyY:Float(bone:Object, index:Int)
	Return Bone(bone).GetRotationKeyY(index)
End

Function Bone_GetRotationKeyZ:Float(bone:Object, index:Int)
	Return Bone(bone).GetRotationKeyZ(index)
End

Function Bone_GetNumScaleKeys:Int(bone:Object)
	Return Bone(bone).GetNumScaleKeys()
End

Function Bone_GetScaleKeyFrame:Int(bone:Object, index:Int)
	Return Bone(bone).GetScaleKeyFrame(index)
End

Function Bone_GetScaleKeyX:Float(bone:Object, index:Int)
	Return Bone(bone).GetScaleKeyX(index)
End

Function Bone_GetScaleKeyY:Float(bone:Object, index:Int)
	Return Bone(bone).GetScaleKeyY(index)
End

Function Bone_GetScaleKeyZ:Float(bone:Object, index:Int)
	Return Bone(bone).GetScaleKeyZ(index)
End

'--------------------------------------
'Brush
'--------------------------------------

Function Brush_SetBaseColor:Void(brush:Object, r:Float, g:Float, b:Float)
	Brush(brush).SetBaseColor(r, g, b)
End

Function Brush_GetRed:Float(brush:Object)
	Return Brush(brush).GetRed()
End

Function Brush_GetGreen:Float(brush:Object)
	Return Brush(brush).GetGreen()
End

Function Brush_GetBlue:Float(brush:Object)
	Return Brush(brush).GetBlue()
End

Function Brush_SetOpacity:Void(brush:Object, opacity:Float)
	Brush(brush).SetOpacity(opacity)
End

Function Brush_GetOpacity:Float(brush:Object)
	Return Brush(brush).GetOpacity()
End

Function Brush_SetShininess:Void(brush:Object, shininess:Float)
	Brush(brush).SetShininess(opacity)
End

Function Brush_GetShininess:Float(brush:Object)
	Return Brush(brush).GetShininess()
End

Function Brush_SetBaseTexture:Void(brush:Object, tex:Object)
	Brush(brush).SetBaseTexture(Texture(tex))
End

Function Brush_GetBaseTexture:Object(brush:Object)
	Return Brush(brush).GetBaseTexture()
End

Function Brush_SetBlendMode:Void(brush:Object, mode:Int)
	Brush(brush).SetBlendMode(mode)
End

Function Brush_GetBlendMode:Int(brush:Object)
	Return Brush(brush).GetBlendMode()
End

Function Brush_SetCulling:Void(brush:Object, enable:Bool)
	Brush(brush).SetCulling(enable)
End

Function Brush_GetCulling:Bool(brush:Object)
	Return Brush(brush).GetCulling()
End

Function Brush_SetDepthWrite:Void(brush:Object, enable:Bool)
	Brush(brush).SetDepthWrite(enable)
End

Function Brush_GetDepthWrite:Bool(brush:Object)
	Return Brush(brush).GetDepthWrite()
End

Function Brush_Prepare:Void(brush:Object)
	Brush(brush).Prepare()
End

'--------------------------------------
'Cache stack
'--------------------------------------

Function Cache_Push:Void()
	Cache.Push()
End

Function Cache_Pop:Void()
	Cache.Pop()
End

'--------------------------------------
'Drawable
'--------------------------------------

Function Drawable_Create:Object()
	Return Drawable.Create(Surface.Create())
End

Function Drawable_CreateWithMesh:Object(mesh:Object)
	Return Drawable.Create(Mesh(mesh))
End

Function Drawable_CreateBillboard:Object(texture:Object, width:Float, height:Float, mode:Int)
	Return Drawable.Create(Brush.Create(Texture(texture)), width, height, mode)
End

Function Drawable_Free:Void(drawable:Object)
	Drawable(drawable).Discard()
End

Function Drawable_Animate:Void(drawable:Object, frame:Float, firstFrame:Int = 0, lastFrame:Int = 0)
	Drawable(drawable).Animate(frame, firstFrame, lastFrame)
End

Function Drawable_Draw:Void(drawable:Object, animated:Bool = False)
	Drawable(drawable).Draw(animated)
End

Function Drawable_GetBillboardMode:Int(drawable:Object)
	Return Drawable(drawable).GetBillboardMode()
End

Function Drawable_GetMesh:Object(drawable:Object)
	Return Drawable(drawable).GetMesh()
End

Function Drawable_GetSurface:Object(drawable:Object)
	Return Drawable(drawable).GetSurface()
End

Function Drawable_SetPosition:Void(drawable:Object, x:Float, y:Float, z:Float)
	Drawable(drawable).SetPosition(x, y, z)
End

Function Drawable_GetX:Float(drawable:Object)
	Return Drawable(drawable).GetX()
End

Function Drawable_GetY:Float(drawable:Object)
	Return Drawable(drawable).GetY()
End

Function Drawable_GetZ:Float(drawable:Object)
	Return Drawable(drawable).GetZ()
End

Function Drawable_SetEuler:Void(drawable:Object, x:Float, y:Float, z:Float)
	Drawable(drawable).SetEuler(x, y, z)
End

Function Drawable_GetEulerX:Float(drawable:Object)
	Return Drawable(drawable).GetEulerX()
End

Function Drawable_GetEulerY:Float(drawable:Object)
	Return Drawable(drawable).GetEulerY()
End

Function Drawable_GetEulerZ:Float(drawable:Object)
	Return Drawable(drawable).GetEulerZ()
End

Function Drawable_SetQuat:Void(drawable:Object, w:Float, x:Float, y:Float, z:Float)
	Drawable(drawable).SetQuat(w, x, y, z)
End

Function Drawable_GetQuatW:Float(drawable:Object)
	Return Drawable(drawable).GetEulerW()
End

Function Drawable_GetQuatX:Float(drawable:Object)
	Return Drawable(drawable).GetQuatX()
End

Function Drawable_GetQuatY:Float(drawable:Object)
	Return Drawable(drawable).GetQuatY()
End

Function Drawable_GetQuatZ:Float(drawable:Object)
	Return Drawable(drawable).GetQuatZ()
End

Function Drawable_SetScale:Void(drawable:Object, x:Float, y:Float, z:Float)
	Drawable(drawable).SetScale(x, y, z)
End

Function Drawable_GetScaleX:Float(drawable:Object)
	Return Drawable(drawable).GetScaleX()
End

Function Drawable_GetScaleY:Float(drawable:Object)
	Return Drawable(drawable).GetScaleY()
End

Function Drawable_GetScaleZ:Float(drawable:Object)
	Return Drawable(drawable).GetScaleZ()
End

Function Drawable_Move:Void(drawable:Object, x:Float, y:Float, z:Float)
	Drawable(drawable).Move(x, y, z)
End

'--------------------------------------
'Font
'--------------------------------------

Function Font_Cache:Object(filename:String)
	Return Cache.GetFont(filename)
End

Function Font_GetFilename:String(font:Object)
	Return Font(font).GetFilename()
End

Function Font_GetHeight:Float(font:Object)
	Return Font(font).GetHeight()
End

Function Font_GetTextWidth:Float(font:Object, text:String)
	Return Font(font).GetTextWidth(text)
End

Function Font_GetTextHeight:Float(font:Object, text:String)
	Return Font(font).GetTextHeight(text)
End

Function Font_Draw:Void(font:Object, x:Float, y:Float, text:String)
	Font(font).Draw(x, y, text)
End

'--------------------------------------
'Lighting
'--------------------------------------

Function Lighting_SetLightEnabled:Void(index:Int, enabled:Bool)
	Lighting.SetLightEnabled(index, enabled)
End

Function Lighting_IsLightEnabled:Bool(index:Int)
	Return Lighting.IsLightEnabled(index)
End

Function Lighting_SetLightType:Void(index:Int, type:Int)
	Lighting.SetLightType(index, type)
End

Function Lighting_GetLightType:Int(index:Int)
	Return Lighting.GetLightType(index)
End

Function Lighting_SetLightPosition:Void(index:Int, x:Float, y:Float, z:Float)
	Lighting.SetLightPosition(index, x, y, z)
End

Function Lighting_GetLightX:Float(index:Int)
	Return Lighting.GetLightX(index)
End

Function Lighting_GetLightY:Float(index:Int)
	Return Lighting.GetLightY(index)
End

Function Lighting_GetLightZ:Float(index:Int)
	Return Lighting.GetLightZ(index)
End

Function Lighting_SetLightColor:Void(index:Int, r:Float, g:Float, b:Float)
	Lighting.SetLightColor(index, r, g, b)
End

Function Lighting_GetLightRed:Float(index:Int)
	Return Lighting.GetLightRed(index)
End

Function Lighting_GetLightGreen:Float(index:Int)
	Return Lighting.GetLightGreen(index)
End

Function Lighting_GetLightBlue:Float(index:Int)
	Return Lighting.GetLightBlue(index)
End

Function Lighting_SetLightAttenuation:Void(index:Int, att:Float)
	Lighting.SetLightAttenuation(index, att)
End

Function Lighting_GetLightAttenuation:Float(index:Int)
	Return Lighting.GetLightAttenuation(index)
End

Function Lighting_Prepare:Void(ambientRed:Float = 0.3, ambientGreen:Float = 0.3, ambientBlue:Float = 0.3)
	Lighting.Prepare(ambientRed, ambientGreen, ambientBlue)
End

'--------------------------------------
'Mesh
'--------------------------------------

Function Mesh_Cache:Object(filename:String, textureFilter:Int = FILTER_TRILINEAR)
	Return Cache.GetMesh(filename, textureFilter)
End

Function Mesh_Create:Object()
	Return Mesh.Create()
End

Function Mesh_Free:Void(mesh:Object)
	Mesh(mesh).Discard()
End

Function Mesh_GetFilename:String(mesh:Object)
	Return Mesh(mesh).GetFilename()
End

Function Mesh_AddSurface:Object(mesh:Object)
	Local surf:Surface = Surface.Create()
	Mesh(mesh).AddSurface(surf)
	Return surf
End

Function Mesh_GetNumSurfaces:Int(mesh:Object)
	Return Mesh(mesh).GetNumSurfaces()
End

Function Mesh_GetSurface:Object(mesh:Object, index:Int)
	Return Mesh(mesh).GetSurface(index)
End

Function Mesh_GetLastFrame:Int(mesh:Object)
	Return Mesh(mesh).GetLastFrame()
End

Function Mesh_AddBone:Void(mesh:Object, bone:Object)
	Mesh(mesh).AddBone(Bone(bone))
End

Function Mesh_GetNumBones:Int(mesh:Object)
	Return Mesh(mesh).GetNumBones()
End

Function Mesh_GetBone:Object(mesh:Object, index:Int)
	Return Mesh(mesh).GetBone(index)
End

Function Mesh_FindBone:Object(mesh:Object, name:String)
	Return Mesh(mesh).FindBone(name)
End

'--------------------------------------
'Painter
'--------------------------------------

Function Painter_Setup2D:Void(x:Int, y:Int, width:Int, height:Int)
	Painter.Setup2D(x, y, width, height)
End

Function Painter_Setup3D:Void(x:Int, y:Int, width:Int, height:Int)
	Painter.Setup3D(x, y, width, height)
End

Function Painter_SetProjectionMatrix:Void(m:Float[])
	Painter.SetProjectionMatrix(m)
End

Function Painter_GetProjectionMatrix:Void(m:Float[])
	Painter.GetProjectionMatrix(m)
End

Function Painter_SetViewMatrix:Void(m:Float[])
	Painter.SetViewMatrix(m)
End

Function Painter_GetViewMatrix:Void(m:Float[])
	Painter.GetViewMatrix(m)
End

Function Painter_SetModelMatrix:Void(m:Float[])
	Painter.SetModelMatrix(m)
End

Function Painter_GetModelMatrix:Void(m:Float[])
	Painter.GetModelMatrix(m)
End

Function Painter_SetBlendMode:Void(mode:Int)
	Painter.SetBlendMode(mode)
End

Function Painter_SetColor:Void(r:Float, g:Float, b:Float, opacity:Float = 1)
	Painter.SetColor(r, g, b, opacity)
End

Function Painter_Cls:Void(r:Float = 0, g:Float = 0, b:Float = 0)
	Painter.Cls(r, g, b)
End

Function Painter_PaintPoint:Void(x:Float, y:Float)
	Painter.PaintPoint(x, y)
End

Function Painter_PaintLine:Void(x1:Float, y1:Float, x2:Float, y2:Float)
	Painter.PaintLine(x1, y1, x2, y2)
End

Function Painter_PaintRect:Void(x:Float, y:Float, width:Float, height:Float)
	Painter.PaintRect(x, y, width, height)
End

Function Painter_PaintEllipse:Void(x:Float, y:Float, width:Float, height:Float)
	Painter.PaintEllipse(x, y, width, height)
End

'--------------------------------------
'Surface
'--------------------------------------

Function Surface_GetBrush:Object(surface:Object)
	Return Surface(surface).GetBrush()
End

Function Surface_AddTriangle:Int(surface:Object, v0:Int, v1:Int, v2:Int)
	Return Surface(surface).AddTriangle(v0, v1, v2)
End

Function Surface_GetNumTriangles:Int(surface:Object)
	Return Surface(surface).GetNumTriangles()
End

Function Surface_SetTriangleVertices:Void(surface:Object, index:Int, v0:Int, v1:Int, v2:Int)
	Surface(surface).SetTriangleVertices(index, v0, v1, v2)
End

Function Surface_GetTriangleV0:Int(surface:Object, index:Int)
	Return Surface(surface).GetTriangleV0(index)
End

Function Surface_GetTriangleV1:Int(surface:Object, index:Int)
	Return Surface(surface).GetTriangleV1(index)
End

Function Surface_GetTriangleV2:Int(surface:Object, index:Int)
	Return Surface(surface).GetTriangleV2(index)
End

Function Surface_AddVertex:Int(surface:Object, x:Float, y:Float, z:Float, nx:Float, ny:Float, nz:Float, r:Float, g:Float, b:Float, opacity:Float, u:Float, v:Float)
	Return Surface(surface).AddVertex(x, y, z, nx, ny, nz, r, g, b, opacity, u, v)
End

Function Surface_GetNumVertices:Int(surface:Object)
	Return Surface(surface).GetNumVertices()
End

Function Surface_SetVertexPosition:Void(surface:Object, index:Int, x:Float, y:Float, z:Float)
	Surface(surface).SetVertexPosition(index, x, y, z)
End

Function Surface_SetVertexNormal:Void(surface:Object, index:Int, nx:Float, ny:Float, nz:Float)
	Surface(surface).SetVertexNormal(index, nx, ny, nz)
End

Function Surface_SetVertexColor:Void(surface:Object, index:Int, r:Float, g:Float, b:Float, opacity:Float)
	Surface(surface).SetVertexColor(index, r, g, b, opacity)
End

Function Surface_SetVertexTexCoords:Void(surface:Object, index:Int, u:Float, v:Float)
	Surface(surface).SetVertexTexCoords(index, u, v)
End

Function Surface_GetVertexX:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexX(index)
End

Function Surface_GetVertexY:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexY(index)
End

Function Surface_GetVertexZ:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexZ(index)
End

Function Surface_GetVertexNX:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexNX(index)
End

Function Surface_GetVertexNY:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexNY(index)
End

Function Surface_GetVertexNZ:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexNZ(index)
End

Function Surface_GetVertexRed:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexRed(index)
End

Function Surface_GetVertexGreen:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexGreen(index)
End

Function Surface_GetVertexBlue:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexBlue(index)
End

Function Surface_GetVertexOpacity:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexOpacity(index)
End

Function Surface_GetVertexU:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexU(index)
End

Function Surface_GetVertexV:Float(surface:Object, index:Int)
	Return Surface(surface).GetVertexV(index)
End

Function Surface_Rebuild:Void(surface:Object)
	Surface(surface).Rebuild()
End

Function Surface_Draw:Void(surface:Object)
	Surface(surface).Draw()
End

'--------------------------------------
'Texture
'--------------------------------------

Function Texture_Cache:Object(filename:String, filter:Int = FILTER_TRILINEAR)
	Return Cache.GetTexture(filename, filter)
End

Function Texture_Create:Object(buffer:DataBuffer, width:Int, height:Int, filter:Int)
	Return Texture.Create(buffer, width, height, filter)
End

Function Texture_Free:Void(texture:Object)
	Texture(texture).Discard()
End

Function Texture_GetFilename:String(texture:Object)
	Return Texture(texture).GetFilename()
End

Function Texture_GetHandle:Int(texture:Object)
	Return Texture(texture).GetHandle()
End

Function Texture_GetWidth:Int(texture:Object)
	Return Texture(texture).GetWidth()
End

Function Texture_GetHeight:Int(texture:Object)
	Return Texture(texture).GetHeight()
End

Function Texture_Draw:Void(texture:Object, x:Float, y:Float, width:Float = 0, height:Float = 0, rectx:Float = 0, recty:Float = 0, rectwidth:Float = 0, rectheight:Float = 0)
	Texture(texture).Draw(x, y, width, height, rectx, recty, rectwidth, rectheight)
End

'--------------------------------------
'Viewer
'--------------------------------------

Function Viewer_Create:Object(vx:Int, vy:Int, vw:Int, vh:Int)
	Return Viewer.Create(vx, vy, vw, vh)
End

Function Viewer_Free:Void(viewer:Object)

End

Function Viewer_SetPerspective:Void(viewer:Object, fovy:Float, ratio:Float, near:Float, far:Float)
	Viewer(viewer).SetPerspective(fovy, ratio, near, far)
End

Function Viewer_SetFrustum:Void(viewer:Object, left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float)
	Viewer(viewer).SetFrustum(left, right, bottom, top, near, far)
End

Function Viewer_SetOrtho:Void(viewer:Object, left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float)
	Viewer(viewer).SetOrtho(left, right, bottom, top, near, far)
End

Function Viewer_SetClearColor:Void(viewer:Object, r:Float, g:Float, b:Float)
	Viewer(viewer).SetClearColor(r, g, b)
End

Function Viewer_GetClearRed:Float(viewer:Object)
	Return Viewer(viewer).GetClearRed()
End

Function Viewer_GetClearGreen:Float(viewer:Object)
	Return Viewer(viewer).GetClearGreen()
End

Function Viewer_GetClearBlue:Float(viewer:Object)
	Return Viewer(viewer).GetClearBlue()
End

Function Viewer_SetFog:Void(viewer:Object, enable:Bool, minDist:Float = 0, maxDist:Float = 0, r:Float = 0, g:Float = 0, b:Float = 0)
	Viewer(viewer).SetFog(enable, minDist, maxDist, r, g, b)
End

Function Viewer_SetViewport:Void(viewer:Object, x:Int, y:Int, w:Int, h:Int)
	Viewer(viewer).SetViewport(x, y, w, h)
End

Function Viewer_GetViewportX:Float(viewer:Object)
	Return Viewer(viewer).GetViewportX()
End

Function Viewer_GetViewportY:Float(viewer:Object)
	Return Viewer(viewer).GetViewportY()
End

Function Viewer_GetViewportWidth:Float(viewer:Object)
	Return Viewer(viewer).GetViewportWidth()
End

Function Viewer_GetViewportHeight:Float(viewer:Object)
	Return Viewer(viewer).GetViewportHeight()
End

Function Viewer_SetPosition:Void(viewer:Object, x:Float, y:Float, z:Float)
	Viewer(viewer).SetPosition(x, y, z)
End

Function Viewer_GetX:Float(viewer:Object)
	Return Viewer(viewer).GetX()
End

Function Viewer_GetY:Float(viewer:Object)
	Return Viewer(viewer).GetY()
End

Function Viewer_GetZ:Float(viewer:Object)
	Return Viewer(viewer).GetZ()
End

Function Viewer_SetEuler:Void(viewer:Object, x:Float, y:Float, z:Float)
	Viewer(viewer).SetEuler(x, y, z)
End

Function Viewer_GetEulerX:Float(viewer:Object)
	Return Viewer(viewer).GetEulerX()
End

Function Viewer_GetEulerY:Float(viewer:Object)
	Return Viewer(viewer).GetEulerY()
End

Function Viewer_GetEulerZ:Float(viewer:Object)
	Return Viewer(viewer).GetEulerZ()
End

Function Viewer_SetQuat:Void(viewer:Object, w:Float, x:Float, y:Float, z:Float)
	Viewer(viewer).SetQuat(w, x, y, z)
End

Function Viewer_GetQuatW:Float(viewer:Object)
	Return Viewer(viewer).GetQuatW()
End

Function Viewer_GetQuatX:Float(viewer:Object)
	Return Viewer(viewer).GetQuatX()
End

Function Viewer_GetQuatY:Float(viewer:Object)
	Return Viewer(viewer).GetQuatY()
End

Function Viewer_GetQuatZ:Float(viewer:Object)
	Return Viewer(viewer).GetQuatZ()
End

Function Viewer_Move:Void(viewer:Object, x:Float, y:Float, z:Float)
	Viewer(viewer).Move(x, y, z)
End

Function Viewer_Prepare:Void(viewer:Object)
	Viewer(viewer).Prepare()
End

'--------------------------------------
'Vortex
'--------------------------------------

Function Vortex_Init:Bool()
	If Vortex.Init()
		Cache.Push()
		Return True
	End
	Return False
End

Function Vortex_GetShaderError:String()
	Return Vortex.GetShaderError()
End

Function Vortex_GetAPIVersion:Float()
	Return Vortex.GetAPIVersion()
End

Function Vortex_GetShadingVersion:Float()
	Return Vortex.GetShadingVersion()
End
