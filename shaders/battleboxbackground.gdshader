shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float x = UV.x * TEXTURE_PIXEL_SIZE.y;
	float finalX = x;
	COLOR = vec4(finalX, finalX, finalX, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
