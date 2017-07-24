Strict

Const SHADER_VAR_PRECISION:String = "" +
"#ifdef GL_ES~n" +
"precision highp int;~n" +
"precision mediump float;~n" +
"#endif~n"

Const STD_VARYING_VARS:String = "" +
"varying vec3 fpos;" +
"varying vec3 fposNorm;" +
"varying vec3 fnormal;" +
"varying vec4 fcolor;" +
"varying vec2 ftex;" +
"varying vec2 ftex2;" +
"varying vec3 fcombinedSpecular;" +
"varying float fogFactor;" +
"varying vec3 fcubeCoords;" +
"varying vec3 freflectCoords;" +
"varying vec3 frefractCoords;" +
"varying vec3 fdepthCoords;" +
"varying mat3 tbnMatrix;"

Const STD_VERTEX_VARS:String = "" +
"uniform mat4 mvp;" +
"uniform mat4 modelView;" +
"uniform mat4 normalMatrix;" +
"uniform mat4 invView;" +
"uniform mat4 depthBias;" +
"uniform int baseTexMode;" +
"uniform bool useNormalTex;" +
"uniform bool useReflectTex;" +
"uniform bool useRefractTex;" +
"uniform bool usePixelLighting;" +
"uniform bool lightingEnabled;" +
"uniform bool lightEnabled[MAX_LIGHTS];" +
"uniform vec4 lightPos[MAX_LIGHTS];" + 'In viewer space !!!
"uniform vec3 lightColor[MAX_LIGHTS];" +
"uniform float lightRadius[MAX_LIGHTS];" +
"uniform vec4 baseColor;" +
"uniform vec3 ambient;" +
"uniform int shininess;" +
"uniform float refractCoef;" +
"uniform bool fogEnabled;" +
"uniform vec2 fogDist;" +
"uniform bool skinned;" +
"uniform mat4 bones[MAX_BONES];" +
"attribute vec3 vpos;" +
"attribute vec3 vnormal;" +
"attribute vec3 vtangent;" +
"attribute vec4 vcolor;" +
"attribute vec2 vtex;" +
"attribute vec2 vtex2;" +
"attribute vec4 vboneIndices;" +
"attribute vec4 vboneWeights;" +
STD_VARYING_VARS

Const STD_FRAGMENT_VARS:String = "" +
"uniform int baseTexMode;" +
"uniform bool useNormalTex;" +
"uniform bool useLightmap;" +
"uniform bool useReflectTex;" +
"uniform bool useRefractTex;" +
"uniform sampler2D baseTexSampler;" +
"uniform samplerCube baseCubeSampler;" +
"uniform sampler2D normalTexSampler;" +
"uniform sampler2D lightmapSampler;" +
"uniform sampler2D depthSampler;" +
"uniform samplerCube reflectCubeSampler;" +
"uniform samplerCube refractCubeSampler;" +
"uniform bool usePixelLighting;" +
"uniform bool lightingEnabled;" +
"uniform bool lightEnabled[MAX_LIGHTS];" +
"uniform vec4 lightPos[MAX_LIGHTS];" +	'In viewer space !!!
"uniform vec3 lightColor[MAX_LIGHTS];" +
"uniform float lightRadius[MAX_LIGHTS];" +
"uniform vec3 ambient;" +
"uniform int shininess;" +
"uniform bool fogEnabled;" +
"uniform vec3 fogColor;" +
"uniform bool shadowsEnabled;" +
"uniform float depthEpsilon;" +
STD_VARYING_VARS

Const SHADER_CALC_LIGHTING:String = "" +
"struct LightingResult { vec3 combinedDiffuse; vec3 combinedSpecular; };" +
"LightingResult CalcLighting(vec3 V, vec3 NV, vec3 N) {" +
"	float normShininess = float(shininess) / 256.0;" +
"	LightingResult lighting;" +
"	lighting.combinedDiffuse = ambient;" +
"	lighting.combinedSpecular = vec3(0.0, 0.0, 0.0);" +

'Compute all lights
"	for ( int i = 0; i < MAX_LIGHTS; i++ ) {" +
"		if ( lightEnabled[i] ) {" +
"   		vec3 L = vec3(lightPos[i]);" +
"   		float att = 1.0;" +

			'Point light
