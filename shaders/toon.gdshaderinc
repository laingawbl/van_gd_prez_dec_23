
group_uniforms toon.toon_diffuse;
uniform sampler2D toon_ramp: source_color;
uniform float toon_wrap : hint_range(-2.0f, 2.0f) = 0.0f;
uniform bool toon_use_attenuation;
uniform bool toon_clamp_diffuse;
group_uniforms;

group_uniforms toon.toon_specular;
uniform bool toon_use_specular;
uniform float toon_specular_strength : hint_range(0.0f, 1.0f) = 1.0f;
uniform float toon_specular_shine : hint_range(0.0f, 32.0f) = 16.0f;
uniform sampler2D toon_specular_map : source_color;
group_uniforms;

group_uniforms toon.toon_rim;
uniform bool toon_use_rim;
uniform float toon_rim_width : hint_range(0.0f, 1.0f) = 0.0f;
uniform vec4 toon_rim_color : source_color = vec4(1.0f);
group_uniforms;

float
split_specular(float specular) {
	return step(0.5f, specular);
}

void
ToonLight(
	in vec3 tp_normal,           in vec3 tp_view,
	in vec3 tp_light,            in vec3 tp_light_color,
	in vec3 tp_albedo,           in float atten,
	in vec2 uv,               inout vec3 diffuse_light,
	inout vec3 specular_light)
	{
	// Diffuse
	float A = toon_use_attenuation ? atten : 1.0f;
	float NdotL = dot(tp_normal, tp_light);
	float diffuse_strength = clamp(NdotL + (A - 1.0f) + toon_wrap, 0.005f, 0.995f);
	vec3 diffuse = tp_light_color / PI;
	
	diffuse *= texture(toon_ramp, vec2(diffuse_strength, 0.0f)).rgb;

	
	if (toon_clamp_diffuse) {
		diffuse_light = max(diffuse_light, diffuse);
	} else {
		diffuse_light += diffuse;
	}
	
	// Specular
	if (toon_use_specular) {
		vec3 H = normalize(tp_light + tp_view);
		float NdotH = dot(tp_normal, H);
		float specular_amount = max(pow(NdotH, toon_specular_shine*toon_specular_shine), 0.0f)
							    * texture(toon_specular_map, uv).r
								* A;
		specular_amount = split_specular(specular_amount);
		specular_light += toon_specular_strength * specular_amount * tp_light_color;
	}
	
	// Rim
	if (toon_use_rim) {
		float NdotV = dot(tp_normal, tp_view);
		float rim_light = smoothstep(.45, .55, pow(1.0 - NdotV, 1.0 / toon_rim_width));
		diffuse_light += rim_light * toon_rim_color.rgb * toon_rim_color.a * tp_light_color / PI;
	}
}