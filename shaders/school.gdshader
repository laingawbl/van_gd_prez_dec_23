shader_type spatial;

#include "toon.gdshaderinc"

uniform vec3 albedo : source_color;
uniform float time_scale = 1.0;
uniform float side_to_side = 1.0;
uniform float pivot = 1.0;
uniform float wave = 1.0;
uniform float twist = 1.0;

uniform float mask_black = 0.0;
uniform float mask_white = 0.5;

varying vec2 material_uv;

void vertex() {
	float time = (TIME * (0.5 + INSTANCE_CUSTOM.y) * time_scale) + (6.28318 * INSTANCE_CUSTOM.x);
	VERTEX.x += cos(time) * side_to_side;
	float pivot_angle = cos(time) * 0.1 * pivot;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	VERTEX.xz = rotation_matrix * VERTEX.xz;
	
	float body = (VERTEX.z + 1.0) / 2.0; //for a fish centered at (0, 0) with a length of 2
	VERTEX.x += cos(time + body) * wave;
	
	float twist_angle = cos(time + body) * 0.3 * twist;
	mat2 twist_matrix = mat2(vec2(cos(twist_angle), -sin(twist_angle)), vec2(sin(twist_angle), cos(twist_angle)));
	
	float mask = smoothstep(mask_black, mask_white, 1.0 - body);
	VERTEX.xy = mix(VERTEX.xy, twist_matrix * VERTEX.xy, mask);
}

void fragment() {
	ALBEDO = mix(albedo, COLOR.rgb, 0.15);
	material_uv = UV;
}

void light() {
	ToonLight(NORMAL, VIEW, LIGHT, LIGHT_COLOR, ALBEDO, ATTENUATION,
	material_uv, DIFFUSE_LIGHT, SPECULAR_LIGHT);
}