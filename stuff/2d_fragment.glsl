#ifdef GL_ES
precision highp int;
precision mediump float;
#endif

uniform int baseTexMode;
uniform sampler2D baseTexSampler;
uniform vec4 baseColor;
varying vec2 ftex;

void main() {
	// Base color
	gl_FragColor = baseColor;

	// Base texture
#ifdef UV_TOPLEFT
	if ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, vec2(ftex.x, ftex.y));
#else
	if ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, vec2(ftex.x, -ftex.y));
#endif
}