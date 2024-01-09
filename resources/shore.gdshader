shader_type spatial;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    ALBEDO = texture(SCREEN_TEXTURE, 1.0/SCREEN_UV).xyz; 
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
