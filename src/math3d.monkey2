Struct Vec3
	Field X:Float
	Field Y:Float
	Field Z:Float
	
	Method New(x:Float = 0, y:Float = 0, z:Float = 0)
		Set(x, y, z)
	End
	
	Method Set:Void(x:Float, y:Float, z:Float)
		X = x
		Y = y
		Z = z
	End
	
	Method Set:Void(other:Vec3)
		X = other.X
		Y = other.Y
		Z = other.Z
	End
	
	Method Sum:Vec3(other:Vec3)
		Return New Vec3(X + other.X, Y + other.Y, Z + other.Z)
	End
	
	Method Sum:Vec3(x:Float, y:Float, z:Float)
		Return New Vec3(X + x, Y + y, Z + z)
	End
	
	Method Sub:Vec3(other:Vec3)
		Return New Vec3(X - other.X, Y - other.Y, Z - other.Z)
	End
	
	Method Sub:Vec3(x:Float, y:Float, z:Float)
		Return New Vec3(X - x, Y - y, Z - z)
	End
	
	Method Mul:Vec3(other:Vec3)
		Return New Vec3(X * other.X, Y * other.Y, Z * other.Z)
	End
	
	Method Div:Vec3(other:Vec3)
		Return New Vec3(X / other.X, Y / other.Y, Z / other.Z)
	End
	
	Method Sum:Vec3(scalar:Float)
		Return New Vec3(X + scalar, Y + scalar, Z + scalar)
	End
	
	Method Sub:Vec3(scalar:Float)
		Return New Vec3(X - scalar, Y - scalar, Z - scalar)
	End
	
	Method Mul:Vec3(scalar:Float)
		Return New Vec3(X * scalar, Y * scalar, Z * scalar)
	End
	
	Method Div:Vec3(scalar:Float)
		Return Mul(1/scalar)
	End
	
	Method Length:Float()
		Return Sqrt(X*X + Y*Y + Z*Z)
	End
	
	Method Normalize:Vec3()
		Return Div(Length())
	End
	
	Method Dot:Float(other:Vec3)
		Return X*other.X + Y*other.Y + Z*other.Z
	End
	
	Method Cross:Vec3(other:Vec3)
		Return Cross(other.X, other.Y, other.Z)
	End
	
	Method Cross:Vec3(otherx:Float, othery:Float, otherz:Float)
		Local newx:Float = Y*otherz - Z*othery
		Local newy:Float = Z*otherx - X*otherz
		Local newz:Float = X*othery - Y*otherx
		Return New Vec3(newx, newy, newz)
	End
	
	Method Mix:Vec3(other:Vec3, t:Float)
		Local newx:Float = X + (other.X - X) * t
		Local newy:Float = Y + (other.Y - Y) * t
		Local newz:Float = Z + (other.Z - Z) * t
		Return New Vec3(newx, newy, newz)
	End
End




