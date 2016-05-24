// TODO:
// - Export vertex colors

#define _IRR_STATIC_LIB_
#include "irrlicht/irrlicht.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#include "handedness.h"
#include "mesh.h"
#include "stringutils.h"
#include "glm/glm.hpp"
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/random.hpp"
#include "glm/gtc/type_ptr.hpp"
#include <iostream>

// NOTE: Change this to match engine handedness !!!
#define VORTEX_HANDEDNESS VORTEX_LH

using namespace irr;

// Forward declaration of functions
void SaveLightmaps(scene::IMesh* mesh);
scene::ISkinnedMesh::SJoint* FindParent(scene::ISkinnedMesh* mesh, const scene::ISkinnedMesh::SJoint* joint);;
std::vector<int> BoneIndicesForSurface(scene::ISkinnedMesh* mesh, u32 surface);
std::vector<float> BoneWeightsForSurface(scene::ISkinnedMesh* mesh, u32 surface);




irr::scene::IAnimatedMesh* CreateCube(irr::IrrlichtDevice* device) {
	scene::IAnimatedMesh* mesh = NULL;

	// create cube
	irr::scene::IMeshSceneNode* node = device->getSceneManager()->addCubeSceneNode(1);
	mesh = device->getSceneManager()->getMeshManipulator()->createAnimatedMesh(node->getMesh());
	node->removeAll();
	node->remove();

	// disable lighting on mesh
	if (mesh) {
		mesh->setMaterialFlag(video::EMF_LIGHTING, false);
	}
	return mesh;
}




irr::scene::IAnimatedMesh* CreateSphere(irr::IrrlichtDevice* device) {
	scene::IAnimatedMesh* mesh = NULL;

	// create sphere
	mesh = device->getSceneManager()->addSphereMesh("", 0.5, 64, 64);

	// disable lighting on mesh
	if (mesh) {
		mesh->setMaterialFlag(video::EMF_LIGHTING, false);
	}
	return mesh;
}




irr::scene::IAnimatedMesh* LoadMesh(irr::IrrlichtDevice* device, const std::string& filename) {
	scene::IAnimatedMesh* mesh = NULL;

	// add pk3 to file system
	if (ExtractExt(filename) == "pk3") device->getFileSystem()->addFileArchive(filename.c_str());

	// load mesh
	if (ExtractExt(filename) == "pk3") mesh = device->getSceneManager()->getMesh((StripExt(filename) + ".bsp").c_str());
	else mesh = device->getSceneManager()->getMesh(filename.c_str());

	// remove pk3 from file system
	if (ExtractExt(filename) == "pk3") device->getFileSystem()->removeFileArchive(filename.c_str());

	// disable lighting on mesh
	if (mesh) {
		mesh->setMaterialFlag(video::EMF_LIGHTING, false);
	}

	return mesh;
}




