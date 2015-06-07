Strict

Class Vec3 Final
Public
	Field x#, y#, z#
	
	Function Create:Vec3(x# = 0, y# = 0, z# = 0)
		'DebugLog "Vec3.Create"
		Local v:Vec3 = New Vec3
		v.Set(x, y, z)
		Return v
	End
	
	Function Create:Vec3(other:Vec3)
		'DebugLog "Vec3.Create"
		Local v:Vec3 = New Vec3
		v.Set(other)
		Return v
	End
	
	Method Set:Void(x#, y#, z#)
		Self.x = x
		Self.y = y
		Self.z = z
	End
	
	Method Set:Void(other:Vec3)
		x = other.x
		y = other.y
		z = other.z
	End
	
	Method Sum:Void(other:Vec3)
		x += other.x
		y += other.y
		z += other.z
	End
	
	Method Sum:Void(x#, y#, z#)
		Self.x += x
		Self.y += y
		Self.z += z
	End
	
	Method Sub:Void(other:Vec3)
		x -= other.x
		y -= other.y
		z -= other.z
	End
	
	Method Sub:Void(x#, y#, z#)
		Self.x -= x
		Self.y -= y
		Self.z -= z
	End
	
	Method Mul:Void(other:Vec3)
		x *= other.x
		y *= other.y
		z *= other.z
	End
	
	Method Div:Void(other:Vec3)
		x /= other.x
		y /= other.y
		z /= other.z
	End
	
	Method Sum:Void(scalar#)
		x += scalar
		y += scalar
		z += scalar
	End
	
	Method Sub:Void(scalar#)
		x -= scalar
		y -= scalar
		z -= scalar
	End
	
	Method Mul:Void(scalar#)
		x *= scalar
		y *= scalar
		z *= scalar
	End
	
	Method Div:Void(scalar#)
		Mul(1/scalar)
	End
	
	Method Length#()
		Return Sqrt(x*x + y*y + z*z)
	End
	
	Method Normalize:Void()
		Div(Length())
	End
	
	Method Dot#(other:Vec3)
		Return x*other.x + y*other.y + z*other.z
	End
	
	Method Cross:Void(other:Vec3)
		Local newx# = y*other.z - z*other.y
		Local newy# = z*other.x - x*other.z
		Local newz# = x*other.y - y*other.x
		Set(newx, newy, newz)
	End
	
	Method Mix:Void(other:Vec3, t#)
		x += (other.x - x) * t;
		y += (other.y - y) * t;
		z += (other.z - z) * t;
	End
Private
	Method New()
	End
End




Class Quat Final
Public
	Field w#, x#, y#, z#
	
	Function Create:Quat(w# = 1, x# = 0, y# = 0, z# = 0)
		'DebugLog "Quat.Create"
		Local q:Quat = New Quat
		q.Set(w, x, y, z)
		Return q
	End
	
	Function Create:Quat(other:Quat)
		'DebugLog "Quat.Create"
		Local q:Quat = New Quat
		q.Set(other)
		Return q
	End
	
	Method Set:Void(w#, x#, y#, z#)
		Self.w = w
		Self.x = x
		Self.y = y
		Self.z = z
	End
	
	Method Set:Void(other:Quat)
		w = other.w
		x = other.x
		y = other.y
		z = other.z
	End
	
	Method SetAxis:Void(angle#, x#, y#, z#)
		angle *= 0.5
		Local sinAngle# = Sin(angle)
		Self.w = Cos(angle)
		Self.x = x * sinAngle
		Self.y = y * sinAngle
		Self.z = z * sinAngle
	End
	
	Method SetEuler:Void(x#, y#, z#)
		Local halfx# = x * 0.5
		Local halfy# = y * 0.5
		Local halfz# = z * 0.5
		Local sinyaw# = Sin(halfy)
		Local sinpitch# = Sin(halfx)
		Local sinroll# = Sin(halfz)
		Local cosyaw# = Cos(halfy)
		Local cospitch# = Cos(halfx)
		Local cosroll# = Cos(halfz)

		Self.w = cospitch * cosyaw * cosroll + sinpitch * sinyaw * sinroll
		Self.x = sinpitch * cosyaw * cosroll - cospitch * sinyaw * sinroll
		Self.y = cospitch * sinyaw * cosroll + sinpitch * cosyaw * sinroll
		Self.z = cospitch * cosyaw * sinroll - sinpitch * sinyaw * cosroll
	End
	
	Method Sum:Void(other:Quat)
		w += other.w
		x += other.x
		y += other.y
		z += other.z
	End
	
	Method Sub:Void(other:Quat)
		w -= other.w
		x -= other.x
		y -= other.y
		z -= other.z
	End
	
	Method Mul:Void(other:Quat)
		Local qw# = w
		Local qx# = x
		Local qy# = y
		Local qz# = z
		w = qw*other.w - qx*other.x - qy*other.y - qz*other.z
		x = qw*other.x + qx*other.w + qy*other.z - qz*other.y
		y = qw*other.y + qy*other.w + qz*other.x - qx*other.z
		z = qw*other.z + qz*other.w + qx*other.y - qy*other.x
	End
	
	Method Mul:Void(w#, x#, y#, z#)
		Local qw# = Self.w
		Local qx# = Self.x
		Local qy# = Self.y
		Local qz# = Self.z
		Self.w = qw*w - qx*x - qy*y - qz*z
		Self.x = qw*x + qx*w + qy*z - qz*y
		Self.y = qw*y + qy*w + qz*x - qx*z
		Self.z = qw*z + qz*w + qx*y - qy*x
	End
	
	Method Mul:Void(vec:Vec3)
		t1.Set(Self)
		t2.Set(0, vec.x, vec.y, vec.z)
		t3.Set(Self)
		t3.Conjugate()
		t1.Mul(t2)
		t1.Mul(t3)
		tv.Set(t1.x, t1.y, t1.z)
	End
	
	Method Mul:Void(x#, y#, z#)
		t1.Set(Self)
		t2.Set(0, x, y, z)
		t3.Set(Self)
		t3.Conjugate()
		t1.Mul(t2)
		t1.Mul(t3)
		tv.Set(t1.x, t1.y, t1.z)
	End
	
	Method Mul:Void(scalar#)
		w *= scalar
		x *= scalar
		y *= scalar
		z *= scalar
	End
	
	Method Div:Void(scalar#)
		Mul(1/scalar)
	End
	
	Method Normalize:Void()
		Local mag2# = x*x + y*y + z*z + w*w
		If mag2 > 0.00001 And Abs(mag2 - 1.0) > 0.00001
			Div(Sqrt(mag2))
		End
	End
	
	Method Conjugate:Void()
		x = -x
		y = -y
		z = -z
	End
	
	Method Angle#()
		Return ACos(w) * 2.0
	End
	
	Method CalcAxis:Void()
		Local len# = Sqrt(x*x + y*y + z*z)
		If len = 0.0 Then len = 0.00001
		tv.Set(x, y, z)
		tv.Div(len)
	End
	
	Method CalcEuler:Void()
		tv.Set(	ATan2(2 * (y*z + w*x), w*w - x*x - y*y + z*z),
				ASin(-2 * (x*z - w*y)),
				ATan2(2 * (x*y + w*z), w*w + x*x - y*y - z*z))
	End
	
	Method Lerp:Void(other:Quat, t#)
		t1.Set(other)
		t1.Mul(t)
		Self.Mul(1-t)
		Self.Sum(t1)
		Self.Normalize()
	End
	
	Method Slerp:Void(other:Quat, t#)
		t1.Set(other)
		Local dot# = Self.Dot(other)
		If dot < 0
			dot = -dot
			t1.Mul(-1)
		End

		If dot < 0.95
			Local angle# = ACos(dot)
			t1.Mul(Sin(angle*t))
			Self.Mul(Sin(angle*(1-t)))
			Self.Sum(t1)
			Self.Div(Sin(angle))
		Else
			Self.Lerp(t1, t)
		End
	End
	
	Method Dot#(other:Quat)
		Return w*other.w + x*other.x + y*other.y + z*other.z
	End
	
	Function ResultVector:Vec3()
		Return tv
	End
Private
	Method New()
	End
	
	'Temp quaternions used in some operations (to avoid allocations)
	Global t1:Quat = Quat.Create()
	Global t2:Quat = Quat.Create()
	Global t3:Quat = Quat.Create()
	
	'Temp vector used in some operations (to avoid allocations)
	Global tv:Vec3 = Vec3.Create()
End




Class Mat4 Final
Public
	Field m#[16]
	
	Function Create:Mat4()
		'DebugLog "Mat4.Create"
		Local m:Mat4 = New Mat4
		m.SetIdentity()
		Return m
	End
	
	Function Create:Mat4(other:Mat4)
		'DebugLog "Mat4.Create"
		Local m:Mat4 = New Mat4
		For Local i% = 0 Until 16
			m.m[i] = other.m[i]
		Next
		Return m
	End
	
	Function Create:Mat4(values#[])
		'DebugLog "Mat4.Create"
		Local m:Mat4 = New Mat4
		m.Set(values)
		Return m
	End
	
	Method Set:Void(other:Mat4)
		For Local i% = 0 Until 16
			m[i] = other.m[i]
		Next
	End
	
	Method Set:Void(m#[])
		For Local i% = 0 Until 16
			Self.m[i] = m[i]
		Next
	End
	
	Method SetIdentity:Void()
		For Local i% = 0 Until 16
			m[i] = 0
		Next
		m[0] = 1
		m[5] = 1
		m[10] = 1
		m[15] = 1
	End
	
	Method Mul:Void(other:Mat4)
		Mul(other.m)
	End
	
	Method Mul:Void(arr#[])
		For Local i% = 0 Until 4
			Local a0# = m[i]
			Local a1# = m[i+4]
			Local a2# = m[i+8]
			Local a3# = m[i+12]
			m[i] = a0*arr[0] + a1*arr[1] + a2*arr[2] + a3*arr[3]
			m[i+4] = a0*arr[4] + a1*arr[5] + a2*arr[6] + a3*arr[7]
			m[i+8] = a0*arr[8] + a1*arr[9] + a2*arr[10] + a3*arr[11]
			m[i+12] = a0*arr[12] + a1*arr[13] + a2*arr[14] + a3*arr[15]
		Next
	End
	
	Method Mul:Float(vec:Vec3, w#)
		Return Mul(vec.x, vec.y, vec.z, w)
	End
	
	Method Mul:Float(x#, y#, z#, w#)
		t1.SetIdentity()
		t1.SetTranslation(x, y, z)
		t1.m[15] = w
		t2.Set(Self)
		t2.Mul(t1)
		tv1.Set(t2.m[12], t2.m[13], t2.m[14])
		Return t2.m[15]
	End
	
	Method RC#(row%, column%)
		Return m[column*4 + row]
	End
	
	Method SetRC:Void(row%, column%, value#)
		m[column*4 + row] = value
	End
	
	Method Translate:Void(x#, y#, z#)
		t1.SetIdentity()
		t1.SetTranslation(x, y, z)
		Self.Mul(t1)
	End
	
	Method Rotate:Void(angle#, x#, y#, z#)
		t1.SetIdentity()
		t1.SetRotation(angle, x, y, z)
		Self.Mul(t1)
	End
	
	Method Scale:Void(x#, y#, z#)
		t1.SetIdentity()
		t1.SetScale(x, y, z)
		Self.Mul(t1)
	End
	
	Method Transpose:Void()
		t1.Set(Self)
		For Local row% = 0 Until 4
			For Local column% = 0 Until 4
				SetRC(row, column, t1.RC(column, row))
			Next
		Next
	End
	
	Method Invert:Void()		
		t1.Set(Self)
		m[ 0] =  t1.m[5] * t1.m[10] * t1.m[15] - t1.m[5] * t1.m[11] * t1.m[14] - t1.m[9] * t1.m[6] * t1.m[15] + t1.m[9] * t1.m[7] * t1.m[14] + t1.m[13] * t1.m[6] * t1.m[11] - t1.m[13] * t1.m[7] * t1.m[10];
		m[ 4] = -t1.m[4] * t1.m[10] * t1.m[15] + t1.m[4] * t1.m[11] * t1.m[14] + t1.m[8] * t1.m[6] * t1.m[15] - t1.m[8] * t1.m[7] * t1.m[14] - t1.m[12] * t1.m[6] * t1.m[11] + t1.m[12] * t1.m[7] * t1.m[10];
		m[ 8] =  t1.m[4] * t1.m[ 9] * t1.m[15] - t1.m[4] * t1.m[11] * t1.m[13] - t1.m[8] * t1.m[5] * t1.m[15] + t1.m[8] * t1.m[7] * t1.m[13] + t1.m[12] * t1.m[5] * t1.m[11] - t1.m[12] * t1.m[7] * t1.m[ 9];
		m[12] = -t1.m[4] * t1.m[ 9] * t1.m[14] + t1.m[4] * t1.m[10] * t1.m[13] + t1.m[8] * t1.m[5] * t1.m[14] - t1.m[8] * t1.m[6] * t1.m[13] - t1.m[12] * t1.m[5] * t1.m[10] + t1.m[12] * t1.m[6] * t1.m[ 9];
		m[ 1] = -t1.m[1] * t1.m[10] * t1.m[15] + t1.m[1] * t1.m[11] * t1.m[14] + t1.m[9] * t1.m[2] * t1.m[15] - t1.m[9] * t1.m[3] * t1.m[14] - t1.m[13] * t1.m[2] * t1.m[11] + t1.m[13] * t1.m[3] * t1.m[10];
		m[ 5] =  t1.m[0] * t1.m[10] * t1.m[15] - t1.m[0] * t1.m[11] * t1.m[14] - t1.m[8] * t1.m[2] * t1.m[15] + t1.m[8] * t1.m[3] * t1.m[14] + t1.m[12] * t1.m[2] * t1.m[11] - t1.m[12] * t1.m[3] * t1.m[10];
		m[ 9] = -t1.m[0] * t1.m[ 9] * t1.m[15] + t1.m[0] * t1.m[11] * t1.m[13] + t1.m[8] * t1.m[1] * t1.m[15] - t1.m[8] * t1.m[3] * t1.m[13] - t1.m[12] * t1.m[1] * t1.m[11] + t1.m[12] * t1.m[3] * t1.m[ 9];
		m[13] =  t1.m[0] * t1.m[ 9] * t1.m[14] - t1.m[0] * t1.m[10] * t1.m[13] - t1.m[8] * t1.m[1] * t1.m[14] + t1.m[8] * t1.m[2] * t1.m[13] + t1.m[12] * t1.m[1] * t1.m[10] - t1.m[12] * t1.m[2] * t1.m[ 9];
		m[ 2] =  t1.m[1] * t1.m[ 6] * t1.m[15] - t1.m[1] * t1.m[ 7] * t1.m[14] - t1.m[5] * t1.m[2] * t1.m[15] + t1.m[5] * t1.m[3] * t1.m[14] + t1.m[13] * t1.m[2] * t1.m[ 7] - t1.m[13] * t1.m[3] * t1.m[ 6];
		m[ 6] = -t1.m[0] * t1.m[ 6] * t1.m[15] + t1.m[0] * t1.m[ 7] * t1.m[14] + t1.m[4] * t1.m[2] * t1.m[15] - t1.m[4] * t1.m[3] * t1.m[14] - t1.m[12] * t1.m[2] * t1.m[ 7] + t1.m[12] * t1.m[3] * t1.m[ 6];
		m[10] =  t1.m[0] * t1.m[ 5] * t1.m[15] - t1.m[0] * t1.m[ 7] * t1.m[13] - t1.m[4] * t1.m[1] * t1.m[15] + t1.m[4] * t1.m[3] * t1.m[13] + t1.m[12] * t1.m[1] * t1.m[ 7] - t1.m[12] * t1.m[3] * t1.m[ 5];
		m[14] = -t1.m[0] * t1.m[ 5] * t1.m[14] + t1.m[0] * t1.m[ 6] * t1.m[13] + t1.m[4] * t1.m[1] * t1.m[14] - t1.m[4] * t1.m[2] * t1.m[13] - t1.m[12] * t1.m[1] * t1.m[ 6] + t1.m[12] * t1.m[2] * t1.m[ 5];
		m[ 3] = -t1.m[1] * t1.m[ 6] * t1.m[11] + t1.m[1] * t1.m[ 7] * t1.m[10] + t1.m[5] * t1.m[2] * t1.m[11] - t1.m[5] * t1.m[3] * t1.m[10] - t1.m[ 9] * t1.m[2] * t1.m[ 7] + t1.m[ 9] * t1.m[3] * t1.m[ 6];
		m[ 7] =  t1.m[0] * t1.m[ 6] * t1.m[11] - t1.m[0] * t1.m[ 7] * t1.m[10] - t1.m[4] * t1.m[2] * t1.m[11] + t1.m[4] * t1.m[3] * t1.m[10] + t1.m[ 8] * t1.m[2] * t1.m[ 7] - t1.m[ 8] * t1.m[3] * t1.m[ 6];
		m[11] = -t1.m[0] * t1.m[ 5] * t1.m[11] + t1.m[0] * t1.m[ 7] * t1.m[ 9] + t1.m[4] * t1.m[1] * t1.m[11] - t1.m[4] * t1.m[3] * t1.m[ 9] - t1.m[ 8] * t1.m[1] * t1.m[ 7] + t1.m[ 8] * t1.m[3] * t1.m[ 5];
		m[15] =  t1.m[0] * t1.m[ 5] * t1.m[10] - t1.m[0] * t1.m[ 6] * t1.m[ 9] - t1.m[4] * t1.m[1] * t1.m[10] + t1.m[4] * t1.m[2] * t1.m[ 9] + t1.m[ 8] * t1.m[1] * t1.m[ 6] - t1.m[ 8] * t1.m[2] * t1.m[ 5];
 
		Local det# = t1.m[0] * m[0] + t1.m[1] * m[4] + t1.m[2] * m[8] + t1.m[3] * m[12]
		If Abs(det) <= 0.00001 Then Return

		Local invdet# = 1.0 / det
		For Local i% = 0 Until 16
			m[i] *= invdet
		Next
	End
	
	Method SetOrtho:Void(left#, right#, bottom#, top#, near#, far#)
		Local a# = 2 / (right-left)
		Local b# = 2 / (top-bottom)
		Local c# = -2 / (far-near)
		Local tx# = -(right+left) / (right-left)
		Local ty# = -(top+bottom) / (top-bottom)
		Local tz# = -(far+near) / (far-near)
		Local m#[] = [a,0,0,0, 0,b,0,0, 0,0,c,0, tx,ty,tz,1]
		Set(m)
	End
	
	Method SetFrustum:Void(left#, right#, bottom#, top#, near#, far#)
		m[0]  = 2 * near / (right - left)
		m[5]  = 2 * near / (top - bottom)
		m[8]  = (right + left) / (right - left)
		m[9]  = (top + bottom) / (top - bottom)
		m[10] = -(far + near) / (far - near)
		m[11] = -1
		m[14] = -(2 * far * near) / (far - near)
		m[15] = 0
	End
	
	Method SetPerspective:Void(fovy#, aspect#, near#, far#)
		Local height# = near * Tan(fovy*0.5)
		Local width# = height * aspect
		SetFrustum(-width, width, -height, height, near, far)
	End
	
	Method LookAt:Void(eyex#, eyey#, eyez#, centerx#, centery#, centerz#, upx#, upy#, upz#)
		'Calculate z
		tv3.Set(eyex, eyey, eyez)
		tv3.Sub(centerx, centery, centerz)
		tv3.Normalize()
		
		'Calculate x
		tv1.Set(upx, upy, upz)
		tv1.Cross(tv3)
		
		'Calculate y
		tv2.Set(tv3)
		tv2.Cross(tv1)
		
		'Normalize x and y
		tv1.Normalize()
		tv2.Normalize()
		
		'Set matrix data
		m[0] = tv1.x; m[1] = tv2.x; m[2] = tv3.x; m[3] = 0
		m[4] = tv1.y; m[5] = tv2.y; m[6] = tv3.y; m[7] = 0
		m[8] = tv1.z; m[9] = tv2.z; m[10] = tv3.z; m[11] = 0
		m[12] = 0; m[13] = 0; m[14] = 0; m[15] = 1
		Translate(-eyex, -eyey, -eyez)
	End
	
	Function ResultVector:Vec3()
		Return tv1
	End
Private
	Method New()
	End
	
	Method SetTranslation:Void(x#, y#, z#)
		m[12] = x
		m[13] = y
		m[14] = z
	End
	
	Method SetRotation:Void(angle#, x#, y#, z#)
		Local c# = Cos(angle)
		Local s# = Sin(angle)
		Local xx# = x * x
		Local xy# = x * y
		Local xz# = x * z
		Local yy# = y * y
		Local yz# = y * z
		Local zz# = z * z

		m[0] = xx * (1 - c) + c
		m[1] = xy * (1 - c) + z * s
		m[2] = xz * (1 - c) - y * s
		m[4] = xy * (1 - c) - z * s
		m[5] = yy * (1 - c) + c
		m[6] = yz * (1 - c) + x * s
		m[8] = xz * (1 - c) + y * s
		m[9] = yz * (1 - c) - x * s
		m[10] = zz * (1 - c) + c
	End
	
	Method SetScale:Void(x#, y#, z#)
		m[0] = x
		m[5] = y
		m[10] = z
	End
	
	'Temp matrix used in some operations (to avoid allocations)
	Global t1:Mat4 = Mat4.Create()
	Global t2:Mat4 = Mat4.Create()
	
	'Temp vectors used in some operations (to avoid allocations)
	Global tv1:Vec3 = Vec3.Create()
	Global tv2:Vec3 = Vec3.Create()
	Global tv3:Vec3 = Vec3.Create()
End

