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
		mSkyModel.SetTransform(0, 0, 0, 0, 0, 0, 10, 10, 10)
		
		'Create RenderBatch
		mBatch = RenderBatch.Create()
		
		'Load cubic texture
		mTexture = Cache.GetTexture("left.jpg", "right.jpg", "front.jpg", "back.jpg", "top.jpg", "bottom.jpg")
		
		'Load normal texture
		mNormalTex = Cache.GetTexture("t3_NORMALS.png")
		
		'Load box mesh
		mMesh = Cache.GetMesh("cube.msh.xml")
		
		'Create skybox
		mSkybox = Mesh.Create(mMesh)
		mSkybox.GetSurface(0).GetMaterial().SetCulling(False)
		mSkybox.GetSurface(0).GetMaterial().SetDepthWrite(False)
		mSkybox.GetSurface(0).GetMaterial().SetDiffuseTexture(mTexture)
		mSkybox.GetSurface(0).GetMaterial().SetShininess(0)
		
		mMat = mMesh.GetSurface(0).GetMaterial()
		'mMat.SetDiffuseTexture(mTexture)
		mMat.SetNormalTexture(mNormalTex)
		mMat.SetReflectionTexture(mTexture)
		'mMat.SetRefractionTexture(mTexture)
		mMat.SetRefractionCoef(0.98)
		
		'Add meshes to RenderBatch
		mBatch.AddMesh(mSkybox, mSkyModel)
		mBatch.AddMesh(mMesh, mModel)
	End
	
	Method Init:Void()
		'Prepare light
		Lighting.SetLightEnabled(0, True)
		Lighting.SetLightType(0, Lighting.DIRECTIONAL)
		Lighting.SetLightPosition(0, 1, 1, -1)
		Lighting.SetLightColor(0, 1, 0, 0)
		
		mEulerY = 0
	End
	
	Method Update:Void(deltaTime:Float)
		mEulerY += 32 * deltaTime
	End
	
	Method Draw:Void()
		Local posX:Float = Cos(mEulerY) * 2
		Local posZ:Float = -Sin(mEulerY) * 2
	
		mProj.SetPerspective(60, Float(DeviceWidth()) / DeviceHeight(), 1, 10)
		mView.LookAt(posX, 0, posZ, 0, 0, 0, 0, 1, 0)
		mModel.SetTransform(0, 0, 0, 0, 0, 0, 1, 1, 1)
		
		Renderer.Setup3D(0, 0, DeviceWidth(), DeviceHeight())
		Renderer.SetProjectionMatrix(mProj)
		Renderer.SetViewMatrix(mView)
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
	Field mMat				: Material
	Field mTexture			: Texture
	Field mNormalTex		: Texture
	Field mBatch			: RenderBatch
	Field mEulerY			: Float
	Field mNumRenderCalls	: Int
End