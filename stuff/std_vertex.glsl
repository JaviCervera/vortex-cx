#ifdef GL_ES
precision highp int;
precision mediump float;
#endif

uniform mat4 mvp;
uniform mat4 modelView;
uniform mat4 normalMatrix;
uniform mat4 invView;
uniform int baseTexMode;
uniform bool useNormalTex;
uniform bool useReflectTex;
uniform bool useRefractTex;
uniform bool usePixelLighting;
uniform bool lightingEnabled;
uniform bool lightEnabled[MAX_LIGHTS];
uniform vec4 lightPos[MAX_LIGHTS];	// In viewer space !!!
uniform vec3 lightColor[MAX_LIGHTS];
uniform float lightAttenuation[MAX_LIGHTS];
uniform vec4 baseColor;
uniform vec3 ambient;
uniform int shininess;
uniform float refractCoef;
uniform bool fogEnabled;
uniform vec2 fogDist;
uniform bool skinned;
uniform mat4 bones[MAX_BONES];
attribute vec3 vpos;
attribute vec3 vnormal;
attribute vec3 vtangent;
attribute vec4 vcolor;
attribute vec2 vtex;
attribute vec4 vboneIndices;
attribute vec4 vboneWeights;
varying vec3 fpos;
varying vec3 fposNorm;
varying vec3 fnormal;
varying vec4 fcolor;
varying vec2 ftex;
varying vec3 fcombinedSpecular;
varying float fogFactor;
varying vec3 fcubeCoords;
varying vec3 freflectCoords;
varying vec3 frefractCoords;
varying mat3 tbnMatrix;

void CalcLighting(vec3 V, vec3 NV, vec3 N) {
	// Color that combines diffuse component of all lights
	vec3 combinedColor = ambient;

	// Compute all lights
	for ( int i = 0; i < MAX_LIGHTS; i++ ) {
		if ( lightEnabled[i] ) {
			vec3 L = vec3(lightPos[i]);
			float att = 1.0;

			// Point light
			if ( lightPos[i].w == 1.0 ) {
				L -= V;
				att = 1.0 / (1.0 + lightAttenuation[i]*length(L));
			}

			L = normalize(L);
			float NdotL = max(dot(N, L), 0.0);

			// Diffuse
			combinedColor += NdotL * lightColor[i] * att;

			// Specular
			if ( shininess > 0 && NdotL > 0.0 ) {
				vec3 H = normalize(L - NV);
				float NdotH = max(dot(N, H), 0.0);
				fcombinedSpecular += pow(NdotH, float(shininess)) * att;
			}
		}
	}

	fcolor *= vec4(clamp(combinedColor, 0.0, 1.0), 1.0);
}

void main() {
	vec4 vpos4 = vec4(vpos, 1);
	
	// Skinning of vertex
	if ( skinned ) {
		vec4 blendVertex = vec4(0,0,0,0);
		for ( int i = 0; i < 4; ++i )
			if ( int(vboneIndices[i]) > -1 ) blendVertex = ((bones[int(vboneIndices[i])] * vpos4) * vboneWeights[i]) + blendVertex;
		vpos4 = blendVertex;
	};
	
	// Vertex position in projection space
	gl_Position = mvp * vpos4;
	
	// Fragment color
	fcolor = baseColor * vcolor;

	// Fragment texture coords
	ftex = vtex;
	
	// Calculate vectors used in lighting and env mapping
	vec3 V;
	vec3 NV;
	vec3 N;
	if ( lightingEnabled || baseTexMode == 2 || useNormalTex || useReflectTex || useRefractTex || fogEnabled ) {
		// Calculate vertex in viewer space
		V = vec3(modelView * vpos4);

		if ( lightingEnabled || baseTexMode == 2 || useNormalTex || useReflectTex || useRefractTex ) {
			// Calculate normalized vertex coordinates
			NV = normalize(V);

			// Calculate normal in viewer space
			N = normalize(vec3(normalMatrix * vec4(vnormal, 0.0)));
		}
	}
	
	// Lighting
	if ( lightingEnabled ) {
		if ( !usePixelLighting && !useNormalTex ) {
			// Color that combines specular component of all lights
			fcombinedSpecular = vec3(0.0, 0.0, 0.0);
		
			// Calculate lighting
			CalcLighting(V, NV, N);
		} else {
			fpos = V;
			fposNorm = NV;
			fnormal = N;
		}
	}
	
	// Fog
	if ( fogEnabled ) fogFactor = clamp((fogDist[1] - abs(V.z)) / (fogDist[1] - fogDist[0]), 0.0, 1.0);
	
	// Cube mapping coordinates
	if ( baseTexMode == 2 || useReflectTex || useRefractTex ) {
		if ( baseTexMode == 2 ) fcubeCoords = vec3(invView * vec4(V, 1));
		if ( useReflectTex ) freflectCoords = normalize(vec3(invView * vec4(reflect(NV, N), 0)));
		if ( useRefractTex ) frefractCoords = normalize(vec3(invView * vec4(refract(NV, N, refractCoef), 0)));
	}
	
	// Calculate TBN matrix
	if ( lightingEnabled && useNormalTex ) {
		vec3 eyeTangent = normalize(vec3(normalMatrix * vec4(vtangent, 0)));
		vec3 eyeBitangent = cross(eyeTangent, N);
		tbnMatrix = mat3(eyeTangent, eyeBitangent, N);
	}
}