"			if ( lightPos[i].w == 1.0 ) {" +
"				L -= V;" +
"				att = 1.0 - clamp(length(L) / lightRadius[i], 0.0, 1.0);" +
"			}" +

"			L = normalize(L);" +
"			float NdotL = max(dot(N, L), 0.0);" +

			'Diffuse
"			lighting.combinedDiffuse += NdotL * lightColor[i] * att;" +

			'Specular
"			if ( shininess > 0 && NdotL > 0.0 ) {" +
"				vec3 H = normalize(L - NV);" +
"				float NdotH = max(dot(N, H), 0.0);" +
"				lighting.combinedSpecular += pow(NdotH, float(shininess)) * normShininess * att;" +
"			}~n" +
"		}~n" +
"	}~n" +

"	lighting.combinedDiffuse = clamp(lighting.combinedDiffuse, 0.0, 1.0);" +
"	lighting.combinedSpecular = clamp(lighting.combinedSpecular, 0.0, 1.0);" +
"	return lighting;" +
"}"

Const STD_VERTEX_SHADER:String = SHADER_VAR_PRECISION + STD_VERTEX_VARS + SHADER_CALC_LIGHTING +
"void main() {" +
"	vec4 vpos4 = vec4(vpos, 1);" +

	'Vertex skinning
"	if ( skinned ) {" +
"		mat4 boneTransform = mat4(1);" +
"		for ( int i = 0; i < 4; ++i ) {" +
"			int index = int(vboneIndices[i]);" +
"			if ( index > -1 ) boneTransform += bones[index] * vboneWeights[i];" +
"		}" +
"		vpos4 = boneTransform * vpos4;" +
"	};" +

	'Vertex position in projection space
"	gl_Position = mvp * vpos4;" +

	'Vertex position in depth space
"	fdepthCoords = vec3(depthBias * vpos4);" +

	'Fragment color
"	fcolor = baseColor * vcolor;" +

	'Fragment texture coords
"	ftex = vtex;" +
"	ftex2 = vtex2;" +

	'Calculate vectors used in lighting and env mapping
"	vec3 V;" +
"	vec3 NV;" +
"	vec3 N;" +
"	if ( lightingEnabled || baseTexMode == 2 || useNormalTex || useReflectTex || useRefractTex || fogEnabled ) {" +
		'Calculate vertex in viewer space~n" +
" 		V = vec3(modelView * vpos4);" +

"		if ( lightingEnabled || baseTexMode == 2 || useNormalTex || useReflectTex || useRefractTex ) {" +
			'Calculate normalized vertex coordinates
"			NV = normalize(V);" +

			'Calculate normal in viewer space
"			N = normalize(vec3(normalMatrix * vec4(vnormal, 0.0)));" +
"		}~n" +
"	}~n" +

	'Lighting
"	if ( lightingEnabled ) {" +
"		if ( !usePixelLighting && !useNormalTex ) {" +
			'Calculate lighting
"			LightingResult lighting = CalcLighting(V, NV, N);" +
"			fcolor *= vec4(lighting.combinedDiffuse, 1.0);" +
"			fcombinedSpecular = lighting.combinedSpecular;" +
"		} else {" +
"			fpos = V;" +
"			fposNorm = NV;" +
"			fnormal = N;" +
"		}" +
"	}" +

	'Fog
"	if ( fogEnabled ) fogFactor = clamp((fogDist[1] - abs(V.z)) / (fogDist[1] - fogDist[0]), 0.0, 1.0);" +

	'Cube mapping coordinates
"	if ( baseTexMode == 2 || useReflectTex || useRefractTex ) {" +
" 		if ( baseTexMode == 2 ) fcubeCoords = vec3(invView * vec4(NV, 0));" +
"		if ( useReflectTex ) freflectCoords = normalize(vec3(invView * vec4(reflect(NV, N), 0)));" +
"		if ( useRefractTex ) frefractCoords = normalize(vec3(invView * vec4(refract(NV, N, refractCoef), 0)));" +
"	}" +

	'Calculate TBN matrix
"	if ( lightingEnabled && useNormalTex ) {" +
" 		vec3 eyeTangent = normalize(vec3(normalMatrix * vec4(vtangent, 0)));" +
"		vec3 eyeBitangent = cross(eyeTangent, N);" +
"		tbnMatrix = mat3(eyeTangent, eyeBitangent, N);" +
"	}" +
"}"

