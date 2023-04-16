shader_type spatial;
render_mode cull_disabled;
render_mode unshaded;

uniform float width = .2;
uniform float height = .2;
uniform vec3 color = vec3(1., .0, .0);
uniform vec2 origin = vec2(.5, .5);

mat2 rotate(float angle) {
	float c = cos(angle);
	float s = sin(angle);
	return mat2(vec2(c, -s), vec2(s, c));
}

float rectangle(vec2 p) {
	float a = 1.;
	float w = step(origin.x - width / 2., p.x) - step(origin.x + width / 2., p.x);
	float h = step(origin.y - height / 2., p.y) - step(origin.y + height / 2., p.y);
	return w * h;
}

void fragment() {
	vec2 uv = UV;
	uv.y = 1. - uv.y;

	mat2 rotation_matrix = rotate(TIME);
	uv = rotation_matrix * uv;
	
//	uv.x += sin(TIME) * .5;
//	uv.y += cos(TIME) * .5;
	
	ALPHA = rectangle(uv);
	ALBEDO = clamp(color, .0, 1.);
}
