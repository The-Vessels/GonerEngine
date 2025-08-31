shader_type canvas_item;

uniform float grid_spacing;
uniform float border_proportion;
uniform vec2 screen_resolution;
uniform vec4 grid_color_1 : source_color;
uniform vec4 grid_color_2 : source_color;
uniform float speed;

void vertex() {
}

bool in_grid(float time, vec2 uv, vec2 speed_factor, vec2 offset) {
	vec2 v1 = (uv * screen_resolution) + vec2(time * speed * speed_factor) + offset;
	vec2 v2 = mod(v1 / grid_spacing, 1.0);
	bool in_border = (v2.x <= border_proportion)
		|| (v2.y <= border_proportion);
	return in_border;
}

void fragment() {
	if (in_grid(TIME, UV, vec2(1.0, 1.0), vec2(0.0))) {
		COLOR = grid_color_1;
	} else if (in_grid(TIME, UV, vec2(1.0, -1.0), vec2(10.0))) {
		COLOR = grid_color_2;
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