Const STD_FRAGMENT_SHADER:String = SHADER_VAR_PRECISION + STD_FRAGMENT_VARS + SHADER_CALC_LIGHTING +
"void main() {" +
	'Vars
"	vec4 combinedColor;" +
"	vec3 combinedSpecular = vec3(0, 0, 0);" +

	'Lighting
"	combinedColor = fcolor;" +
"	if ( lightingEnabled && (usePixelLighting || useNormalTex) ) {" +
		'Get fragment normal or compute from normal map
"		vec3 normal = fnormal;" +
"		if ( useNormalTex ) {" +
"			vec3 normalTexColor = vec3(texture2D(normalTexSampler, ftex));" +
"			normal = tbnMatrix * (normalTexColor*2.0 - 1.0);" +
"		}" +

		'Calc lighting
"		LightingResult lighting = CalcLighting(fpos, fposNorm, normal);" +
"		combinedColor *= vec4(lighting.combinedDiffuse, 1.0);" +
"		combinedSpecular = lighting.combinedSpecular;" +
"	}" +

	'Lightmap
"	if ( useLightmap ) {" +
"		if ( lightingEnabled ) combinedColor += vec4(vec3(texture2D(lightmapSampler, ftex2)), 0.0);" +
"		else combinedColor *= texture2D(lightmapSampler, ftex2);" +
"	}" +

	'Base texture
"	if ( baseTexMode == 1 ) combinedColor *= texture2D(baseTexSampler, ftex);" +
"	else if ( baseTexMode == 2 ) combinedColor *= textureCube(baseCubeSampler, fcubeCoords);" +

	'Reject fragment with low alpha
"	if ( combinedColor.a <= 0.004 ) discard;" +

	'Reflection texture
"	if ( useReflectTex ) {" +
"		combinedColor *= textureCube(reflectCubeSampler, freflectCoords);" +
"	}" +

	'Refraction texture
"	if ( useRefractTex ) {" +
"		combinedColor *= textureCube(refractCubeSampler, frefractCoords);" +
"	}" +

	'Add specular
"	if ( lightingEnabled ) {" +
"		if ( usePixelLighting || useNormalTex ) combinedColor += vec4(combinedSpecular, 0.0);" +
"		else combinedColor += vec4(fcombinedSpecular, 0.0);" +
"		combinedColor = clamp(combinedColor, 0.0, 1.0);" +
"	}" +

	'Shadows
"	if ( shadowsEnabled && texture2D(depthSampler, vec2(fdepthCoords)).z < fdepthCoords.z - depthEpsilon ) combinedColor *= vec4(ambient, 1);" +

	'Add fog
"	if ( fogEnabled ) combinedColor = vec4(mix(fogColor, vec3(combinedColor), fogFactor), combinedColor.a);" +

	'Set final color
"	gl_FragColor = combinedColor;" +
"}"

Const DEPTH_VERTEX_SHADER:String = SHADER_VAR_PRECISION +
"uniform mat4 mvp;" +
"attribute vec3 vpos;" +
'"varying float depth;" +
"void main() {" +
"	gl_Position = mvp * vec4(vpos, 1);" +
'"	depth = gl_Position.z / gl_Position.w;" +
"}"

Const DEPTH_FRAGMENT_SHADER:String = SHADER_VAR_PRECISION +
'"varying float depth;" +
"void main() {" +
"	float depth = gl_FragCoord.z / gl_FragCoord.w;" +
"	gl_FragColor = vec4(depth, depth, depth, 1);" +
"}"

Const _2D_VERTEX_SHADER:String = SHADER_VAR_PRECISION +
"uniform mat4 mvp;" +
"attribute vec3 vpos;" +
"attribute vec2 vtex;" +
"varying vec2 ftex;" +
"void main() {" +
"	gl_Position = mvp * vec4(vpos, 1.0);" +
"	ftex = vtex;" +
"}"

Const _2D_FRAGMENT_SHADER:String = SHADER_VAR_PRECISION +
"uniform int baseTexMode;" +
"uniform sampler2D baseTexSampler;" +
"uniform vec4 baseColor;" +
"varying vec2 ftex;" +
"void main() {" +
"	gl_FragColor = baseColor;" +
"	if ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, vec2(ftex.x, ftex.y));" +
"}"
