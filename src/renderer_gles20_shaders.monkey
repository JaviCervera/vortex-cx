Strict

Const STD_VERTEX_SHADER:String = "" +
"#ifdef GL_ES~n" +
"precision highp int;~n" +
"precision mediump float;~n" +
"#endif~n" +

"uniform mat4 mvp;~n" +
"uniform mat4 modelView;~n" +
"uniform mat4 normalMatrix;~n" +
"uniform mat4 invView;~n" +
"uniform int baseTexMode;~n" +
"uniform bool useNormalTex;~n" +
"uniform bool useReflectTex;~n" +
"uniform bool useRefractTex;~n" +
"uniform bool usePixelLighting;~n" +
"uniform bool lightingEnabled;~n" +
"uniform bool lightEnabled[MAX_LIGHTS];~n" +
"uniform vec4 lightPos[MAX_LIGHTS];~n" + 'In viewer space !!!
"uniform vec3 lightColor[MAX_LIGHTS];~n" +
"uniform float lightAttenuation[MAX_LIGHTS];~n" +
"uniform vec4 baseColor;~n" +
"uniform vec3 ambient;~n" +
"uniform int shininess;~n" +
"uniform float refractCoef;~n" +
"uniform bool fogEnabled;~n" +
"uniform vec2 fogDist;~n" +
"uniform bool skinned;~n" +
"uniform mat4 bones[MAX_BONES];~n" +
"attribute vec3 vpos;~n" +
"attribute vec3 vnormal;~n" +
"attribute vec3 vtangent;~n" +
"attribute vec4 vcolor;~n" +
"attribute vec2 vtex;~n" +
"attribute vec4 vboneIndices;~n" +
"attribute vec4 vboneWeights;~n" +
"varying vec3 fpos;~n" +
"varying vec3 fposNorm;~n" +
"varying vec3 fnormal;~n" +
"varying vec4 fcolor;~n" +
"varying vec2 ftex;~n" +
"varying vec3 fcombinedSpecular;~n" +
"varying float fogFactor;~n" +
"varying vec3 fcubeCoords;~n" +
"varying vec3 freflectCoords;~n" +
"varying vec3 frefractCoords;~n" +
"varying mat3 tbnMatrix;~n" +

"void CalcLighting(vec3 V, vec3 NV, vec3 N) {~n" +
'Color that combines diffuse component of all lights
"	vec3 combinedColor = ambient;~n" +

'Compute all lights
"	for ( int i = 0; i < MAX_LIGHTS; i++ ) {~n" +
"		if ( lightEnabled[i] ) {~n" +
"   		vec3 L = vec3(lightPos[i]);~n" +
"   		float att = 1.0;~n" +

			'Point light
"			if ( lightPos[i].w == 1.0 ) {~n" +
"				L -= V;~n" +
"				att = 1.0 / (1.0 + lightAttenuation[i]*length(L));~n" +
"			}~n" +

"			L = normalize(L);~n" +
"			float NdotL = max(dot(N, L), 0.0);~n" +

			'Diffuse
"			combinedColor += NdotL * lightColor[i] * att;~n" +

			'Specular
"			if ( shininess > 0 && NdotL > 0.0 ) {~n" +
"				vec3 H = normalize(L - NV);~n" +
"				float NdotH = max(dot(N, H), 0.0);~n" +
"				fcombinedSpecular += pow(NdotH, float(shininess)) * att;~n" +
"			}~n" +
"		}~n" +
"	}~n" +

"	fcolor *= vec4(clamp(combinedColor, 0.0, 1.0), 1.0);~n" +
"}~n" +

"void main() {~n" +
"	vec4 vpos4 = vec4(vpos, 1);~n" +

	'Skinning of vertex
"	if ( skinned ) {~n" +
"		mat4 boneTransform = mat4(1);~n" +
"		for ( int i = 0; i < 4; ++i ) {~n" +
"			int index = int(vboneIndices[i]);~n" +
"			if ( index > -1 ) boneTransform += bones[index] * vboneWeights[i];~n" +
"		}~n" +
"		vpos4 = boneTransform * vpos4;~n" +
"	};~n" +

	'Vertex position in projection space
"	gl_Position = mvp * vpos4;~n" +

	'Fragment color
"	fcolor = baseColor * vcolor;~n" +

	'Fragment texture coords
"	ftex = vtex;~n" +

	'Calculate vectors used in lighting and env mapping