Struct Quat
	Field W:Float
	Field X:Float
	Field Y:Float
	Field Z:Float
	
	Method New(w:Float = 1, x:Float = 0, y:Float = 0, z:Float = 0)
		Set(w, x, y, z)
	End
	
	Method Set:Void(w:Float, x:Float, y:Float, z:Float)
		W = w
		X = x
		Y = y
		Z = z
	End
	
	Method Set:Void(other:Quat)
		W = other.W
		X = other.X
		Y = other.Y
		Z = other.Z
	End
	
	Function FromAxis:Quat(angle:Float, x:Float, y:Float, z:Float)
		Local q:Quat
		angle *= 0.5
		Local sinAngle:Float = Sin(angle)
		q.W = Cos(angle)
		q.X = x * sinAngle
		q.Y = y * sinAngle
		q.Z = z * sinAngle
		Return q
	End
	
	Method FromEuler:Quat(x:Float, y:Float, z:Float)
		Local halfx:Float = x * 0.5
		Local halfy:Float = y * 0.5
		Local halfz:Float = z * 0.5
		Local sinyaw:Float = Sin(halfy)
		Local sinpitch:Float = Sin(halfx)
		Local sinroll:Float = Sin(halfz)
		Local cosyaw:Float = Cos(halfy)
		Local cospitch:Float = Cos(halfx)
		Local cosroll:Float = Cos(halfz)

		Local q:Quat
		q.W = cospitch * cosyaw * cosroll + sinpitch * sinyaw * sinroll
		q.X = sinpitch * cosyaw * cosroll - cospitch * sinyaw * sinroll
		q.Y = cospitch * sinyaw * cosroll + sinpitch * cosyaw * sinroll
		q.Z = cospitch * cosyaw * sinroll - sinpitch * sinyaw * cosroll
		Return q
	End
	
	Method Sum:Quat(other:Quat)
		Return New Quat(W + other.W, X + other.X, Y + other.Y, Z + other.Z)
	End
	
	Method Sub:Quat(other:Quat)
		Return New Quat(W - other.W, X - other.X, Y - other.Y, Z - other.Z)
	End
	
	Method Mul:Quat(other:Quat)
		Local qw:Float = W
		Local qx:Float = X
		Local qy:Float = Y
		Local qz:Float = Z
		Local neww:Float = qw*other.W - qx*other.X - qy*other.Y - qz*other.Z
		Local newx:Float = qw*other.X + qx*other.W + qy*other.Z - qz*other.Y
		Local newy:Float = qw*other.Y + qy*other.W + qz*other.X - qx*other.Z
		Local newz:Float = qw*other.Z + qz*other.W + qx*other.Y - qy*other.X
		Return New Quat(neww, newx, newy, newz)
	End
	
	Method Mul:Quat(w:Float, x:Float, y:Float, z:Float)
		Local qw:Float = W
		Local qx:Float = X
		Local qy:Float = Y
		Local qz:Float = Z
		local neww:Float = qw*w - qx*x - qy*y - qz*z
		Local newx:Float = qw*x + qx*w + qy*z - qz*y
		Local newy:Float = qw*y + qy*w + qz*x - qx*z
		Local newz:Float = qw*z + qz*w + qx*y - qy*x
		Return New Quat(neww, newx, newy, newz)
	End
	
	Method Mul:Quat(vec:Vec3)
		Return New Mul(vec.X, vec.Y, vec.Z)
	End
	
	Method Mul:Vec3(x:Float, y:Float, z:Float)
		Local out:Quat = Self.Mul(Quat(0, x, y, z)).Mul(Self.Conjugate())
		Return New Vec3(out.X, out.Y, out.Z)
	End
	
	Method Mul:Quat(scalar:Float)
		Return New Quat(W * scalar, X * scalar, Y * scalar, Z * scalar)
	End
	
	Method Div:Quat(scalar:Float)
		Return Mul(1/scalar)
	End
	
	Method Normalize:Quat()
		Local mag2:Float = W*W + X*X + Y*Y + Z*Z
		If mag2 > 0.00001 And Abs(mag2 - 1.0) > 0.00001
			Return Div(Sqrt(mag2))
		Else
			Return Self
		End
	End
	
	Method Conjugate:Quat()
		Return New Quat(W, -X, -Y, -Z)
	End
	
	Method Angle:Float()
		Return ACos(W) * 2.0
	End
	
	Method Axis:Vec3()
		Local len:Float = Sqrt(X*X + Y*Y + Z*Z)
		If len = 0.0 Then len = 0.00001
		Return New Vec3(X, Y, Z).Div(len)
	End
	
	Method Euler:Vec3()
		Return New Vec3(	ATan2(2 * (Y*Z + W*X), W*W - X*X - Y*Y + Z*Z),
						ASin(-2 * (X*Z - W*Y)),
						ATan2(2 * (X*Y + W*Z), W*W + X*X - Y*Y - Z*Z))
	End
	
	Method Lerp:Quat(other:Quat, t:Float)
		Return Self.Mul(1-t).Sum(other.Mul(t)).Normalize()
	End
	
	Method Slerp:Quat(other:Quat, t:Float)
		Local dot:Float = Self.Dot(other)
		If dot < 0
			dot = -dot
			other = other.Mul(-1)
		End

		If dot < 0.95
			Local angle:Float = ACos(dot)
			other = other.Mul(Sin(angle*t))
			Return Self.Mul(Sin(angle*(1-t))).Sum(other).Div(Sin(angle))
		Else
			Return Self.Lerp(t1, t)
		End
	End
	
	Method Dot:Float(other:Quat)
		Return W*other.W + X*other.X + Y*other.Y + Z*other.Z
	End
End




