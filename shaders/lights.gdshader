shader_type spatial;

uniform int stage = 0;

uniform sampler2D img: filter_nearest;

void fragment() {
	ALBEDO = vec3(0.816, 0.773, 0.761);
	ROUGHNESS = 0.5;
	METALLIC = 0.0;
}

void light() {
	if (stage == 1) {
		DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	}
	else if (stage == 2) {
		DIFFUSE_LIGHT -= clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	}
	else if (stage == 3) {
		DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR;
	}
}
