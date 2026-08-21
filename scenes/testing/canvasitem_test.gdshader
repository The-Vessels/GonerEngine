shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	// VERTEX = VERTEX + vec2(0.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	// vec4 txt = texture(TEXTURE, UV);
	// COLOR = mix(txt, vec4(1.0, 0.0, 0.0, 1.0), 0.5);
	COLOR = vec4(VERTEX, 0.0, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
