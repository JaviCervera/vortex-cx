Strict

Private
Import vortex

Public
Function CreateCube:Mesh()
	Local surf:Surface = Surface.Create()
	
	'Front face
	surf.AddVertex(-0.5,  0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5,  0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex(-0.5, -0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, -0.5, -0.5,  0, 0, -1,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddTriangle(0, 1, 2)
	surf.AddTriangle(3, 2, 1)
	
	'Back face
	surf.AddVertex( 0.5,  0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddVertex(-0.5,  0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddVertex( 0.5, -0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddVertex(-0.5, -0.5, 0.5,  0, 0, 1,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, -1, 0, 0)
	surf.AddTriangle(4, 5, 6)
	surf.AddTriangle(7, 6, 5)
	
	'Left face
	surf.AddVertex(-0.5,  0.5,  0.5,  -1, 0, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddVertex(-0.5,  0.5, -0.5,  -1, 0, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddVertex(-0.5, -0.5,  0.5,  -1, 0, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddVertex(-0.5, -0.5, -0.5,  -1, 0, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, -1)
	surf.AddTriangle(8, 9, 10)
	surf.AddTriangle(11, 10, 9)
	
	'Right face
	surf.AddVertex(0.5,  0.5, -0.5,  1, 0, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddVertex(0.5,  0.5,  0.5,  1, 0, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddVertex(0.5, -0.5, -0.5,  1, 0, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddVertex(0.5, -0.5,  0.5,  1, 0, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 0, 0, 1)
	surf.AddTriangle(12, 13, 14)
	surf.AddTriangle(15, 14, 13)
	
	'Top face
	surf.AddVertex(-0.5, 0.5,  0.5,  0, 1, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, 0.5,  0.5,  0, 1, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex(-0.5, 0.5, -0.5,  0, 1, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, 0.5, -0.5,  0, 1, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddTriangle(16, 17, 18)
	surf.AddTriangle(19, 18, 17)
	
	'Bottom face
	surf.AddVertex(-0.5, -0.5, -0.5,  0, -1, 0,  1, 1, 1, 1,  0, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, -0.5, -0.5,  0, -1, 0,  1, 1, 1, 1,  1, 0)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex(-0.5, -0.5,  0.5,  0, -1, 0,  1, 1, 1, 1,  0, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddVertex( 0.5, -0.5,  0.5,  0, -1, 0,  1, 1, 1, 1,  1, 1)
	surf.SetVertexTangent(surf.NumVertices-1, 1, 0, 0)
	surf.AddTriangle(20, 21, 22)
	surf.AddTriangle(23, 22, 21)

	'Create mesh with surface
	Local cube:Mesh = Mesh.Create()
	cube.AddSurface(surf)
	
	Return cube
End

Function RotateMesh:Void(mesh:Mesh, pitch:Float, yaw:Float, roll:Float)
	'Get rotation quaternion
	Local q:Quat = Quat.Create()
	q.SetEuler(pitch, yaw, roll)
	q.CalcAxis()
	
	'Define rotation matrix
	Local mat:Mat4 = Mat4.Create()
	mat.Rotate(q.Angle(), q.ResultVector().X, q.ResultVector().Y, q.ResultVector().Z)
	
	'Rotate all surfaces
	For Local i:Int = 0 Until mesh.NumSurfaces
		RotateSurface(mesh.GetSurface(i), mat)
	Next
	
	'Rotate all bones
	For Local i:Int = 0 Until mesh.NumBones
		RotateBone(mesh.GetBone(i), mat, q)
	Next
End

Function RotateSurface:Void(surf:Surface, mat:Mat4)	
	For Local i:Int = 0 Until surf.NumVertices
		mat.Mul(surf.GetVertexX(i), surf.GetVertexY(i), surf.GetVertexZ(i), 1)
		surf.SetVertexPosition(i, mat.ResultVector().X, mat.ResultVector().Y, mat.ResultVector().Z)
		mat.Mul(surf.GetVertexNX(i), surf.GetVertexNY(i), surf.GetVertexNZ(i), 1)
		surf.SetVertexNormal(i, mat.ResultVector().X, mat.ResultVector().Y, mat.ResultVector().Z)
		mat.Mul(surf.GetVertexTX(i), surf.GetVertexTY(i), surf.GetVertexTZ(i), 1)
		surf.SetVertexTangent(i, mat.ResultVector().X, mat.ResultVector().Y, mat.ResultVector().Z)
	Next
	
	surf.Rebuild()
End

Function RotateBone:Void(bone:Bone, mat:Mat4, q:Quat)
	'TODO
End
