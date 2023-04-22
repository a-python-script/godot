// Inspiration:
//https://www.shadertoy.com/view/csKSD3


// Rotation unterbinden, Sterne im Hintergrund und dann in ein "Tor" 
// packen + parallax

shader_type spatial;
render_mode cull_disabled;
render_mode shadows_disabled;
render_mode unshaded;

const float f[1] = float[1](1.);
//float it = .0;

mat2 rot(float a) {
    float s=sin(a);
	float c=cos(a);
    return mat2(vec2(c, s), vec2(-s, c));
}

float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float de(vec3 p) {
    //p.yz*=rot(-.5);
    //p.xz*=rot(iTime*.2);
    float d=100.;
    p*=.2;
    for (float i=0.; i<12.; i++) {
        p.xy=sin(p.xy*2.);
        p.xy*=rot(1.);
        p.xz*=rot(1.5);
        float l=length(p.xy)+.01;
        if (i>1.) d=min(d,l);
        //if (d==l) it=i;
    }
    return d*.3;
}

vec3 march(vec3 from, vec3 dir, vec2 coord) {
    float d, td=hash(coord+TIME)*.2;
    vec3 p, col=vec3(0.);
    for (int i=0; i<200; i++){
        p=from+dir*td;
        d=max(.005,abs(de(p)));
        td+=d;
        if (td>10.) break;
        vec3 c=vec3(1.,-.5,0.);
        c.rb*=rot(TIME*.1);
        c=normalize(1.+c);
        c*=exp(-.15*td);
        c*=exp(-.5*length(p));
        c/=1.+d*1500.;
        c*=.3+abs(pow(abs(fract(length(p)*.15-TIME*.2)-.5)*2.,30.))*4.;
        col+=c;
        col+=exp(-5.*length(p))*.15;
    }
    return col;
}


void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	uv -= .5;
	vec3 dir = normalize(vec3(uv, 1.2));
    vec3 col= march(vec3(.0, .0, -3.), dir, uv);
    ALBEDO = col;
	
//	ALBEDO = vec3(uv.y, .0, .0);
}
