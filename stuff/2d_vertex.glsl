#ifdef GL_ES
precision highp int;
precision mediump float;
#endif

uniform mat4 mvp;
attribute vec3 vpos;
attribute vec2 vtex;
varying vec2 ftex;

void main() {
	gl_Position = mvp * vec4(vpos, 1.0);
    ftex = vtex;
}