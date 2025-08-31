shader_type canvas_item;
uniform float speed = 1.0;
uniform float mul = 1.0;
uniform vec3 color : source_color = vec3(1.0, 1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float time = TIME * speed;
	
	// left half = 0.0 to 1.0, right half = 1.0 to 0.0
	float x1 = -abs(2.0*UV.x - 1.0) + 1.0;
	float x2 = mod((x1-time) * 8.0, 1.0);
	float bars = step(x2, 0.2);
	float x3 = max(bars - mul*x1, 0.0);
	COLOR = vec4(color * x3, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
