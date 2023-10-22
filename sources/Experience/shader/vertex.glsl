uniform float time;
uniform vec2 pixels;
uniform float uProgress;
uniform float uHeight;


varying vec2 vUv;
varying vec3 vPosition;

float PI = 3.141592653689793238;

const mat2 myt = mat2(.12121212, .13131313, -.13131313, .12121212);
const vec2 mys = vec2(1e4, 1e6);

vec2 rhash(vec2 uv) {
  uv *= myt;
  uv *= mys;
  return fract(fract(uv / mys) * uv);
}

vec3 hash(vec3 p) {
  return fract(sin(vec3(dot(p, vec3(1.0, 57.0, 113.0)),
                        dot(p, vec3(57.0, 113.0, 1.0)),
                        dot(p, vec3(113.0, 1.0, 57.0)))) *
               43758.5453);
}

float voronoi2d(const in vec2 point) {
  vec2 p = floor(point);
  vec2 f = fract(point);
  float res = 0.0;
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      vec2 b = vec2(i, j);
      vec2 r = vec2(b) - f + rhash(p + b);
      res += 1. / pow(dot(r, r), 8.);
    }
  }
  return pow(1. / res, 0.0625);
}


void main() {
  // Varyings
  vUv = uv;
  vPosition = position;

 
  // on récupère la valeur du voronoi en fonction de la position du vertice
  float voronoi = voronoi2d(vUv * 5.0);
  // height correspond à la hauteur du vertice en fonction de la valeur du voronoi
  float height = voronoi * uHeight;
  // on crée une nouvelle position en fonction de la hauteur et on change l'axe z de la position
  vec3 newPosition = position + vec3(0.0, 0.0, height);
  gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);

  // gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

}
