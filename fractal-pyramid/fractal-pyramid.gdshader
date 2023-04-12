// Inspired by: https://www.shadertoy.com/view/tsXBzS
shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

#define T t()

uniform float timeScaleFactor = 1.;
uniform float scale = 1.;
uniform float edge0 = .0;
uniform float edge1 = 1.;
uniform vec3 color1 = vec3(.2, .7, .9);
uniform vec3 color2 = vec3(1., 0., 1.);

vec2 rotate(vec2 p, float a) {
	float c = cos(a);
	float s = sin(a);
	return  p * mat2(vec2(c, s), vec2(-s, c));	
}

float t() {
	return TIME * timeScaleFactor;
}

vec3 palette(float d) {
	return mix(color1, color2, d);
}

float map(vec3 p) {
	for(int i = 0; i < 8; ++i) {
        float t = T * 0.2;
        p.xz =rotate(p.xz, t);
        p.xy =rotate(p.xy, t * 1.89);
        p.xz = abs(p.xz);
        p.xz-=.5;
	}
	return dot(sign(p), p) / 5.;
}

vec4 rm (vec3 ro, vec3 rd) {
    float t = 0.;
    vec3 col = vec3(0.);
    float d;
    for(float i = 0.; i < 64.; i++){
		vec3 p = ro + rd * t;
        d = map(p) * .5;
        if(d < .02) {
            break;
        }
        if(d > 100.) {
        	break;
        }
        col+= palette(length(p) * .1) / (400. * d);
        t += d;
    }
    return vec4(col, 1. / (d * 100.));
}

void fragment() {
	vec2 uv = vec2(UV.x, 1. - UV.y);
	uv -= .5;
	uv /= scale;

	vec3 ro = vec3(.0, .0, -50.);
	ro.xz = rotate(ro.xz, T);
	vec3 cf = normalize(-ro);
	vec3 cs = normalize(cross(cf, vec3(0., 1., 0.)));
	vec3 cu = normalize(cross(cf, cs));
	vec3 uuv = ro + cf * 3. + uv.x * cs + uv.y * cu;
	
	vec3 rd = normalize(uuv - ro);
	vec4 col = rm(ro, rd);
	float y = .2126 * col.r + .7152 * col.g + .0722 * col.b;
	
	ALBEDO = col.rgb;
	ALPHA = smoothstep(edge0, edge1, y);
}
