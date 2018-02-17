

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float midi1; //R
uniform float midi2; //G
uniform float midi3; //B
uniform float midi4; // TIME
uniform float midi5;
uniform float midi6;
uniform float midi7;
uniform float midi8;
uniform float midi9;
uniform float midi10;
uniform float midi11;
uniform float midi12;
uniform float midi13;
uniform float midi14;
uniform float midi15;
uniform float midi16;
uniform float midi17;

//uniform float cant;

uniform float [10] puntosx;
uniform float [10] puntosy;
uniform float [4] puntosz;


#define PI 3.14159265359

float def(vec2 uv, float f);
void main() {
	
	vec2 uv = gl_FragCoord.xy/resolution;
	
	vec2 p = vec2(0.5)-uv;
	float a = atan(p.x,p.y);
	float rad = length(p);
   
    float maptime = time*midi9*10;

	float mpmidi6 = floor(midi6*10.);
	
	
	float e = def(uv,0);
	float e2 = abs(e);
	float e3 =  def(uv,PI);

	vec4 c1 = vec4(midi1,midi2,midi3,1.);
	vec4 c2 = 1.-c1;
	vec4 c3 = c1*0.5;
	
	
	vec4 col = vec4(e2)*c1+ vec4(e)*0.2-vec4(e3)*0.4;


		
	gl_FragColor = vec4(col);
	

}
float def(vec2 uv,float f){
		
		
		vec2 p = vec2(0.5)-uv;
		float a = atan(p.x,p.y);
		float rad = length(p);
		
		float maptime = time*midi4;
		float mpmidi6 = floor(midi6*10.);
		
		float cant = ceil(midi11);
		//cant = 1.;
		cant =4 ;
		float e =0.;
		for (int i=0; i<cant; i++){
			
			//vec2 pp = vec2(0.5,i/cant) - uv;
			vec2 pp = vec2(puntosx[i],1.-puntosy[i]) -uv;
			
			float aa = atan(pp.x,pp.y);
			float rr = length(pp);
			
			e+=sin(rr*PI*20*midi5+maptime+sin(aa*mpmidi6+maptime+sin(rr*PI*15)*midi8)*10*midi7+sin(rr*10*midi9)*20*midi10)*abs((puntosz[i])*2);
			
			e+=sin(rr*PI*10+sin(e)+time)*midi11;
			e+=sin(e*PI*1+time*9)*midi11;	
		}
		e/=4;
		
		float e2 =0.;
		for (int i=0; i<cant; i++){
			
			//vec2 pp = vec2(0.5,i/cant) - uv;
			
			//pp = vec2(mouse.x,1.-mouse.y)-uv;
			vec2 pp = vec2(1.-puntosx[i],puntosy[i]) -uv;
			
			float aa = atan(pp.x,pp.y);
			float rr = length(pp);

			
			
			float ax = abs(cos(aa))*0.0+0.5;
			ax = smoothstep(ax,ax+0.2,rr);
			e2+=sin(rr*PI*20*midi5+maptime+sin(ax*mpmidi6+maptime*midi8)*10*midi7+sin(rr*10*midi9)*20*midi10)*abs((puntosz[i])*2);
			e2+=sin(e*PI*1.1)*midi11;
		}
		e2*=midi12;
		
		
		//e+=e2;
		
		//e*=(1.-midi12);
		
		//e += abs(sin(e*PI*5-maptime*5))*midi11;

		return e;
}

