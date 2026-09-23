shader_type canvas_item;
render_mode unshaded, blend_add;
uniform float strength = 0.15;
uniform vec4 reflection_tint : source_color = vec4(0.86,0.90,1.0,1.0);
void fragment() {
 vec4 source = texture(TEXTURE, UV);
 // Only the artist's reflection marks contribute; no full-pane glow or blur.
 vec3 reflection = mix(source.rgb, vec3(1.0), 0.45) * mix(vec3(1.0),reflection_tint.rgb,0.22);
 COLOR = vec4(reflection, source.a * strength);
}
