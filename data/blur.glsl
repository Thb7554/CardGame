#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

void main() {
  float intensity;
  vec4 color;

  float xF = gl_FragCoord.x/4;
  float yF = (gl_FragCoord.y-5*time)/4;

  float val = pNoise(vec2(xF,yF),25);

  float valF = gl_FragCoord.y/hei*3;



  float valG = val/2-valF-.6;

  
  gl_FragColor = vec4(valG+red*.6,valG+green*.6,valG+blue*.6,val/2+.5-valF/2+.1);
}