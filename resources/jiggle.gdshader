shader_type spatial;

uniform float amp = 0.01;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
  VERTEX = vec3(VERTEX.x * (1.0+(sin(10.0*TIME) * amp)), VERTEX.y * (1.0 + (cos(10.0*TIME) * amp)), VERTEX.z * (1.0+(sin(10.0*TIME) * amp)));
}

void fragment() {
  ALBEDO = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
  
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