"	vec3 V;~n" +
"	vec3 NV;~n" +
"	vec3 N;~n" +
"	if ( lightingEnabled || baseTexMode == 2 || useNormalTex || useReflectTex || useRefractTex || fogEnabled ) {~n" +
		'Calculate vertex in viewer space~n" +
" 		V = vec3(modelView * vpos4);~n" +

"		if ( lightingEnabled || baseTexMode == 2 || useNormalTex || useReflectTex || useRefractTex ) {~n" +
			'Calculate normalized vertex coordinates
"			NV = normalize(V);~n" +

			'Calculate normal in viewer space
"			N = normalize(vec3(normalMatrix * vec4(vnormal, 0.0)));~n" +
"		}~n" +
"	}~n" +

	'Lighting
"	if ( lightingEnabled ) {~n" +
"		if ( !usePixelLighting && !useNormalTex ) {~n" +
			'Color that combines specular component of all lights~n" +
"			fcombinedSpecular = vec3(0.0, 0.0, 0.0);~n" +

			'Calculate lighting
"			CalcLighting(V, NV, N);~n" +
"		} else {~n" +
"			fpos = V;~n" +
"			fposNorm = NV;~n" +
"			fnormal = N;~n" +
"		}~n" +
"	}~n" +

	'Fog
"	if ( fogEnabled ) fogFactor = clamp((fogDist[1] - abs(V.z)) / (fogDist[1] - fogDist[0]), 0.0, 1.0);~n" +

	'Cube mapping coordinates
"	if ( baseTexMode == 2 || useReflectTex || useRefractTex ) {~n" +
" 		if ( baseTexMode == 2 ) fcubeCoords = vec3(invView * vec4(V, 1));~n" +
"		if ( useReflectTex ) freflectCoords = normalize(vec3(invView * vec4(reflect(NV, N), 0)));~n" +
"		if ( useRefractTex ) frefractCoords = normalize(vec3(invView * vec4(refract(NV, N, refractCoef), 0)));~n" +
"	}~n" +

	'Calculate TBN matrix
"	if ( lightingEnabled && useNormalTex ) {~n" +
" 		vec3 eyeTangent = normalize(vec3(normalMatrix * vec4(vtangent, 0)));~n" +
"		vec3 eyeBitangent = cross(eyeTangent, N);~n" +
"		tbnMatrix = mat3(eyeTangent, eyeBitangent, N);~n" +
"	}~n" +
"}"

Const STD_FRAGMENT_SHADER:String = "" +
"#ifdef GL_ES~n" +
"precision highp int;~n" +
"precision mediump float;~n" +
"#endif~n" +

"uniform int baseTexMode;~n" +
"uniform bool useNormalTex;~n" +
"uniform bool useReflectTex;~n" +
"uniform bool useRefractTex;~n" +
"uniform sampler2D baseTexSampler;~n" +
"uniform samplerCube baseCubeSampler;~n" +
"uniform sampler2D normalTexSampler;~n" +
"uniform samplerCube reflectCubeSampler;~n" +
"uniform samplerCube refractCubeSampler;~n" +
"uniform bool usePixelLighting;~n" +
"uniform bool lightingEnabled;~n" +
"uniform bool lightEnabled[MAX_LIGHTS];~n" +
"uniform vec4 lightPos[MAX_LIGHTS];~n" +	'In viewer space !!!
"uniform vec3 lightColor[MAX_LIGHTS];~n" +
"uniform float lightAttenuation[MAX_LIGHTS];~n" +
"uniform vec3 ambient;~n" +
"uniform int shininess;~n" +
"uniform bool fogEnabled;~n" +
"uniform vec3 fogColor;~n" +
"varying vec3 fpos;~n" +
"varying vec3 fposNorm;~n" +
"varying vec3 fnormal;~n" +
"varying vec4 fcolor;~n" +
"varying vec2 ftex;~n" +
"varying vec3 fcombinedSpecular;~n" +
"varying float fogFactor;~n" +
"varying vec3 fcubeCoords;~n" +
"varying vec3 freflectCoords;~n" +
"varying vec3 frefractCoords;~n" +
"varying mat3 tbnMatrix;~n" +

"vec4 combinedColor;~n" +
"vec3 combinedSpecular = vec3(0, 0, 0);~n" +

"void CalcLighting(vec3 V, vec3 NV, vec3 N) {~n" +
	'Color that combines diffuse component of all lights
