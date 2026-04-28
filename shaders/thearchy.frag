#pragma header

uniform float red;
uniform float green;
uniform float blue;
uniform float bloom;
uniform float blurWidth;
uniform float aberrationWidth;
uniform float hue;
uniform float grayscale;
uniform int samples;

vec3 rotateHue(vec3 rgb, float shift)
{
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(rgb.bg, K.wz), vec4(rgb.gb, K.xy), step(rgb.b, rgb.g));
    vec4 q = mix(vec4(p.xyw, rgb.r), vec4(rgb.r, p.yzx), step(p.x, rgb.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    vec3 hsv = vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    hsv.x = fract(hsv.x + shift);
    vec4 K2 = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p2 = abs(fract(hsv.xxx + K2.xyz) * 6.0 - K2.www);
    return hsv.z * mix(K2.xxx, clamp(p2 - K2.xxx, 0.0, 1.0), hsv.y);
}

void main()
{
    vec2 dir = openfl_TextureCoordv - 0.5;

    float precompute = blurWidth / float(samples - 1);

    vec2 chroma = normalize(dir + vec2(0.0001)) * aberrationWidth * length(dir) * 0.5;

    vec4 r, g, b;

    for (int i = 0; i < samples; i++)
    {
        float s = 1.0 + float(i) * precompute;

        r += texture2D(bitmap, (dir + chroma) * s + 0.5);
        g += texture2D(bitmap,  dir          * s + 0.5);
        b += texture2D(bitmap, (dir - chroma) * s + 0.5);
    }

    float inv = 1.0 / float(samples);
    vec4 color = vec4(r.r * inv * red, g.g * inv * green, b.b * inv * blue, g.a * inv) * bloom;

    color.rgb = rotateHue(color.rgb, hue);

    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));

    color.rgb = mix(color.rgb, vec3(luma), grayscale);

    gl_FragColor = color;
}