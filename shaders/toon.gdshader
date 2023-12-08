shader_type spatial;

#include "shaders/toon.gdshaderinc"

uniform vec3 albedo: source_color;

varying vec2 material_uv;

void fragment() {
	ALBEDO = albedo;
	material_uv = UV;
}

void light() {
	ToonLight(NORMAL, VIEW, LIGHT, LIGHT_COLOR, ALBEDO, ATTENUATION,
	material_uv, DIFFUSE_LIGHT, SPECULAR_LIGHT);
}