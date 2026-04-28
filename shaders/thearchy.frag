#pragma header

uniform float red;
uniform float green;
uniform float blue;
uniform float bloom;

uniform float blurWidth;

uniform int samples;

void main()
{
    vec2 uv = openfl_TextureCoordv;

    vec4 color = vec4(0.0);

    float blurStart = 1.0;
    float precompute = blurWidth * (1.0 / float(samples - 1));

    vec2 dir = uv - 0.5;

    for (int i = 0; i < samples; i++)
    {
        float scale = blurStart + float(i) * precompute;

        color += texture2D(bitmap, dir * scale + 0.5);
    }

    color /= float(samples);

    color.r *= red;
    color.g *= green;
    color.b *= blue;

    color.rgb *= bloom;

    gl_FragColor = color;
}