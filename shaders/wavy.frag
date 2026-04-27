#pragma header

uniform float time;
uniform float speed;
uniform float frequency;
uniform float amplitude;

void main()
{
    vec2 uv = fract(openfl_TextureCoordv);

    uv.x += sin(uv.y * frequency + time * speed) * amplitude;
    uv.y += cos(uv.y * frequency + time * speed) * amplitude;
	
    gl_FragColor = texture2D(bitmap, uv);
}