Struct Mat4
Public
	Field M := New Float[16]
	
	Method New()
		SetIdentity()
	End
	
	Method New(values:Float[])
		Set(values)
	End
	
	Method Set:Void(other:Mat4)
		For Local i:Int = 0 Until 16
			M[i] = other.M[i]
		Next
	End
	
	Method Set:Void(m:Float[])
		For Local i:Int = 0 Until 16
			M[i] = m[i]
		Next
	End
	
	Method SetIdentity:Void()
		For Local i:Int = 0 Until 16
			M[i] = 0
		Next
		M[0] = 1
		M[5] = 1
		M[10] = 1
		M[15] = 1
	End
	
	Method Mul:Mat4(other:Mat4)
		Return Mul(other.M)
	End
	
	Method Mul:Mat4(arr:Float[])
		Local m:Mat4 = Self
		For Local i:Int = 0 Until 4
			Local a0:Float = M[i]
			Local a1:Float = M[i+4]
			Local a2:Float = M[i+8]
			Local a3:Float = M[i+12]
			m.M[i] = a0*arr[0] + a1*arr[1] + a2*arr[2] + a3*arr[3]
			m.M[i+4] = a0*arr[4] + a1*arr[5] + a2*arr[6] + a3*arr[7]
			m.M[i+8] = a0*arr[8] + a1*arr[9] + a2*arr[10] + a3*arr[11]
			m.M[i+12] = a0*arr[12] + a1*arr[13] + a2*arr[14] + a3*arr[15]
		Next
		Return m
	End
	
	Method Mul:Float(vec:Vec3, w:Float)
		Return Mul(vec.X, vec.Y, vec.Z, w)
	End
	
	'This method must also return translation's W somehow (var ptr?)
	Method Mul:Mat4(x:Float, y:Float, z:Float, w:Float)
		Local m:Mat4
		m.SetTranslation(x, y, z)
		m.M[15] = w
		m = Self.Mul(m)
		Return New Vec3(m.M[12], m.M[13], m.M[14])
		'Return m.M[15]
	End
	
	Method RC:Float(row:Int, column:Int)
		Return M[column*4 + row]
	End
	
	Method SetRC:Void(row:Int, column:Int, value:Float)
		M[column*4 + row] = value
	End
	
	Method Translate:Mat4(x:Float, y:Float, z:Float)
		Local m:Mat4
		m.SetTranslation(x, y, z)
		Return Self.Mul(m)
	End

	Method Rotate:Mat4(angle:Float, x:Float, y:Float, z:Float)
		Local m:Mat4
		m.SetRotation(angle, x, y, z)
		Return Self.Mul(m)
	End
	
	Method Scale:Mat4(x:Float, y:Float, z:Float)
		Local m:Mat4
		m.SetScale(x, y, z)
		Return Self.Mul(m)
	End
	
	Method Transpose:Mat4()
		Local m:Mat4
		For Local row:Int = 0 Until 4
			For Local column:Int = 0 Until 4
				m.SetRC(row, column, Self.RC(column, row))
			Next
		Next
		Return m
	End
	
	Method Invert:Mat4()		
		Local m:Mat4 = Self
		m.M[ 0] =  t1.M[5] * t1.M[10] * t1.M[15] - t1.M[5] * t1.M[11] * t1.M[14] - t1.M[9] * t1.M[6] * t1.M[15] + t1.M[9] * t1.M[7] * t1.M[14] + t1.M[13] * t1.M[6] * t1.M[11] - t1.M[13] * t1.M[7] * t1.M[10]
		m.M[ 4] = -t1.M[4] * t1.M[10] * t1.M[15] + t1.M[4] * t1.M[11] * t1.M[14] + t1.M[8] * t1.M[6] * t1.M[15] - t1.M[8] * t1.M[7] * t1.M[14] - t1.M[12] * t1.M[6] * t1.M[11] + t1.M[12] * t1.M[7] * t1.M[10]
		m.M[ 8] =  t1.M[4] * t1.M[ 9] * t1.M[15] - t1.M[4] * t1.M[11] * t1.M[13] - t1.M[8] * t1.M[5] * t1.M[15] + t1.M[8] * t1.M[7] * t1.M[13] + t1.M[12] * t1.M[5] * t1.M[11] - t1.M[12] * t1.M[7] * t1.M[ 9]
		m.M[12] = -t1.M[4] * t1.M[ 9] * t1.M[14] + t1.M[4] * t1.M[10] * t1.M[13] + t1.M[8] * t1.M[5] * t1.M[14] - t1.M[8] * t1.M[6] * t1.M[13] - t1.M[12] * t1.M[5] * t1.M[10] + t1.M[12] * t1.M[6] * t1.M[ 9]
		m.M[ 1] = -t1.M[1] * t1.M[10] * t1.M[15] + t1.M[1] * t1.M[11] * t1.M[14] + t1.M[9] * t1.M[2] * t1.M[15] - t1.M[9] * t1.M[3] * t1.M[14] - t1.M[13] * t1.M[2] * t1.M[11] + t1.M[13] * t1.M[3] * t1.M[10]
		m.M[ 5] =  t1.M[0] * t1.M[10] * t1.M[15] - t1.M[0] * t1.M[11] * t1.M[14] - t1.M[8] * t1.M[2] * t1.M[15] + t1.M[8] * t1.M[3] * t1.M[14] + t1.M[12] * t1.M[2] * t1.M[11] - t1.M[12] * t1.M[3] * t1.M[10]
		m.M[ 9] = -t1.M[0] * t1.M[ 9] * t1.M[15] + t1.M[0] * t1.M[11] * t1.M[13] + t1.M[8] * t1.M[1] * t1.M[15] - t1.M[8] * t1.M[3] * t1.M[13] - t1.M[12] * t1.M[1] * t1.M[11] + t1.M[12] * t1.M[3] * t1.M[ 9]
		m.M[13] =  t1.M[0] * t1.M[ 9] * t1.M[14] - t1.M[0] * t1.M[10] * t1.M[13] - t1.M[8] * t1.M[1] * t1.M[14] + t1.M[8] * t1.M[2] * t1.M[13] + t1.M[12] * t1.M[1] * t1.M[10] - t1.M[12] * t1.M[2] * t1.M[ 9]
		m.M[ 2] =  t1.M[1] * t1.M[ 6] * t1.M[15] - t1.M[1] * t1.M[ 7] * t1.M[14] - t1.M[5] * t1.M[2] * t1.M[15] + t1.M[5] * t1.M[3] * t1.M[14] + t1.M[13] * t1.M[2] * t1.M[ 7] - t1.M[13] * t1.M[3] * t1.M[ 6]
		m.M[ 6] = -t1.M[0] * t1.M[ 6] * t1.M[15] + t1.M[0] * t1.M[ 7] * t1.M[14] + t1.M[4] * t1.M[2] * t1.M[15] - t1.M[4] * t1.M[3] * t1.M[14] - t1.M[12] * t1.M[2] * t1.M[ 7] + t1.M[12] * t1.M[3] * t1.M[ 6]
		m.M[10] =  t1.M[0] * t1.M[ 5] * t1.M[15] - t1.M[0] * t1.M[ 7] * t1.M[13] - t1.M[4] * t1.M[1] * t1.M[15] + t1.M[4] * t1.M[3] * t1.M[13] + t1.M[12] * t1.M[1] * t1.M[ 7] - t1.M[12] * t1.M[3] * t1.M[ 5]
		m.M[14] = -t1.M[0] * t1.M[ 5] * t1.M[14] + t1.M[0] * t1.M[ 6] * t1.M[13] + t1.M[4] * t1.M[1] * t1.M[14] - t1.M[4] * t1.M[2] * t1.M[13] - t1.M[12] * t1.M[1] * t1.M[ 6] + t1.M[12] * t1.M[2] * t1.M[ 5]
		m.M[ 3] = -t1.M[1] * t1.M[ 6] * t1.M[11] + t1.M[1] * t1.M[ 7] * t1.M[10] + t1.M[5] * t1.M[2] * t1.M[11] - t1.M[5] * t1.M[3] * t1.M[10] - t1.M[ 9] * t1.M[2] * t1.M[ 7] + t1.M[ 9] * t1.M[3] * t1.M[ 6]
		m.M[ 7] =  t1.M[0] * t1.M[ 6] * t1.M[11] - t1.M[0] * t1.M[ 7] * t1.M[10] - t1.M[4] * t1.M[2] * t1.M[11] + t1.M[4] * t1.M[3] * t1.M[10] + t1.M[ 8] * t1.M[2] * t1.M[ 7] - t1.M[ 8] * t1.M[3] * t1.M[ 6]
		m.M[11] = -t1.M[0] * t1.M[ 5] * t1.M[11] + t1.M[0] * t1.M[ 7] * t1.M[ 9] + t1.M[4] * t1.M[1] * t1.M[11] - t1.M[4] * t1.M[3] * t1.M[ 9] - t1.M[ 8] * t1.M[1] * t1.M[ 7] + t1.M[ 8] * t1.M[3] * t1.M[ 5]
		m.M[15] =  t1.M[0] * t1.M[ 5] * t1.M[10] - t1.M[0] * t1.M[ 6] * t1.M[ 9] - t1.M[4] * t1.M[1] * t1.M[10] + t1.M[4] * t1.M[2] * t1.M[ 9] + t1.M[ 8] * t1.M[1] * t1.M[ 6] - t1.M[ 8] * t1.M[2] * t1.M[ 5]
 
		Local det:Float = M[0] * m.M[0] + M[1] * m.M[4] + M[2] * m.M[8] + M[3] * m.M[12]
		If Abs(det) <= 0.00001 Then Return New Mat4

		Local invdet:Float = 1.0 / det
		For Local i:Int = 0 Until 16
			m.M[i] *= invdet
		Next
		
		Return m
	End
	
	Function OrthoLH:Mat4(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float)
		Local a:Float = 2 / (right-left)
		Local b:Float = 2 / (top-bottom)
		Local c:Float = 2 / (far-near)
		Local tx:Float = (left+right) / (left-right)
		Local ty:Float = (top+bottom) / (bottom-top)
		Local tz:Float = (near+far) / (near-far)
		Return New Mat4(New Float[a,0,0,0, 0,b,0,0, 0,0,c,0, tx,ty,tz,1])
	End

	Function OrthoRH:Mat4(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float)
		Local a:Float = 2 / (right-left)
		Local b:Float = 2 / (top-bottom)
		Local c:Float = 2 / (near-far)
		Local tx:Float = (left+right) / (left-right)
		Local ty:Float = (top+bottom) / (bottom-top)
		Local tz:Float = (near+far) / (near-far)
		Return New Mat4(New Float[a,0,0,0, 0,b,0,0, 0,0,c,0, tx,ty,tz,1])
	End

	Function FrustumLH:Mat4(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float)
		Local m:Mat4
		m.M[0]  = 2 * near / (right - left)
		m.M[5]  = 2 * near / (top - bottom)
		m.M[8]  = (left + right) / (left - right)
		m.M[9]  = (bottom + top) / (bottom - top)
		m.M[10] = (far + near) / (far - near)
		m.M[11] = 1
		m.M[14] = (2 * near * far) / (near - far)
		m.M[15] = 0
		Return m
	End

	Function FrustumRH:Mat4(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float)
		Local m:Mat4
		m.M[0]  = 2 * near / (right - left)
		m.M[5]  = 2 * near / (top - bottom)
		m.M[8]  = (right + left) / (right - left)
		m.M[9]  = (top + bottom) / (top - bottom)
		m.M[10] = (far + near) / (near - far)
		m.M[11] = -1
		m.M[14] = (2 * near * far) / (near - far)
		m.M[15] = 0
		Return m
	End
	
	Function PerspectiveLH:Mat4(fovy:Float, aspect:Float, near:Float, far:Float)
		Local height:Float = near * Tan(fovy*0.5)
		Local width:Float = height * aspect
		return FrustumLH(-width, width, -height, height, near, far)
	End

	Function PerspectiveRH:Void(fovy:Float, aspect:Float, near:Float, far:Float)
		Local height:Float = near * Tan(fovy*0.5)
		Local width:Float = height * aspect
		Return FrustumRH(-width, width, -height, height, near, far)
	End
	
	Function LookAtLH:Mat4(eyex:Float, eyey:Float, eyez:Float, centerx:Float, centery:Float, centerz:Float, upx:Float, upy:Float, upz:Float)
		'Calculate z
		Local z:Vec3 = (New Vec3(centerx, centery, centerz)).Sub(New Vec3(eyex, eyey, eyez)).Normalize()
		
		'Calculate x
		Local x:Vec3 = (New Vec3(upx, upy, upz)).Cross(z).Normalize()
		
		'Calculate y
		Local y:Vec3 = (New Vec3(x)).Cross(z)
		
		'Set matrix data
		Local m:Mat4
		m.M[0] = tv1.X; M[1] = tv2.X; M[2] = tv3.X; M[3] = 0
		m.M[4] = tv1.Y; M[5] = tv2.Y; M[6] = tv3.Y; M[7] = 0
		m.M[8] = tv1.Z; M[9] = tv2.Z; M[10] = tv3.Z; M[11] = 0
		m.M[12] = 0; M[13] = 0; M[14] = 0; M[15] = 1
		Translate(-eyex, -eyey, -eyez)
	End

	Method LookAtRH:Void(eyex:Float, eyey:Float, eyez:Float, centerx:Float, centery:Float, centerz:Float, upx:Float, upy:Float, upz:Float)
		'Calculate z
		tv3.Set(eyex, eyey, eyez)
		tv3.Sub(centerx, centery, centerz)
		tv3.Normalize()
		
		'Calculate x
		tv1.Set(upx, upy, upz)
		tv1.Cross(tv3)
		tv1.Normalize()
		
		'Calculate y
		tv2.Set(tv3)
		tv2.Cross(tv1)
		
		'Set matrix data
		M[0] = tv1.X; M[1] = tv2.X; M[2] = tv3.X; M[3] = 0
		M[4] = tv1.Y; M[5] = tv2.Y; M[6] = tv3.Y; M[7] = 0
		M[8] = tv1.Z; M[9] = tv2.Z; M[10] = tv3.Z; M[11] = 0
		M[12] = 0; M[13] = 0; M[14] = 0; M[15] = 1
		Translate(-eyex, -eyey, -eyez)
	End
	
	Method SetTransform:Void(x:Float, y:Float, z:Float, rw:Float, rx:Float, ry:Float, rz:Float, sx:Float, sy:Float, sz:Float)
		q1.Set(rw, rx, ry, rz)
		q1.CalcAxis()
		SetIdentity()
		Translate(x, y, z)
		Rotate(q1.Angle(), q1.ResultVector().X, q1.ResultVector().Y, q1.ResultVector().Z)
		Scale(sx, sy, sz)
	End
	
	Method SetTransform:Void(x:Float, y:Float, z:Float, rx:Float, ry:Float, rz:Float, sx:Float, sy:Float, sz:Float)
		q1.SetEuler(rx, ry, rz)
		q1.CalcAxis()
		SetIdentity()
		Translate(x, y, z)
		Rotate(q1.Angle(), q1.ResultVector().X, q1.ResultVector().Y, q1.ResultVector().Z)
		Scale(sx, sy, sz)
	End
	
	Method SetBillboardTransform:Void(view:Mat4, x:Float, y:Float, z:Float, spin:Float, width:Float, height:Float, cylindrical:Bool = False)
		M[0] = view.M[0]
		M[1] = view.M[4]
		M[2] = view.M[8]
		M[3] = 0
		If cylindrical
			M[4] = 0
			M[5] = 1
			M[6] = 0
		Else
			M[4] = view.M[1]
			M[5] = view.M[5]
			M[6] = view.M[9]
		End
		M[7] = 0
		M[8] = view.M[2]
		M[9] = view.M[6]
		M[10] = view.M[10]
		M[11] = 0
		M[12] = x
		M[13] = y
		M[14] = z
		M[15] = 1

		Rotate(spin, 0, 0, 1)
		Scale(width, height, 1)
	End
Private
	Method SetTranslation:Void(x:Float, y:Float, z:Float)
		M[12] = x
		M[13] = y
		M[14] = z
	End

	Method SetRotation:Void(angle:Float, x:Float, y:Float, z:Float)
		Local c:Float = Cos(angle)
		Local s:Float = Sin(angle)
		Local xx:Float = x * x
		Local xy:Float = x * y
		Local xz:Float = x * z
		Local yy:Float = y * y
		Local yz:Float = y * z
		Local zz:Float = z * z

		M[0] = xx * (1 - c) + c
		M[1] = xy * (1 - c) + z * s
		M[2] = xz * (1 - c) - y * s
		M[4] = xy * (1 - c) - z * s
		M[5] = yy * (1 - c) + c
		M[6] = yz * (1 - c) + x * s
		M[8] = xz * (1 - c) + y * s
		M[9] = yz * (1 - c) - x * s
		M[10] = zz * (1 - c) + c
	End
	
	Method SetScale:Void(x:Float, y:Float, z:Float)
		M[0] = x
		M[5] = y
		M[10] = z
	End
End

