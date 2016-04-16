#ifdef GL_ES
precision highp int;
precision mediump float;
#endif

uniform mat4 mvp;
uniform mat4 modelView;
uniform mat4 normalMatrix;
uniform bool lightingEnabled;
uniform bool lightEnabled[MAX_LIGHTS];
uniform vec4 lightPos[MAX_LIGHTS];	// In viewer space !!!
uniform vec3 lightColor[MAX_LIGHTS];
uniform float lightAttenuation[MAX_LIGHTS];
uniform vec4 baseColor;
uniform vec3 ambient;
uniform int shininess;
uniform bool fogEnabled;
uniform vec2 fogDist;
uniform bool skinned;
uniform mat4 bones[MAX_BONES];
attribute vec3 vpos;
attribute vec3 vnormal;
attribute vec4 vcolor;
attribute vec2 vtex;
attribute vec4 vboneIndices;
attribute vec4 vboneWeights;
varying vec4 fcolor;
varying vec2 ftex;
varying vec3 combinedSpecular;
varying float fogFactor;

void main() {
	vec4 vpos4 = vec4(vpos, 1);
	
	// Skinning of vertex
	if ( skinned ) {
		vec4 blendVertex = vec4(0,0,0,0);
		for ( int i = 0; i < 4; ++i )
			if ( int(vboneIndices[i]) > -1 ) blendVertex = ((bones[int(vboneIndices[i])] * vpos4) * vboneWeights[i]) + blendVertex;
		vpos4 = blendVertex;
	};
	
	// Vertex position (projection and view spaces)
	gl_Position = mvp * vpos4;
	vec3 V;
	if ( lightingEnabled || fogEnabled ) V = vec3(modelView * vpos4);

	// Fragment color
	fcolor = baseColor * vcolor;

	// Fragment texture coords
	ftex = vtex;

	// Lighting
	combinedSpecular = vec3(0.0, 0.0, 0.0);
	if ( lightingEnabled ) {
		// Color that combines diffuse component of all lights
		vec4 combinedColor = vec4(ambient, 1.0);

		// Calculate vertex normal
		vec3 NV = normalize(V);

		// Calculate normal in viewer space
		vec3 N = normalize(vec3(normalMatrix * vec4(vnormal, 0.0)));

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
				combinedColor += NdotL * vec4(lightColor[i], 1.0) * att;

				// Specular
				if ( shininess > 0 && NdotL > 0.0 ) {
					vec3 H = normalize(L - NV);
					float NdotH = max(dot(N, H), 0.0);
					combinedSpecular += pow(NdotH, float(shininess)) * att;
				}
			}
		}

		fcolor *= combinedColor;
	}
	
	// Fog
	if ( fogEnabled ) fogFactor = clamp((fogDist[1] - abs(V.z)) / (fogDist[1] - fogDist[0]), 0.0, 1.0);
}