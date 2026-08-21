shader_type canvas_item;

varying vec2 vpos;

void vertex() {
	// Called for every vertex the material is visible on.
	vpos = VERTEX;
}

vec4 add_to(vec4 col, sampler2D tex, vec2 uv, float opacity) {
	vec4 new_col = texture(tex, uv);
	vec3 rgb = col.rgb + new_col.rgb;
	return vec4(rgb, col.a + opacity * new_col.a);
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = texture(TEXTURE, UV);
	vec2 pixel = vec2(1.0) * TEXTURE_PIXEL_SIZE;
	float sine = sin(TIME * 30.0 / 14.0);
	float side_alpha = 0.3 + 0.1 * sine;
	float corner_alpha = 0.08 + 0.04 * sine;
	
	vec4 color = texture(TEXTURE, UV);
	color = add_to(color, TEXTURE, UV + pixel * vec2(1.0, 0.0),   side_alpha);
	color = add_to(color, TEXTURE, UV + pixel * vec2(0.0, 1.0),   side_alpha);
	color = add_to(color, TEXTURE, UV + pixel * vec2(-1.0, 0.0),  side_alpha);
	color = add_to(color, TEXTURE, UV + pixel * vec2(0.0, -1.0),  side_alpha);
	
	color = add_to(color, TEXTURE, UV + pixel * vec2(1.0, 1.0),   corner_alpha);
	color = add_to(color, TEXTURE, UV + pixel * vec2(1.0, -1.0),  corner_alpha);
	color = add_to(color, TEXTURE, UV + pixel * vec2(-1.0, 1.0),  corner_alpha);
	color = add_to(color, TEXTURE, UV + pixel * vec2(-1.0, -1.0), corner_alpha);
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
