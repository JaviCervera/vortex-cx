#ifdef GL_ES
precision highp int;
precision mediump float;
#endif

uniform int baseTexMode;
uniform sampler2D baseTexSampler;
varying vec4 fcolor;
varying vec2 ftex;
varying vec3 combinedSpecular;

void main() {
	// Base color / lighting
	gl_FragColor = fcolor;

	// Base texture
	if ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, vec2(ftex.x, -ftex.y));

	// Reject fragment with low alpha
	if ( gl_FragColor.a <= 0.004 ) discard;

	// Add specular
	gl_FragColor += vec4(combinedSpecular, 0.0);
}