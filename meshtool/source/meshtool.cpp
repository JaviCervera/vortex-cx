#include <Importer.hpp>
#include <scene.h>
#include <postprocess.h>
#include "stringutils.h"

using namespace std;

static void ExportJSONMesh(const aiScene* scene, const string& filename);
static vector<const aiNode*> GetBones(const aiNode* bone);
static string MaterialName(const aiMaterial* mat);
static string TextureName(const aiMaterial* mat, unsigned int index);
static aiColor3D MaterialDiffuse(const aiMaterial* mat);
static float MaterialShininess(const aiMaterial* mat);

int firstFrame = 0;

int main(int argc, char* argv[]) {
	// Check arguments
	if ( argc < 2 ) {
		printf("Usage: meshconv [options] filename [filename...]\n");
		printf("Options:\n");
		printf("-firstFrame=<number>: Animations start at the specified frame number\n");
		return -1;
	}

	// Get filename
	string filename = argv[argc-1];

	// Get arguments
	for ( int i = 1; i < argc-1; i++ ) {
		if ( string(argv[i]).substr(0, 12) == "-firstFrame=" ) {
			firstFrame = NumberFromString<int>(SplitString(argv[i], '=')[1]);
		} else {
			printf("Warning: Unrecognized option '%s'\n", argv[i]);
		}
	}

	// Import options
	unsigned int flags = aiProcess_CalcTangentSpace | aiProcess_Triangulate | aiProcess_JoinIdenticalVertices | aiProcess_RemoveRedundantMaterials | aiProcess_GenSmoothNormals | aiProcess_MakeLeftHanded;

	// Import mesh
	printf("Importing '%s'... ", filename.c_str());
	Assimp::Importer importer;
	const aiScene* scene = importer.ReadFile(filename.c_str(), flags);
	if ( !scene ) {
		printf("\n%s\n", importer.GetErrorString());
		return -2;
	}

	// Export
	printf("done.\nExporting JSON mesh...\n");
	ExportJSONMesh(scene, StripExt(filename) + ".msh.json");
	printf("Done.\n");

	return 0;
}

