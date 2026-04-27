#pragma header

uniform float red;
uniform float blue;
uniform float green;

uniform float bloom;

void main()
{
    vec2 uv = openfl_TextureCoordv;
    
    vec4 color = texture2D(bitmap, uv);
    
    color.r *= red;
    color.g *= green;
    color.b *= blue;
    
    color.rgb *= bloom;
    
    gl_FragColor = color; 
}