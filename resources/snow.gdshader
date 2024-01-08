shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
  vec3 wrld_vertex = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
  ALBEDO = vec3(0.8, 0.8, 1.0);
  ALPHA = clamp(wrld_vertex.y*0.03 - 1.0, 0.0, 1.0);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
