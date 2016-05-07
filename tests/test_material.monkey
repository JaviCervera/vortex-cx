Strict

Private
Import mojo.app
Import test
Import vortex

Public
Class MaterialTest Extends Test Final
	Method New()
		'Create matrices
		mProj = Mat4.Create()
		mView = Mat4.Create()
		mModel = Mat4.Create()
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Load cubic texture
		mTexture = Cache.GetTexture("sky_left.png", "sky_right.png", "sky_front.png", "sky_back.png", "sky_top.png", "sky_bottom.png")
		If mTexture = Null Then Print "Null tex"
		
		'Load sphere mesh
		mMesh = Cache.GetMesh("sphere.msh.xml")
		mMat = mMesh.GetSurface(0).GetMaterial()
		mMat.SetDiffuseColor(1, 0.6, 0.8)
		'mMat.SetDiffuseTexture(mTexture)
		mMat.SetReflectionTexture(mTexture)
		'mMat.SetRefractionTexture(mTexture)
		mMat.SetRefractionCoef(0.98)
		
		'Add mesh to RenderBatch
		mBatch.AddMesh(mMesh, mModel)
	End
	
	Method Init:Void()
		'Vortex.SetGlobalPixelLighting(True)
	
		'Prepare light
		Lighting.SetLightEnabled(0, True)
		Lighting.SetLightType(0, Lighting.DIRECTIONAL)
		Lighting.SetLightPosition(0, 1, 1, -1)
		Lighting.SetLightColor(0, 1, 1, 1)
		
		mEulerY = 0
	End
	
	Method Update:Void(deltaTime:Float)
		mEulerY += 32 * deltaTime
	End
	
	Method Draw:Void()
		Local posX:Float = Cos(mEulerY) * 4
		Local posZ:Float = Sin(mEulerY) * 4
	
		mProj.SetPerspective(45, Float(DeviceWidth()) / DeviceHeight(), 1, 10)
		mView.LookAt(posX, 0, posZ, 0, 0, 0, 0, 1, 0)
		mModel.SetTransform(0, 0, 0, 0, 0, 0, 1, 1, 1)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Renderer.SetEyePos(posX, 0, posZ)
		Lighting.Prepare(0.2, 0.2, 0.2)
		Renderer.ClearColorBuffer(0, 0, 0)
		Renderer.ClearDepthBuffer()
		mNumRenderCalls = mBatch.Render()
	End
	
	Method Finish:Void()
		'Vortex.SetGlobalPixelLighting(False)
		Lighting.SetLightEnabled(0, False)
	End
	
	Method GetNumRenderCalls:Int()
		Return mNumRenderCalls
	End
Private
	Field mProj				: Mat4
	Field mView				: Mat4
	Field mModel			: Mat4
	Field mMesh				: Mesh
	Field mMat				: Material
	Field mTexture			: Texture
	Field mBatch			: RenderBatch
	Field mEulerY			: Float
	Field mNumRenderCalls	: Int
End