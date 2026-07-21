shader_type canvas_item;

uniform vec4 normal_shadow_top_color : source_color;
uniform vec4 normal_shadow_bottom_color : source_color;
uniform float color_shadow_mix : hint_range(0.0, 1.0);
uniform float font_height;
uniform float line_height;
uniform vec2 shadow_offset;
uniform bool enable;

uniform sampler2D exclude_mask : filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

float incl(vec2 uv) {
	vec4 exclude_mask_color = texture(exclude_mask, uv);
	return step(exclude_mask_color.a, 0.1);
}

vec4 mytexture(sampler2D sampler, vec2 uv) {
	vec2 inside_vec = step(vec2(0.0, 0.0), uv) * step(uv, vec2(1.0, 1.0));
	float inside = inside_vec.x * inside_vec.y;
	return texture(sampler, uv) * inside;
}

vec4 gradient(vec4 topcolor, vec4 botcolor, vec2 coord) {
	float line_coord = mod(coord.y, line_height);
	return mix(topcolor, botcolor, line_coord / font_height);
}

float is_white(vec4 color) {
	return step(1.0, color.r * color.g * color.b * color.a);
}

void fragment() {
	if (enable) {
		vec2 uv_shadow = UV + TEXTURE_PIXEL_SIZE * -shadow_offset;
		vec4 text = mytexture(TEXTURE, UV);
		
		vec4 shadow = mytexture(TEXTURE, uv_shadow);
		float text_is_white = is_white(shadow);
		
		vec4 text_color = gradient(vec4(1.0, 1.0, 1.0, 1.0), text, UV / TEXTURE_PIXEL_SIZE);

		vec4 shadow_color_normal = gradient(
			normal_shadow_top_color, normal_shadow_bottom_color,
			uv_shadow / TEXTURE_PIXEL_SIZE
		);
		vec4 shadow_color_colored = shadow * vec4(vec3(color_shadow_mix), 1.0);
		vec4 shadow_color = mix(shadow_color_colored, shadow_color_normal, text_is_white);
		vec4 shadow_mask = mix(vec4(0.0), shadow_color, shadow.a) * incl(uv_shadow);
		vec4 processed_text = mix(shadow_mask, text_color, text.a);
		COLOR = mix(texture(exclude_mask, UV), processed_text, incl(UV));
		// COLOR = vec4(1.0, 0.0, 0.0, 1.0);
	}
}



//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
