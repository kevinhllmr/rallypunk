shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = texture(SCREEN_TEXTURE, uv);
    
    // Generate grain effect using noise
    float grain = fract(sin(dot(uv * 100.0, vec2(12.9898, 78.233))) * 43758.5453);
    grain = grain * 0.05 - 0.025; // Scale down the grain effect for subtlety
    
    // Apply the grain effect to the color
    color.rgb += grain;

    COLOR = color;
}
