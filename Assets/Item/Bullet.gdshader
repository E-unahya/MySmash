shader_type spatial;

render_mode unshaded;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	RIM = 0.1;
	ROUGHNESS = 0.01;
	METALLIC = 1.0;
	ALBEDO = vec3(0.5, 0.1, 0.3);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