static void ExportJSONMesh(const aiScene* scene, const string& filename) {
	// Open root table
	WriteString("{\n", filename, false);

	// Write brushes section
	WriteString("\t\"brushes\":\n\t[\n", filename);
	for ( unsigned int i = 0; i < scene->mNumMaterials; i++ ) {
		const aiMaterial* material = scene->mMaterials[i];

		// Write object for this brush
		WriteString("\t\t{\n", filename);

		// Write name
		printf("Writing brush '%s'...\n", MaterialName(material).c_str());
		WriteString("\t\t\t\"name\": \"" + MaterialName(material) + "\",\n", filename);

		// Write base color
		aiColor3D diffuse = MaterialDiffuse(material);
		WriteString("\t\t\t\"base_color\": [" + StringFromNumber(diffuse.r) + "," + StringFromNumber(diffuse.g) + "," + StringFromNumber(diffuse.b) + "],\n", filename);

		// Write base texture
		if ( TextureName(material, 0) != "" ) {
			WriteString("\t\t\t\"base_tex\": \"" + TextureName(material, 0) + "\",\n", filename);
		}

		// Write blend mode
		WriteString("\t\t\t\"blend\": \"alpha\",\n", filename);

		// Write flags
		WriteString("\t\t\t\"culling\": true,\n", filename);
		WriteString("\t\t\t\"depth_write\": true,\n", filename);

		// Write opacity
		WriteString("\t\t\t\"opacity\": 1.0,\n", filename);

		// Write shininess
		WriteString("\t\t\t\"shininess\": " + StringFromNumber(MaterialShininess(material)) + "\n", filename);

		// Close object for this material
		WriteString("\t\t}", filename);
		if ( i < scene->mNumMaterials - 1 ) WriteString(",", filename);
		WriteString("\n", filename);
	}
	WriteString("\t],\n", filename);

	// Write surfaces section
	WriteString("\t\"surfaces\":\n\t[\n", filename);
	for ( unsigned int i = 0; i < scene->mNumMeshes; i++ ) {
		const aiMesh* mesh = scene->mMeshes[i];

		// Write object for this surface
		printf("Writing surface %i...\n", i);
		WriteString("\t\t{\n", filename);

		// Write brush
		WriteString("\t\t\t\"brush\": \"" + MaterialName(scene->mMaterials[mesh->mMaterialIndex]) + "\",\n", filename);

		// Write indices
		string indices = "\t\t\t\"indices\": [";
		for ( unsigned int j = 0; j < mesh->mNumFaces; j++ ) {
			if ( j > 0 ) indices += ",";
			for ( unsigned int k = 0; k < mesh->mFaces[j].mNumIndices; k++ ) {
				if ( k > 0 ) indices += ",";
				indices += StringFromNumber(mesh->mFaces[j].mIndices[k]);
			}
			WriteString(indices, filename);
			indices = "";
		}
		indices += "],\n";
		WriteString(indices, filename);

		// Write coords
		string coords = "\t\t\t\"coords\": [";
		for ( unsigned int j = 0; j < mesh->mNumVertices; j++ ) {
			if ( j > 0 ) coords += ",";
			coords += StringFromNumber(mesh->mVertices[j].x) + "," + StringFromNumber(mesh->mVertices[j].z) + "," + StringFromNumber(mesh->mVertices[j].y);
			WriteString(coords, filename);
			coords = "";
		}
		coords += "]";
		if ( mesh->HasNormals() || mesh->HasVertexColors(0) || mesh->HasTextureCoords(0) ) coords += ",";
		coords += "\n";
		WriteString(coords, filename);

		// Write normals
		string normals = "\t\t\t\"normals\": [";
		for ( unsigned int j = 0; j < mesh->mNumVertices; j++ ) {
			if ( j > 0 ) normals += ",";
			normals += StringFromNumber(mesh->mNormals[j].x) + "," + StringFromNumber(mesh->mNormals[j].z) + "," + StringFromNumber(mesh->mNormals[j].y);
			WriteString(normals, filename);
			normals = "";
		}
		normals += "]";
		if ( mesh->HasVertexColors(0) || mesh->HasTextureCoords(0) ) normals += ",";
		normals += "\n";
		WriteString(normals, filename);

		// Write colors
		if ( mesh->HasVertexColors(0) ) {
			string colors = "\t\t\t\"colors\": [";
			for ( unsigned int j = 0; j < mesh->mNumVertices; j++ ) {
				if ( j > 0 ) colors += ",";
				colors += StringFromNumber(mesh->mColors[0][j].r) + "," + StringFromNumber(mesh->mColors[0][j].g) + "," + StringFromNumber(mesh->mColors[0][j].b) + "," + StringFromNumber(mesh->mColors[0][j].a);
				WriteString(colors, filename);
				colors = "";
			}
			colors += "]";
			if ( mesh->HasTextureCoords(0) ) coords += ",";
			colors += "\n";
			WriteString(colors, filename);
		}

		// Write texture coords
		if ( mesh->HasTextureCoords(0) ) {
			string texcoords = "\t\t\t\"texcoords\": [";
			for ( unsigned int j = 0; j < mesh->mNumVertices; j++ ) {
				float u = mesh->mTextureCoords[0][j].x;
				float v = mesh->mTextureCoords[0][j].y;
				if ( j > 0 ) texcoords += ",";
				texcoords += StringFromNumber(u) + "," + StringFromNumber(v);
				WriteString(texcoords, filename);
				texcoords = "";
			}
			texcoords += "]\n";
			WriteString(texcoords, filename);
		}

		// Close object for this surface
		WriteString("\t\t}", filename);
		if ( i < scene->mNumMeshes - 1 ) WriteString(",", filename);
		WriteString("\n", filename);
	}
	if ( scene->HasAnimations() )
		WriteString("\t],\n", filename);
	else
		WriteString("\t\n", filename);

	// Write animation info
	if ( scene->HasAnimations() ) {
		// Write sequences section
		int currentFrame = firstFrame;
		WriteString("\t\"sequences\":\n\t[\n",filename);
		for ( unsigned int i = 0; i < scene->mNumAnimations; i++ ) {
			// Get frame range
			const aiAnimation* anim = scene->mAnimations[i];

			// Write object for this sequence
			WriteString("\t\t{\n", filename);

			// Write name
			WriteString(string("\t\t\t\"name\": \"") + anim->mName.C_Str() + "\",\n", filename);

			// Write first frame
			if ( scene->mAnimations[0]->mNumChannels > 0 && scene->mAnimations[0]->mChannels[0]->mNumPositionKeys > 0 ) currentFrame += int(scene->mAnimations[0]->mChannels[0]->mPositionKeys[0].mTime);
			WriteString(string("\t\t\t\"first_frame\": ") + StringFromNumber(currentFrame) + ",\n", filename);

			// Write last frame
			currentFrame += int(anim->mDuration);
			WriteString(string("\t\t\t\"last_frame\": ") + StringFromNumber(currentFrame) + "\n", filename);
			currentFrame++;

			// Close object
			WriteString("\t\t}", filename);
			if ( i < scene->mNumAnimations - 1 ) WriteString(",", filename);
			WriteString("\n", filename);
		}
		WriteString("\t],\n", filename);

		// Write bones section
		vector<const aiNode*> bones = GetBones(scene->mRootNode);
		WriteString("\t\"bones\":\n\t[\n", filename);
		for ( unsigned int i = 0; i < bones.size(); i++ ) {
			const aiNode* bone = bones[i];

			// Write object for this node
			printf("Writing bone %i...\n", i);
			WriteString("\t\t{\n", filename);

			// Write name
			WriteString(string("\t\t\t\"name\": \"") + bone->mName.C_Str() + "\",\n", filename);

			// Write parent
			if ( bone->mParent ) {
				WriteString(string("\t\t\t\"parent\": \"") + bone->mParent->mName.C_Str() + "\",\n", filename);
			}

			// Write transform
			aiMatrix4x4 m = bone->mTransformation;
			aiVector3D pos;
			aiQuaternion rot;
			aiVector3D scale;
			m.Decompose(scale, rot, pos);
			WriteString(string("\t\t\t\"def_position\": [") + StringFromNumber(pos.x) + "," + StringFromNumber(pos.z) + "," + StringFromNumber(pos.y) + "],\n", filename);
			WriteString(string("\t\t\t\"def_rotation\": [") + StringFromNumber(-rot.w) + "," + StringFromNumber(rot.x) + "," + StringFromNumber(rot.z) + "," + StringFromNumber(rot.y) + "],\n", filename);
			WriteString(string("\t\t\t\"def_scale\": [") + StringFromNumber(scale.x) + "," + StringFromNumber(scale.z) + "," + StringFromNumber(scale.y) + "]", filename);
			if (bone->mNumMeshes > 0)
				WriteString(",\n", filename);
			else
				WriteString("\n", filename);

			// Write surfaces
			if ( bone->mNumMeshes > 0 ) {
				string surfaces = "\t\t\t\"surfaces\": [";
				for ( unsigned int j = 0; j < bone->mNumMeshes; j++ ) {
					surfaces += StringFromNumber(bone->mMeshes[j]);
					if ( j < bone->mNumMeshes-1 ) surfaces += ",";
				}
				surfaces += "]";
				WriteString(surfaces, filename);
			}

			// Write transforms for this bone
			bool hasTransforms = false;
			int startFrame = firstFrame;
			string positions = "\t\t\t\"position_frames\": [";
			string rotations = "\t\t\t\"rotation_frames\": [";
			string scales = "\t\t\t\"scale_frames\": [";
			for ( unsigned int j = 0; j < scene->mNumAnimations; j++ ) {
				const aiAnimation* anim = scene->mAnimations[j];

				// Search channel for this bone
				const aiNodeAnim* channel = nullptr;
				for ( unsigned int channelIndex = 0; channelIndex < anim->mNumChannels; channelIndex++ ) {
					if ( anim->mChannels[channelIndex]->mNodeName == bone->mName ) {
						channel = anim->mChannels[channelIndex];
						hasTransforms = true;
						break;
					}
				}

				// Write transforms
				if ( channel != nullptr ) {
					// Positions
					for ( unsigned int k = 0; k < channel->mNumPositionKeys; k++ ) {
						const aiVectorKey& pos = channel->mPositionKeys[k];
						positions += StringFromNumber(startFrame + int(pos.mTime)) + "," + StringFromNumber(pos.mValue.x) + "," + StringFromNumber(pos.mValue.z) + "," + StringFromNumber(pos.mValue.y) + ",";
					}

					// Rotations
					for ( unsigned int k = 0; k < channel->mNumRotationKeys; k++ ) {
						const aiQuatKey& pos = channel->mRotationKeys[k];
						rotations += StringFromNumber(startFrame + int(pos.mTime)) + "," + StringFromNumber(-pos.mValue.w) + "," + StringFromNumber(pos.mValue.x) + "," + StringFromNumber(pos.mValue.z) + "," + StringFromNumber(pos.mValue.y) + ",";
					}

					// Scales
					for ( unsigned int k = 0; k < channel->mNumScalingKeys; k++ ) {
						const aiVectorKey& pos = channel->mScalingKeys[k];
						scales += StringFromNumber(startFrame + int(pos.mTime)) + "," + StringFromNumber(pos.mValue.x) + "," + StringFromNumber(pos.mValue.z) + "," + StringFromNumber(pos.mValue.y) + ",";
					}
				}

				startFrame += int(anim->mDuration) + 1;
			}
			positions = positions.substr(0, positions.length()-1) + "],\n";
			rotations = rotations.substr(0, rotations.length()-1) + "],\n";
			scales = scales.substr(0, scales.length()-1) + "]\n";
			if ( hasTransforms ) {
				WriteString(",\n", filename);
				WriteString(positions, filename);
				WriteString(rotations, filename);
				WriteString(scales, filename);
			} else {
				WriteString("\n", filename);
			}

			// Close object for this bone
			WriteString("\t\t}", filename);
			if ( i < bones.size() - 1 ) WriteString(",", filename);
			WriteString("\n", filename);
		}
		WriteString("\t]\n", filename);
	}

	// Close root table
	WriteString("}\n", filename);
}

