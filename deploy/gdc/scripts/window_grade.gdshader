shader_type canvas_item;
render_mode unshaded;

uniform float ev = 0.0;
uniform float saturation = 1.0;
uniform float contrast = 1.0;
uniform vec4 upper : source_color = vec4(1.0);
uniform vec4 lower : source_color = vec4(1.0);
uniform float split = 0.0;
uniform float opacity = 1.0;
uniform float night = 0.0;
uniform bool procedural = false;
uniform int weather_kind = 0;
uniform vec2 pane_size = vec2(200.0, 160.0);
uniform vec4 uv_rect = vec4(0.0, 0.0, 1.0, 1.0);
uniform float seed = 0.0;

float hash21(vec2 p) {
 return fract(sin(dot(p, vec2(127.1, 311.7)) + seed * 0.17) * 43758.5453);
}
float noise2(vec2 p) {
 vec2 i = floor(p); vec2 f = fract(p); f = f*f*(3.0-2.0*f);
 return mix(mix(hash21(i), hash21(i+vec2(1,0)), f.x), mix(hash21(i+vec2(0,1)), hash21(i+vec2(1)), f.x), f.y);
}
// Two pixel rain depths; sparse near-glass trails drift much more slowly.
float rain(vec2 p, float t, float depth) {
 vec2 q = vec2(p.x + p.y * 0.13, p.y - t * (35.0 + depth * 29.0));
 vec2 cell = floor(q / vec2(19.0 + depth * 9.0, 37.0 + depth * 11.0));
 vec2 at = mod(q, vec2(19.0 + depth * 9.0, 37.0 + depth * 11.0));
 float rnd = hash21(cell + depth * 7.0);
 float x = 3.0 + rnd * (12.0 + depth * 5.0);
 float len = 5.0 + depth * 5.0;
 float y = 4.0 + hash21(cell + 31.0 + depth) * 20.0;
 return (1.0-step(0.7 + depth * 0.25, abs(at.x-x))) * (1.0-step(len, abs(at.y-y))) * step(0.38, rnd);
}
float snow(vec2 p, float t, float depth) {
 vec2 q = p - vec2(t*(2.0+depth*3.0), t*(5.0+depth*6.0));
 vec2 cell = floor(q / (29.0 + depth*14.0));
 vec2 at = mod(q, 29.0 + depth*14.0);
 float rnd = hash21(cell + depth*23.0);
 vec2 center = vec2(7.0 + rnd*15.0 + sin(t*0.7+rnd*10.0)*2.0, 5.0 + hash21(cell+4.0)*18.0);
 vec2 d = abs(at-center);
 return (1.0-step(1.0 + depth*0.7, d.x+d.y)) * step(0.24, rnd);
}
void fragment() {
 vec4 tex = texture(TEXTURE, UV);
 vec2 local = (UV - uv_rect.xy) / max(uv_rect.zw, vec2(0.0001));
 vec2 p = floor(local * max(pane_size, vec2(24.0)) / 1.4) * 1.4;
 float t = floor(TIME * 12.0) / 12.0;
 if (procedural) {
  float a = 0.0;
  vec3 colour = vec3(0.68,0.80,0.89);
  float cloud = noise2(vec2(p.x*0.014-t*0.025, p.y*0.033)) * 0.68 + noise2(vec2(p.x*0.035-t*0.016, p.y*0.056)) * 0.32;
  if (weather_kind == 0 || weather_kind == 1 || weather_kind == 5) {
   float threshold = weather_kind == 1 ? 0.48 : 0.69;
   a = smoothstep(threshold, threshold+0.16, cloud) * (weather_kind == 1 ? 0.28 : 0.085);
   colour = vec3(0.78,0.82,0.85);
   if(weather_kind == 0) {
    vec2 cell = floor(p/27.0); vec2 at = mod(p,27.0);
    float star = step(0.88,hash21(cell)) * (1.0-step(1.0,abs(at.x-7.0)+abs(at.y-11.0)));
    a += star * night * (0.26+0.10*sin(t*0.7+hash21(cell)*6.28));
   }
   if(weather_kind == 5) {
    // Soft, intermittent airborne motes; never thick cartoon speed lines.
    vec2 q = vec2(p.x-t*12.0,p.y+sin(t*0.5+p.x*0.015)*2.0);
    vec2 cell = floor(q/43.0); vec2 at = mod(q,43.0);
    a += step(0.82,hash21(cell)) * (1.0-step(3.0,abs(at.x-8.0))) * (1.0-step(0.8,abs(at.y-18.0))) * 0.24;
   }
  } else if (weather_kind == 2) {
   a = rain(p,t,0.0)*0.20 + rain(p+13.0,t,1.0)*0.33;
   vec2 q = p-vec2(0.0,t*1.3); vec2 cell = floor(q/55.0); vec2 at = mod(q,55.0);
   float rnd = hash21(cell+61.0); float dx = abs(at.x-(6.0+rnd*39.0));
   float bead = (1.0-step(1.1,dx))*(1.0-step(2.2,abs(at.y-20.0)));
   float trail = (1.0-step(0.65,dx))*(1.0-step(12.0,abs(at.y-13.0)));
   a += step(0.52,rnd)*(bead*0.28+trail*0.06);
  } else if (weather_kind == 3) {
   a = snow(p,t,0.0)*0.36 + snow(p+17.0,t,1.0)*0.72;
   colour = vec3(0.91,0.94,0.96);
  } else if (weather_kind == 4) {
   vec2 q = p-vec2(t*9.0,t*7.0); vec2 cell = floor(q/49.0); vec2 at = mod(q,49.0);
   float rnd = hash21(cell); float turn = t*1.4+rnd*6.28;
   vec2 d = at-vec2(8.0+rnd*26.0+sin(turn)*5.0,8.0+hash21(cell+9.0)*27.0);
   float leaf = (1.0-step(1.0,abs(d.x)/(1.0+abs(sin(turn))*2.4)+abs(d.y)/2.0));
   a = leaf * step(0.30,rnd) * 0.88;
   colour = mix(vec3(0.64,0.35,0.16),vec3(0.84,0.59,0.27),rnd);
  }
  // Night particles keep a restrained glint instead of illuminating the pane.
  vec3 weather_tint = mix(upper.rgb,lower.rgb,smoothstep(0.12,0.88,local.y));
  weather_tint /= max(max(weather_tint.r,weather_tint.g),max(weather_tint.b,0.05));
  colour *= mix(vec3(1.0),weather_tint,split*0.38) * mix(1.0,0.38,night);
  COLOR = vec4(colour, min(a,0.85)*tex.a);
 } else {
  vec3 c = tex.rgb;
  float luma = dot(c,vec3(0.2126,0.7152,0.0722));
  c = mix(vec3(luma),c,saturation);
  float horizon = smoothstep(0.12,0.88,local.y);
  vec3 tint = mix(upper.rgb,lower.rgb,horizon);
  // Preserve source luminance and silhouette while shifting its chroma.
  vec3 toned = tint * (luma / max(dot(tint,vec3(0.2126,0.7152,0.0722)),0.06));
  c = mix(c,toned,split);
  c = max(vec3(0.0),(c-0.18)*contrast+0.18);
  c = pow(max(c,vec3(0.0)),vec3(2.2)) * exp2(ev);
  c = pow(max(c,vec3(0.0)),vec3(1.0/2.2));
  COLOR = vec4(clamp(c,vec3(0.0),vec3(1.0)),tex.a*opacity);
 }
}