void SaveMesh(irr::IrrlichtDevice* device, scene::IAnimatedMesh* animMesh, const std::string& filename, bool exportMaterials, bool exportNormals, bool exportTangents, bool exportAnimations, bool exportLightmaps) {
	scene::IMesh* tangentMesh = NULL;
	if (exportTangents) tangentMesh = device->getSceneManager()->getMeshManipulator()->createMeshWithTangents(animMesh->getMesh(0));

	// Open mesh element
	std::string buffer = "<mesh>\n";

	// Brushes
	if (exportMaterials) {
		buffer += "\t<brushes>\n";

		// Diffuse
		for (u32 mb = 0; mb < animMesh->getMesh(0)->getMeshBufferCount(); ++mb) {
			const video::SMaterial& mat = animMesh->getMesh(0)->getMeshBuffer(mb)->getMaterial();
			buffer += "\t\t<brush>\n";
			buffer += "\t\t\t<name>Brush #" + StringFromNumber(mb) + "</name>\n";
			buffer += "\t\t\t<blend>alpha</blend>\n";
			if (mat.getTexture(0)) buffer += std::string("\t\t\t<base_tex>") + StripPath(mat.getTexture(0)->getName().getPath().c_str()) + "</base_tex>\n";
			buffer += "\t\t\t<base_color>" + StringFromNumber(mat.DiffuseColor.getRed() / 255.0f) + "," + StringFromNumber(mat.DiffuseColor.getGreen() / 255.0f) + "," + StringFromNumber(mat.DiffuseColor.getBlue() / 255.0f) + "</base_color>\n";
			buffer += "\t\t\t<opacity>" + StringFromNumber(mat.DiffuseColor.getAlpha() / 255.0f) + "</opacity>\n";
			buffer += "\t\t\t<shininess>" + StringFromNumber(mat.Shininess) + "</shininess>\n";
			buffer += std::string("\t\t\t<culling>") + (mat.BackfaceCulling ? "true" : "false") + "</culling>\n";
			buffer += std::string("\t\t\t<depth_write>") + (mat.ZWriteEnable ? "true" : "false") + "</depth_write>\n";
			buffer += "\t\t</brush>\n";
		}

		// Lightmap
		for (u32 mb = 0; mb < animMesh->getMesh(0)->getMeshBufferCount(); ++mb) {
			const video::SMaterial& mat = animMesh->getMesh(0)->getMeshBuffer(mb)->getMaterial();
			if (mat.getTexture(1)) {
				buffer += "\t\t<brush>\n";
				buffer += "\t\t\t<name>Brush #" + StringFromNumber(animMesh->getMesh(0)->getMeshBufferCount() + mb) + "</name>\n";
				buffer += "\t\t\t<blend>mul</blend>\n";
				buffer += std::string("\t\t\t<base_tex>") + mat.getTexture(1)->getName().getPath().c_str() + ".png</base_tex>\n";
				buffer += "\t\t</brush>\n";
			}
		}

		buffer += "\t</brushes>\n";
	}

	// Surfaces
	buffer += "\t<surfaces>\n";

	// Diffuse surfaces
	for (u32 mb = 0; mb < animMesh->getMesh(0)->getMeshBufferCount(); ++mb) {
		scene::IMeshBuffer* meshBuffer = animMesh->getMesh(0)->getMeshBuffer(mb);

		buffer += "\t\t<surface>\n";

		// Brush or texture
		if (exportMaterials) {
			buffer += "\t\t\t<brush>Brush #" + StringFromNumber(mb) + "</brush>\n";
		}
		else {
			if (meshBuffer->getMaterial().getTexture(0)) buffer += std::string("\t\t\t<base_tex>") + StripPath(meshBuffer->getMaterial().getTexture(0)->getName().getPath().c_str()) + "</base_tex>\n";
		}

		// Indices
		buffer += "\t\t\t<indices>";
		for (u32 i = 0; i < meshBuffer->getIndexCount(); i += 3) {
			if (i > 0) buffer += ",";
			if (VORTEX_HANDEDNESS == VORTEX_LH) {
				buffer += StringFromNumber(meshBuffer->getIndices()[i]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 1]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 2]);
			} else {
				buffer += StringFromNumber(meshBuffer->getIndices()[i]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 2]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 1]);
			}
		}
		buffer += "</indices>\n";

		// Vertices
		std::string coords = "\t\t\t<coords>";
		std::string normals = "\t\t\t<normals>";
		std::string tangents = "\t\t\t<tangents>";
		std::string texcoords = "\t\t\t<texcoords>";
		video::S3DVertexTangents* verticesTangents = static_cast<video::S3DVertexTangents*>(tangentMesh->getMeshBuffer(mb)->getVertices());
		for (u32 v = 0; v < meshBuffer->getVertexCount(); ++v) {
			if (v > 0) {
				coords += ",";
				if (exportNormals) normals += ",";
				if (exportTangents) tangents += ",";
				texcoords += ",";
			}
			if (VORTEX_HANDEDNESS == VORTEX_LH) {
				coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Y) + "," + StringFromNumber(meshBuffer->getPosition(v).Z);
				if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Y) + "," + StringFromNumber(meshBuffer->getNormal(v).Z);
				if (exportTangents) tangents += StringFromNumber(verticesTangents[v].Tangent.X) + "," + StringFromNumber(verticesTangents[v].Tangent.Y) + "," + StringFromNumber(verticesTangents[v].Tangent.Z);
				texcoords += StringFromNumber(meshBuffer->getTCoords(v).X) + "," + StringFromNumber(meshBuffer->getTCoords(v).Y);
			} else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
				coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Y) + "," + StringFromNumber(-meshBuffer->getPosition(v).Z);
				if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Y) + "," + StringFromNumber(-meshBuffer->getNormal(v).Z);
				if (exportTangents) tangents += StringFromNumber(verticesTangents[v].Tangent.X) + "," + StringFromNumber(verticesTangents[v].Tangent.Y) + "," + StringFromNumber(-verticesTangents[v].Tangent.Z);
				texcoords += StringFromNumber(meshBuffer->getTCoords(v).X) + "," + StringFromNumber(-meshBuffer->getTCoords(v).Y);
			} else {
				coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Z) + "," + StringFromNumber(meshBuffer->getPosition(v).Y);
				if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Z) + "," + StringFromNumber(meshBuffer->getNormal(v).Y);
				if (exportTangents) tangents += StringFromNumber(verticesTangents[v].Tangent.X) + "," + StringFromNumber(verticesTangents[v].Tangent.Z) + "," + StringFromNumber(verticesTangents[v].Tangent.Y);
				texcoords += StringFromNumber(meshBuffer->getTCoords(v).X) + "," + StringFromNumber(-meshBuffer->getTCoords(v).Y);
			}
		}
		coords += "</coords>\n";
		normals += "</normals>\n";
		tangents += "</tangents>\n";
		texcoords += "</texcoords>\n";
		buffer += coords;
		if (exportNormals) buffer += normals;
		if (exportTangents) buffer += tangents;
		/*if (meshBuffer->getMaterial().getTexture(0))*/ buffer += texcoords;
		std::vector<int> indices = BoneIndicesForSurface(dynamic_cast<scene::ISkinnedMesh*>(animMesh), mb);
		std::vector<float> weights = BoneWeightsForSurface(dynamic_cast<scene::ISkinnedMesh*>(animMesh), mb);
		if ( indices.size() > 0 && weights.size() > 0 ) {
			std::string indicesStr = "\t\t\t<bone_indices>";
			for ( size_t i = 0; i < indices.size(); ++i ) {
				if ( i > 0 ) indicesStr += ",";
				indicesStr += StringFromNumber(indices[i]);
			}
			indicesStr += "</bone_indices>\n";
			std::string weightsStr = "\t\t\t<bone_weights>";
			for ( size_t w = 0; w < weights.size(); ++w ) {
				if ( w > 0 ) weightsStr += ",";
				weightsStr += StringFromNumber(weights[w]);
			}
			weightsStr += "</bone_weights>\n";
			buffer += indicesStr;
			buffer += weightsStr;
		}

		buffer += "\t\t</surface>\n";
	}

	// Lightmap surfaces
	if (exportMaterials) {
		for (u32 mb = 0; mb < animMesh->getMesh(0)->getMeshBufferCount(); ++mb) {
			scene::IMeshBuffer* meshBuffer = animMesh->getMesh(0)->getMeshBuffer(mb);

			if (meshBuffer->getMaterial().getTexture(1)) {
				buffer += "\t\t<surface>\n";

				// Material or texture
				buffer += "\t\t\t<brush>Brush #" + StringFromNumber(animMesh->getMesh(0)->getMeshBufferCount() + mb) + "</brush>\n";

				// Indices
				buffer += "\t\t\t<indices>";
				for (u32 i = 0; i < meshBuffer->getIndexCount(); i += 3) {
					if (i > 0) buffer += ",";
					if (VORTEX_HANDEDNESS == VORTEX_LH) {
						buffer += StringFromNumber(meshBuffer->getIndices()[i]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 1]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 2]);
					} else {
						buffer += StringFromNumber(meshBuffer->getIndices()[i]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 2]) + "," + StringFromNumber(meshBuffer->getIndices()[i + 1]);
					}
				}
				buffer += "</indices>\n";

				// Vertices
				std::string coords = "\t\t\t<coords>";
				std::string normals = "\t\t\t<normals>";
				std::string texcoords = "\t\t\t<texcoords>";
				video::S3DVertex2TCoords* vertices2t = static_cast<video::S3DVertex2TCoords*>(meshBuffer->getVertices());
				for (u32 v = 0; v < meshBuffer->getVertexCount(); ++v) {
					if (v > 0) {
						coords += ",";
						if (exportNormals) normals += ",";
						texcoords += ",";
					}
					if (VORTEX_HANDEDNESS == VORTEX_LH) {
						coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Y) + "," + StringFromNumber(meshBuffer->getPosition(v).Z);
						if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Y) + "," + StringFromNumber(meshBuffer->getNormal(v).Z);
						texcoords += StringFromNumber(vertices2t[v].TCoords2.X) + "," + StringFromNumber(vertices2t[v].TCoords2.Y);
					} else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
						coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Y) + "," + StringFromNumber(-meshBuffer->getPosition(v).Z);
						if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Y) + "," + StringFromNumber(-meshBuffer->getNormal(v).Z);
						texcoords += StringFromNumber(vertices2t[v].TCoords2.X) + "," + StringFromNumber(-vertices2t[v].TCoords2.Y);
					} else {
						coords += StringFromNumber(meshBuffer->getPosition(v).X) + "," + StringFromNumber(meshBuffer->getPosition(v).Z) + "," + StringFromNumber(-meshBuffer->getPosition(v).Y);
						if (exportNormals) normals += StringFromNumber(meshBuffer->getNormal(v).X) + "," + StringFromNumber(meshBuffer->getNormal(v).Z) + "," + StringFromNumber(meshBuffer->getNormal(v).Y);
						texcoords += StringFromNumber(vertices2t[v].TCoords2.X) + "," + StringFromNumber(-vertices2t[v].TCoords2.Y);
					}
				}
				coords += "</coords>\n";
				normals += "</normals>\n";
				texcoords += "</texcoords>\n";
				buffer += coords;
				if (exportNormals) buffer += normals;
				buffer += texcoords;

				buffer += "\t\t</surface>\n";
			}
		}
	}

	buffer += "\t</surfaces>\n";

	// Export animations
	if (exportAnimations && animMesh->getMeshType() == scene::EAMT_SKINNED && animMesh->getFrameCount() > 1) {
		scene::ISkinnedMesh* skinnedMesh = dynamic_cast<scene::ISkinnedMesh*>(animMesh);

		// Export last frame id
		buffer += "\t<last_frame>" + StringFromNumber(skinnedMesh->getFrameCount()) + "</last_frame>\n";

		// Export bones
		buffer += "\t<bones>\n";
		const core::array<scene::ISkinnedMesh::SJoint*>& joints = skinnedMesh->getAllJoints();
		for (u32 i = 0; i < joints.size(); ++i) {
			buffer += "\t\t<bone>\n";

			buffer += std::string("\t\t\t<name>") + joints[i]->Name.c_str() + "</name>\n";

			scene::ISkinnedMesh::SJoint* parent = FindParent(skinnedMesh, joints[i]);
			if (parent) buffer += std::string("\t\t\t<parent>") + parent->Name.c_str() + "</parent>\n";

			core::vector3df irrPosition = joints[i]->LocalMatrix.getTranslation();
			core::vector3df irrRotation = joints[i]->LocalMatrix.getRotationDegrees();
			core::vector3df irrScale = joints[i]->LocalMatrix.getScale();
			glm::quat rotation(glm::radians(glm::vec3(irrRotation.X, irrRotation.Y, irrRotation.Z)));
			if (VORTEX_HANDEDNESS == VORTEX_LH) {
				buffer += "\t\t\t<def_position>" + StringFromNumber(irrPosition.X) + "," + StringFromNumber(irrPosition.Y) + "," + StringFromNumber(irrPosition.Z) + "</def_position>\n";
				buffer += "\t\t\t<def_rotation>" + StringFromNumber(rotation.w) + "," + StringFromNumber(rotation.x) + "," + StringFromNumber(rotation.y) + "," + StringFromNumber(rotation.z) + "</def_rotation>\n";
				buffer += "\t\t\t<def_scale>" + StringFromNumber(irrScale.X) + "," + StringFromNumber(irrScale.Y) + "," + StringFromNumber(irrScale.Z) + "</def_scale>\n";
			} else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
				rotation = glm::quat(glm::radians(glm::vec3(-irrRotation.X, -irrRotation.Y, -irrRotation.Z)));
				buffer += "\t\t\t<def_position>" + StringFromNumber(irrPosition.X) + "," + StringFromNumber(irrPosition.Y) + "," + StringFromNumber(-irrPosition.Z) + "</def_position>\n";
				buffer += "\t\t\t<def_rotation>" + StringFromNumber(rotation.w) + "," + StringFromNumber(rotation.x) + "," + StringFromNumber(rotation.y) + "," + StringFromNumber(rotation.z) + "</def_rotation>\n";
				buffer += "\t\t\t<def_scale>" + StringFromNumber(irrScale.X) + "," + StringFromNumber(irrScale.Y) + "," + StringFromNumber(irrScale.Z) + "</def_scale>\n";
			} else {
				buffer += "\t\t\t<def_position>" + StringFromNumber(irrPosition.X) + "," + StringFromNumber(irrPosition.Z) + "," + StringFromNumber(irrPosition.Y) + "</def_position>\n";
				buffer += "\t\t\t<def_rotation>" + StringFromNumber(-rotation.w) + "," + StringFromNumber(rotation.x) + "," + StringFromNumber(rotation.y) + "," + StringFromNumber(rotation.z) + "</def_rotation>\n";
				buffer += "\t\t\t<def_scale>" + StringFromNumber(irrScale.X) + "," + StringFromNumber(irrScale.Z) + "," + StringFromNumber(irrScale.Y) + "</def_scale>\n";
			}

			if (joints[i]->AttachedMeshes.size() > 0) {
				buffer += "\t\t\t<surfaces>";
				for (u32 j = 0; j < joints[i]->AttachedMeshes.size(); ++j) {
					buffer += StringFromNumber(joints[i]->AttachedMeshes[j]);
					if (j < joints[i]->AttachedMeshes.size() - 1) buffer + ",";
				}
				buffer += "</surfaces>\n";
			}

			if (joints[i]->PositionKeys.size() > 0) {
				buffer += "\t\t\t<positions>";
				for (u32 j = 0; j < joints[i]->PositionKeys.size(); ++j) {
					if (VORTEX_HANDEDNESS == VORTEX_LH) {
						buffer += StringFromNumber(int(joints[i]->PositionKeys[j].frame)) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.X) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Y) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Z);
					} else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
						buffer += StringFromNumber(int(joints[i]->PositionKeys[j].frame)) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.X) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Y) + "," + StringFromNumber(-joints[i]->PositionKeys[j].position.Z);
					} else {
						buffer += StringFromNumber(int(joints[i]->PositionKeys[j].frame)) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.X) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Z) + "," + StringFromNumber(joints[i]->PositionKeys[j].position.Y);
					}
					if (j < joints[i]->PositionKeys.size() - 1) buffer += ",";
				}
				buffer += "</positions>\n";
			}
			else if (joints[i]->RotationKeys.size() > 0 || joints[i]->ScaleKeys.size() > 0) {
				buffer += "\t\t\t<positions>0,0,0,0</positions>\n";
			}

			if (joints[i]->RotationKeys.size() > 0) {
				buffer += "\t\t\t<rotations>";
				for (u32 j = 0; j < joints[i]->RotationKeys.size(); ++j) {
					if (VORTEX_HANDEDNESS == VORTEX_LH) {
						buffer += StringFromNumber(int(joints[i]->RotationKeys[j].frame)) + "," + StringFromNumber(-joints[i]->RotationKeys[j].rotation.W) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.X) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Y) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Z);
					} else if (VORTEX_HANDEDNESS == VORTEX_RH_Y) {
						buffer += StringFromNumber(int(joints[i]->RotationKeys[j].frame)) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.W) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.X) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Y) + "," + StringFromNumber(-joints[i]->RotationKeys[j].rotation.Z);
					} else {
						buffer += StringFromNumber(int(joints[i]->RotationKeys[j].frame)) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.W) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.X) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Z) + "," + StringFromNumber(joints[i]->RotationKeys[j].rotation.Y);
					}
					if (j < joints[i]->RotationKeys.size() - 1) buffer += ",";
				}
				buffer += "</rotations>\n";
			}
			else if (joints[i]->PositionKeys.size() > 0 || joints[i]->ScaleKeys.size() > 0) {
				buffer += "\t\t\t<rotations>0,1,0,0,0</rotations>\n";
			}

			if (joints[i]->ScaleKeys.size() > 0) {
				buffer += "\t\t\t<scales>";
				for (u32 j = 0; j < joints[i]->ScaleKeys.size(); ++j) {
					if (VORTEX_HANDEDNESS == VORTEX_RH_Z) {
						buffer += StringFromNumber(int(joints[i]->ScaleKeys[j].frame)) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.X) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Z) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Y);
					} else {
						buffer += StringFromNumber(int(joints[i]->ScaleKeys[j].frame)) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.X) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Y) + "," + StringFromNumber(joints[i]->ScaleKeys[j].scale.Z);
					}
					if (j < joints[i]->ScaleKeys.size() - 1) buffer += ",";
				}
				buffer += "</scales>\n";
			}
			else if (joints[i]->PositionKeys.size() > 0 || joints[i]->RotationKeys.size() > 0) {
				buffer += "\t\t\t<scales>0,1,1,1</scales>\n";
			}

			buffer += "\t\t</bone>\n";
		}
		buffer += "\t</bones>\n";
	}

	// Close mesh element and save
	buffer += "</mesh>\n";
	WriteString(buffer, filename, false);

	// Save lightmaps
	if (exportLightmaps) SaveLightmaps(animMesh->getMesh(0));
}