"	combinedColor = vec4(ambient, 1.0);~n" +

	'Get vertex normal or compute from normal map~n" +
"	vec3 normal = N;~n" +
"	if ( useNormalTex ) {~n" +
"		vec3 normalTexColor = vec3(texture2D(normalTexSampler, ftex));~n" +
"		normal = tbnMatrix * (normalTexColor*2.0 - 1.0);~n" +
"	}~n" +

	'Compute all lights
"	for ( int i = 0; i < MAX_LIGHTS; i++ ) {~n" +
"		if ( lightEnabled[i] ) {~n" +
"			vec3 L = vec3(lightPos[i]);~n" +
"			float att = 1.0;~n" +

			'Point light
"			if ( lightPos[i].w == 1.0 ) {~n" +
"				L -= V;~n" +
"				att = 1.0 / (1.0 + lightAttenuation[i]*length(L));~n" +
"			}~n" +

"			L = normalize(L);~n" +
"			float NdotL = max(dot(normal, L), 0.0);~n" +

			'Diffuse
"			combinedColor += NdotL * vec4(lightColor[i], 1.0) * att;~n" +

			'Specular
"			if ( shininess > 0 && NdotL > 0.0 ) {~n" +
"				vec3 H = normalize(L - NV);~n" +
"				float NdotH = max(dot(normal, H), 0.0);~n" +
"				combinedSpecular += pow(NdotH, float(shininess)) * att;~n" +
"			}~n" +
"		}~n" +
"	}~n" +

"	combinedColor = clamp(combinedColor, 0.0, 1.0);~n" +
"}~n" +

"void main() {~n" +
	'Lighting~n" +
"	if ( lightingEnabled && (usePixelLighting || useNormalTex) ) {~n" +
"		CalcLighting(fpos, fposNorm, fnormal);~n" +
"		combinedColor *= fcolor;~n" +
"	} else {~n" +
"		combinedColor = fcolor;~n" +
"	}~n" +

	'Base texture
"	if ( baseTexMode == 1 ) combinedColor *= texture2D(baseTexSampler, ftex);~n" +
"	else if ( baseTexMode == 2 ) combinedColor *= textureCube(baseCubeSampler, fcubeCoords);~n" +

	'Reject fragment with low alpha~n" +
"	if ( combinedColor.a <= 0.004 ) discard;~n" +

	'Reflection texture~n" +
"	if ( useReflectTex ) {~n" +
"		combinedColor *= textureCube(reflectCubeSampler, freflectCoords);~n" +
"	}~n" +

	'Refraction texture
"	if ( useRefractTex ) {~n" +
"		combinedColor *= textureCube(refractCubeSampler, frefractCoords);~n" +
"	}~n" +

	'Add specular
"	if ( lightingEnabled ) {~n" +
"		if ( usePixelLighting || useNormalTex ) combinedColor += vec4(combinedSpecular, 0.0);~n" +
"		else combinedColor += vec4(fcombinedSpecular, 0.0);~n" +
"		combinedColor = clamp(combinedColor, 0.0, 1.0);~n" +
"	}~n" +

	'Add fog
"	if ( fogEnabled ) combinedColor = vec4(mix(fogColor, vec3(combinedColor), fogFactor), combinedColor.a);~n" +

	'Set final color
"	gl_FragColor = combinedColor;~n" +
"}"

Const _2D_VERTEX_SHADER:String = "" +
"#ifdef GL_ES~n" +
"precision highp int;~n" +
"precision mediump float;~n" +
"#endif~n" +

"uniform mat4 mvp;~n" +
"attribute vec3 vpos;~n" +
"attribute vec2 vtex;~n" +
"varying vec2 ftex;~n" +

"void main() {~n" +
"	gl_Position = mvp * vec4(vpos, 1.0);~n" +
"	ftex = vtex;~n" +
"}"

Const _2D_FRAGMENT_SHADER:String = "" +
"#ifdef GL_ES~n" +
"precision highp int;~n" +
"precision mediump float;~n" +
"#endif~n" +

"uniform int baseTexMode;~n" +
"uniform sampler2D baseTexSampler;~n" +
"uniform vec4 baseColor;~n" +
"varying vec2 ftex;~n" +

"void main() {~n" +
	'Base color
"	gl_FragColor = baseColor;~n" +

	'Base texture
"	if ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, vec2(ftex.x, ftex.y));~n" +
"}"
