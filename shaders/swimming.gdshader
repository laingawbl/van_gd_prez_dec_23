shader_type spatial;

uniform int stage = 0;

uniform float time_scale = 8.0;
uniform float side_to_side = 1.0;
uniform float pivot = 1.0;
uniform float wave = 1.0;
uniform float twist = 1.0;

uniform float mask_black = 0.0;
uniform float mask_white = 0.5;

varying float body;

void vertex() {
	float time = (TIME * (0.5 + INSTANCE_CUSTOM.y) * time_scale) + (6.28318 * INSTANCE_CUSTOM.x);
	
	if (stage == 6) {
		time *= 0.5;
		VERTEX.x += cos(time) * side_to_side * 0.8;
	}
	else {
		VERTEX.x += cos(time) * side_to_side;
	}
	
	if (stage > 0) {
		float pivot_angle = cos(time) * 0.1 * pivot;
		mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
		VERTEX.xz = rotation_matrix * VERTEX.xz;
	}
	
	body = (VERTEX.z + 1.0) / 2.0; //for a fish centered at (0, 0) with a length of 2
	
	if (stage > 1) {
		VERTEX.x += cos(time + body) * wave;
	}
	
	float twist_angle = cos(time + body) * 0.3 * twist;
	mat2 twist_matrix = mat2(vec2(cos(twist_angle), -sin(twist_angle)), vec2(sin(twist_angle), cos(twist_angle)));
	
	if (stage == 3 || stage == 4) {
		VERTEX.xy = twist_matrix * VERTEX.xy;
	} else if (stage == 5) {
		float mask = smoothstep(mask_black, mask_white, 1.0 - body);
		VERTEX.xy = mix(VERTEX.xy, twist_matrix * VERTEX.xy, mask);
	}
}

void fragment() {
	if (stage == 4 || stage == 5) {
		ALBEDO = vec3(smoothstep(mask_black, mask_white, 1.0 - body));
	}
	else {
		ALBEDO = vec3(0.0, UV);
	}
}