static vector<const aiNode*> GetBones(const aiNode* bone) {
	vector<const aiNode*> bones;
	bones.push_back(bone);
	for ( unsigned int i = 0; i < bone->mNumChildren; i++ ) {
		vector<const aiNode*> children = GetBones(bone->mChildren[i]);
		bones.insert(bones.end(), children.begin(), children.end());
	}
	return bones;
}

static string MaterialName(const aiMaterial* mat) {
	aiString name;

	// Get material name
	mat->Get(AI_MATKEY_NAME, name);

	// If material has no name, obtain it from first texture
	if ( name == aiString("") ) {
		return StripExt(TextureName(mat, 0));
	} else {
		return name.C_Str();
	}
}

static string TextureName(const aiMaterial* mat, unsigned int index) {
	aiString name;
	mat->Get(AI_MATKEY_TEXTURE(aiTextureType_DIFFUSE, index), name);
	return name.C_Str();
}

static aiColor3D MaterialDiffuse(const aiMaterial* mat) {
	aiColor3D color;
	mat->Get(AI_MATKEY_COLOR_DIFFUSE, color);
	return color;
}

static float MaterialShininess(const aiMaterial* mat) {
	float shininess;
	mat->Get(AI_MATKEY_SHININESS_STRENGTH, shininess);
	return shininess;
}