void SaveLightmaps(scene::IMesh* mesh) {
	for (u32 mb = 0; mb < mesh->getMeshBufferCount(); ++mb) {
		scene::IMeshBuffer* meshBuffer = mesh->getMeshBuffer(mb);
		video::ITexture* tex = meshBuffer->getMaterial().getTexture(1);
		if (tex) {
			// Copy buffer of pixels and swap red and blue
			u32 size = tex->getSize().Width * tex->getSize().Height * 4;
			u8* pixels = static_cast<u8*>(malloc(size));
			memcpy(pixels, tex->lock(video::ETLM_READ_ONLY), size);
			tex->unlock();
			for (u32 y = 0; y < tex->getSize().Height; ++y) {
				for (u32 x = 0; x < tex->getSize().Width; ++x) {
					u8 c = pixels[(y*tex->getSize().Width + x) * 4 + 0];
					pixels[(y*tex->getSize().Width + x) * 4 + 0] = pixels[(y*tex->getSize().Width + x) * 4 + 2];
					pixels[(y*tex->getSize().Width + x) * 4 + 2] = c;
				}
			}

			// Write lightmap
			stbi_write_png((std::string(tex->getName().getPath().c_str()) + ".png").c_str(), tex->getSize().Width, tex->getSize().Height, 4, pixels, 0);

			// Free buffer
			free(pixels);
		}
	}
}

