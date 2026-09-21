shader_type canvas_item;
render_mode unshaded;
uniform sampler2D illumination : filter_linear, repeat_disable;
uniform vec4 room_rect;
uniform vec4 ambient : source_color = vec4(1.0);
uniform float illumination_gain = 1.0;
uniform float highlight_limit = 1.25;
varying vec2 room_position;
void vertex() { room_position = VERTEX; }
void fragment() {
	vec2 uv = (room_position - room_rect.xy) / room_rect.zw;
	vec3 light = texture(illumination, uv).rgb * illumination_gain;
	vec3 multiplier = ambient.rgb + light;
	float peak = max(multiplier.r, max(multiplier.g, multiplier.b));
	if (peak > highlight_limit) { multiplier *= highlight_limit / peak; }
	COLOR.rgb *= multiplier;
}
