shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
  vec3 wrld_vertex = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
  vec3 brown = vec3(0.07, 0.06, 0.05);
  ALBEDO = brown;
  ALPHA = clamp(wrld_vertex.y/8.0 - 1.0, 0.0, 1.0);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
