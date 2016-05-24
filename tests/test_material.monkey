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
		mSkyModel = Mat4.Create()
		mModel.SetTransform(0, 0, 0, 0, 0, 0, 1, 1, 1)
		mSkyModel.SetTransform(0, 0, 0, 0, 0, 0, -4, -4, -4)
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Load cubic texture
		mTexture = Cache.GetTexture("left.jpg", "right.jpg", "front.jpg", "back.jpg", "top.jpg", "bottom.jpg")
		
		'Load normal texture
		mNormalTex = Cache.GetTexture("t3_NORMALS.png")
		
		'Load box mesh
		mMesh = Cache.GetMesh("cube.msh.xml")
		Local mat:Material = mMesh.GetSurface(0).GetMaterial()
		'mat.SetDiffuseTexture(Null)
		mat.SetNormalTexture(mNormalTex)
		'mat.SetReflectionTexture(mTexture)
		'mat.SetRefractionTexture(mTexture)
		'mat.SetRefractionCoef(0.98)
		
		'Create skybox
		mSkybox = Mesh.Create(mMesh)
		mat = mSkybox.GetSurface(0).GetMaterial()
		mat.Set(Material.Create(mTexture))
		mat.SetDepthWrite(False)
		
		'Add meshes to RenderBatch
		mBatch.AddMesh(mSkybox, mSkyModel)
		mBatch.AddMesh(mMesh, mModel)
	End
	
	Method Init:Void()
		'Prepare light
		Lighting.SetLightEnabled(0, True)
		Lighting.SetLightType(0, Lighting.POINT)
		Lighting.SetLightAttenuation(0, 0.05)
		Lighting.SetLightColor(0, 1, 1, 1)
		
		mEulerY = 0
	End
	
	Method Update:Void(deltaTime:Float)
		mEulerY += 32 * deltaTime
	End
	
	Method Draw:Void()
		Local posX:Float = Cos(mEulerY) * 2
		Local posZ:Float = -Sin(mEulerY) * 2
	
		mProj.SetPerspective(75, Float(DeviceWidth()) / DeviceHeight(), 1, 10)
		mView.LookAt(posX, 0, posZ, 0, 0, 0, 0, 1, 0)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
		Lighting.SetLightPosition(0, posX, 0, posZ)
		Lighting.Prepare(1, 1, 1)
		Renderer.ClearColorBuffer(0, 0, 0)
		Renderer.ClearDepthBuffer()
		mNumRenderCalls = mBatch.Render()
	End
	
	Method Finish:Void()
		Lighting.SetLightEnabled(0, False)
	End
	
	Method GetNumRenderCalls:Int()
		Return mNumRenderCalls
	End
Private
	Field mProj				: Mat4
	Field mView				: Mat4
	Field mModel			: Mat4
	Field mSkyModel			: Mat4
	Field mMesh				: Mesh
	Field mSkybox			: Mesh
	Field mTexture			: Texture
	Field mNormalTex		: Texture
	Field mBatch			: RenderBatch
	Field mEulerY			: Float
	Field mNumRenderCalls	: Int
End