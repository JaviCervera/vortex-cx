Strict

Private
Import os
Import vortex

Public
Function SaveMesh:Void(mesh:Mesh, filename:String, exportAnimations:Bool)
	Local buffer:String = "<mesh>~n"
	
	'Export materials
	buffer += "~t<materials>~n"
	For Local i:Int = 0 Until mesh.NumSurfaces
		Local mat:Material = mesh.GetSurface(i).Material
		buffer += "~t~t<material>~n"
		buffer += "~t~t~t<name>Material #" + i + "</name>~n"
		buffer += "~t~t~t<blend>"
		Select mat.BlendMode
		Case Renderer.BLEND_ALPHA
			buffer += "alpha"
		Case Renderer.BLEND_ADD
			buffer += "add"
		Case Renderer.BLEND_MUL
			buffer += "mul"
		End
		buffer += "</blend>~n"
		If mat.DiffuseTexture Then buffer += "~t~t~t<diffuse_tex>" + StripDir(mat.DiffuseTexture.Filename) + "</diffuse_tex>~n"
		buffer += "~t~t~t<diffuse_color>" + mat.DiffuseRed + "," + mat.DiffuseGreen + "," + mat.DiffuseBlue + "</diffuse_color>~n"
		buffer += "~t~t~t<opacity>" + mat.Opacity + "</opacity>~n"
		buffer += "~t~t~t<shininess>" + mat.Shininess + "</shininess>~n"
		If mat.Culling Then buffer += "~t~t~t<culling>true</culling>~n" Else buffer += "~t~t~t<culling>false</culling>~n"
		If mat.DepthWrite Then buffer += "~t~t~t<depth_write>true</depth_write>~n" Else buffer += "~t~t~t<depth_write>false</depth_write>~n"
		buffer += "~t~t</material>~n"
	Next
	buffer += "~t</materials>~n"
	
	'Export surfaces
	buffer += "~t<surfaces>~n"
	For Local i:Int = 0 Until mesh.NumSurfaces
		Local surf:Surface = mesh.GetSurface(i)
		buffer += "~t~t<surface>~n"
		buffer += "~t~t~t<material>Material #" + i + "</material>~n"
		buffer += "~t~t~t<indices>"
		For Local t:Int = 0 Until surf.NumTriangles
			buffer += surf.GetTriangleV0(t) + "," + surf.GetTriangleV1(t) + "," + surf.GetTriangleV2(t)
			If t < surf.NumTriangles - 1 Then buffer += ","
		Next
		buffer += "</indices>~n"
		buffer += "~t~t~t<coords>"
		For Local v:Int = 0 Until surf.NumVertices
			buffer += surf.GetVertexX(v) + "," + surf.GetVertexY(v) + "," + surf.GetVertexZ(v)
			If v < surf.NumVertices - 1 Then buffer += ","
		Next
		buffer += "</coords>~n"
		buffer += "~t~t~t<normals>"
		For Local v:Int = 0 Until surf.NumVertices
			buffer += surf.GetVertexNX(v) + "," + surf.GetVertexNY(v) + "," + surf.GetVertexNZ(v)
			If v < surf.NumVertices - 1 Then buffer += ","
		Next
		buffer += "</normals>~n"
		buffer += "~t~t~t<texcoords>"
		For Local v:Int = 0 Until surf.NumVertices
			buffer += surf.GetVertexU(v) + "," + surf.GetVertexV(v)
			If v < surf.NumVertices - 1 Then buffer += ","
		Next
		buffer += "</texcoords>~n"
		If exportAnimations
			buffer += "~t~t~t<bone_indices>"
			For Local v:Int = 0 Until surf.NumVertices
				buffer += surf.GetVertexBoneIndex(v, 0) + "," + surf.GetVertexBoneIndex(v, 1) + "," + surf.GetVertexBoneIndex(v, 2) + "," + surf.GetVertexBoneIndex(v, 3)
				If v < surf.NumVertices - 1 Then buffer += ","
			Next
			buffer += "</bone_indices>~n"
			buffer += "~t~t~t<bone_weights>"
			For Local v:Int = 0 Until surf.NumVertices
				buffer += surf.GetVertexBoneWeight(v, 0) + "," + surf.GetVertexBoneWeight(v, 1) + "," + surf.GetVertexBoneWeight(v, 2) + "," + surf.GetVertexBoneWeight(v, 3)
				If v < surf.NumVertices - 1 Then buffer += ","
			Next
			buffer += "</bone_weights>~n"
		End
		buffer += "~t~t</surface>~n"
	Next
	buffer += "~t</surfaces>~n"
	
	'Export last frame
	If exportAnimations Then buffer += "~t<last_frame>" + mesh.LastFrame + "</last_frame>~n"
	
	'Export bones
	If exportAnimations
		buffer += "~t<bones>~n"
		For Local i:Int = 0 Until mesh.NumBones
			Local bone:Bone = mesh.GetBone(i)
			buffer += "~t~t<bone>~n"
			buffer += "~t~t~t<name>" + bone.Name + "</name>~n"
			If bone.ParentIndex > -1 Then buffer += "~t~t~t<parent>" + mesh.GetBone(bone.ParentIndex).Name + "</parent>~n"
			buffer += "~t~t~t<inv_pose>"
			For Local m:Int = 0 Until 16
				buffer += bone.InversePoseMatrix.M[m]
				If m < 15 Then buffer += ","
			Next
			buffer += "</inv_pose>~n"
			If bone.NumPositionKeys > 0
				buffer += "~t~t~t<positions>"
				For Local j:Int = 0 Until bone.NumPositionKeys
					buffer += bone.GetPositionKeyFrame(j) + "," + bone.GetPositionKeyX(j) + "," + bone.GetPositionKeyY(j) + "," + bone.GetPositionKeyZ(j)
					If j < bone.NumPositionKeys - 1 Then buffer += ","
				Next
				buffer += "</positions>~n"
			End
			If bone.NumRotationKeys > 0
				buffer += "~t~t~t<rotations>"
				For Local j:Int = 0 Until bone.NumRotationKeys
					buffer += bone.GetRotationKeyFrame(j) + "," + bone.GetRotationKeyW(j) + "," + bone.GetRotationKeyX(j) + "," + bone.GetRotationKeyY(j) + "," + bone.GetRotationKeyZ(j)
					If j < bone.NumRotationKeys - 1 Then buffer += ","
				Next
				buffer += "</rotations>~n"
			End
			If bone.NumScaleKeys > 0
				buffer += "~t~t~t<scales>"
				For Local j:Int = 0 Until bone.NumScaleKeys
					buffer += bone.GetScaleKeyFrame(j) + "," + bone.GetScaleKeyX(j) + "," + bone.GetScaleKeyY(j) + "," + bone.GetScaleKeyZ(j)
					If j < bone.NumScaleKeys - 1 Then buffer += ","
				Next
				buffer += "</scales>~n"
			End
			buffer += "~t~t</bone>~n"
		Next
		buffer += "~t</bones>~n"
	End
	
	buffer += "</mesh>~n"
	SaveString(buffer, filename)
End