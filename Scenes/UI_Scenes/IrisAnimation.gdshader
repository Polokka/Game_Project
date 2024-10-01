shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 1.0;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
	vec2 uv = SCREEN_UV;
	float dist = distance(uv, center);

	if (dist > radius) {
		discard;
		}
	}