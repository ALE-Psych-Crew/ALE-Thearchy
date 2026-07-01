#pragma header

uniform float red;
uniform float green;
uniform float blue;

uniform float bloom;

uniform float blurWidth;
uniform float aberrationWidth;

uniform float hue;
uniform float grayscale;

vec3 rotateHue(vec3 rgb, float shift)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);

    vec4 p = mix(
        vec4(rgb.bg, K.wz),
        vec4(rgb.gb, K.xy),
        step(rgb.b, rgb.g)
    );

    vec4 q = mix(
        vec4(p.xyw, rgb.r),
        vec4(rgb.r, p.yzx),
        step(p.x, rgb.r)
    );

    float d = q.x - min(q.w, q.y);
    float e = 1e-10;

    vec3 hsv = vec3(
        abs(q.z + (q.w - q.y) / (6.0 * d + e)),
        d / (q.x + e),
        q.x
    );

    hsv.x = fract(hsv.x + shift);

    vec4 K2 = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);

    vec3 p2 = abs(fract(hsv.xxx + K2.xyz) * 6.0 - K2.www);

    return hsv.z * mix(K2.xxx, clamp(p2 - K2.xxx, 0.0, 1.0), hsv.y);
}

void main()
{
    vec2 uv = openfl_TextureCoordv;

    vec2 dir = uv - 0.5;

    float len = max(length(dir), 0.0001);

    vec2 chroma = dir / len;
    chroma *= aberrationWidth * len * 0.5;

    vec4 color = vec4(0.0);

    color.r =
        texture2D(bitmap, uv + chroma - dir * blurWidth).r +
        texture2D(bitmap, uv + chroma - dir * blurWidth * 0.5).r +
        texture2D(bitmap, uv + chroma).r +
        texture2D(bitmap, uv + chroma + dir * blurWidth * 0.5).r +
        texture2D(bitmap, uv + chroma + dir * blurWidth).r;

    color.g =
        texture2D(bitmap, uv - dir * blurWidth).g +
        texture2D(bitmap, uv - dir * blurWidth * 0.5).g +
        texture2D(bitmap, uv).g +
        texture2D(bitmap, uv + dir * blurWidth * 0.5).g +
        texture2D(bitmap, uv + dir * blurWidth).g;

    color.b =
        texture2D(bitmap, uv - chroma - dir * blurWidth).b +
        texture2D(bitmap, uv - chroma - dir * blurWidth * 0.5).b +
        texture2D(bitmap, uv - chroma).b +
        texture2D(bitmap, uv - chroma + dir * blurWidth * 0.5).b +
        texture2D(bitmap, uv - chroma + dir * blurWidth).b;

    color.a = texture2D(bitmap, uv).a;

    color.rgb *= 0.2;

    color.r *= red;
    color.g *= green;
    color.b *= blue;

    color.rgb *= bloom;

    color.rgb = rotateHue(color.rgb, hue);

    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    color.rgb = mix(color.rgb, vec3(luma), grayscale);

    gl_FragColor = color;
}