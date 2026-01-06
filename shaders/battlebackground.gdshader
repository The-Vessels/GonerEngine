shader_type canvas_item;

uniform sampler2D background_sprite;

const float bgspeed1 = -15.0;
const float bgspeed2 = 30.0;

void vertex() {
}

vec2 uv(vec2 uv0, vec2 offset, vec2 tsize) {
	vec2 uv_px = uv0 * vec2(640.0, 480.0) + offset;
	vec2 uv1 = fract(uv_px / tsize);
	return uv1;
}

void fragment() {
	vec2 tsize = vec2(textureSize(background_sprite, 0));

	vec2 offset1 = vec2(TIME * bgspeed1) + vec2(-200.0, -210.0);
	vec2 offset2 = vec2(TIME * bgspeed2) + vec2(-100.0, -100.0);

	vec4 tex1 = texture(background_sprite, uv(UV, offset1, tsize));
	vec4 tex2 = texture(background_sprite, uv(UV, offset2, tsize));
	float alpha = max(tex1.a, 0.5 * tex2.a);
	vec4 final_color = vec4(mix(tex2.rgb, tex1.rgb, tex1.a), alpha);
	COLOR = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