scene::ISkinnedMesh::SJoint* FindParent(scene::ISkinnedMesh* mesh, const scene::ISkinnedMesh::SJoint* joint) {
	for (u32 i = 0; i < mesh->getJointCount(); ++i) {
		for (u32 j = 0; j < mesh->getAllJoints()[i]->Children.size(); ++j) {
			if (mesh->getAllJoints()[i]->Children[j]->Name == joint->Name) {
				return mesh->getAllJoints()[i];
			}
		}
	}
	return NULL;
}

std::vector<int> BoneIndicesForSurface(scene::ISkinnedMesh* mesh, u32 surface) {
	if ( !mesh ) return std::vector<int>();
	bool indicesFound = false;
	std::vector<int> indices(mesh->getMeshBuffer(surface)->getVertexCount() * 4, -1);
	for (u32 i = 0; i < mesh->getJointCount(); ++i) {
		for (u32 j = 0; j < mesh->getAllJoints()[i]->Weights.size(); ++j) {
			if (mesh->getAllJoints()[i]->Weights[j].buffer_id == surface) {
				indicesFound = true;
				u32 vertexId = mesh->getAllJoints()[i]->Weights[j].vertex_id;
				if ( indices[vertexId*4] == -1 ) indices[vertexId*4] = i;
				else if ( indices[vertexId*4 + 1] == -1 ) indices[vertexId*4 + 1] = i;
				else if ( indices[vertexId*4 + 2] == -1 ) indices[vertexId*4 + 2] = i;
				else if ( indices[vertexId*4 + 3] == -1 ) indices[vertexId*4 + 3] = i;
			}
		}
	}
	if ( indicesFound ) return indices;
	else return std::vector<int>();
}

