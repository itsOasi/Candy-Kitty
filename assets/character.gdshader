shader_type spatial;

uniform sampler2D TEX: source_color;
uniform float flash_state:hint_range(0.0, 1.0) = 0;
uniform float stamina_state:hint_range(0.0, 1.0) = 1;
uniform vec4 flash_color : source_color;
uniform vec4 stamina_color : source_color;

void fragment() {
	// Place fragment code here.
	vec4 pixel = texture(TEX, UV);
	ALBEDO = mix(pixel.rgb, flash_color.rgb, flash_state);
	ALBEDO = mix(stamina_color.rgb, ALBEDO, stamina_state);
}