std::vector<float> BoneWeightsForSurface(scene::ISkinnedMesh* mesh, u32 surface) {
	if ( !mesh ) return std::vector<float>();
	bool weightsFound = false;
	std::vector<float> weights(mesh->getMeshBuffer(surface)->getVertexCount() * 4, -1);
	for (u32 i = 0; i < mesh->getJointCount(); ++i) {
		for (u32 j = 0; j < mesh->getAllJoints()[i]->Weights.size(); ++j) {
			if (mesh->getAllJoints()[i]->Weights[j].buffer_id == surface) {
				weightsFound = true;
				u32 vertexId = mesh->getAllJoints()[i]->Weights[j].vertex_id;
				if ( weights[vertexId*4] == -1 ) weights[vertexId*4] = mesh->getAllJoints()[i]->Weights[j].strength;
				else if ( weights[vertexId*4 + 1] == -1 ) weights[vertexId*4 + 1] = mesh->getAllJoints()[i]->Weights[j].strength;
				else if ( weights[vertexId*4 + 2] == -1 ) weights[vertexId*4 + 2] = mesh->getAllJoints()[i]->Weights[j].strength;
				else if ( weights[vertexId*4 + 3] == -1 ) weights[vertexId*4 + 3] = mesh->getAllJoints()[i]->Weights[j].strength;
			}
		}
	}

	for ( size_t i = 0; i < weights.size(); ++i ) {
		if ( weights[i] == -1.0f ) weights[i] = 0.0f;
	}

	if ( weightsFound ) return weights;
	else return std::vector<float>();
}
