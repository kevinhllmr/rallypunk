shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 1.0) = 0.1; // Adjusted blur amount for subtle effect

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = texture(SCREEN_TEXTURE, uv);

    // Example: Assuming velocity is passed as a uniform from the game script
    vec2 velocity = vec2(0.0, 0.0); // Replace with actual velocity vector from the game
    float speed_threshold = 0.1; // Adjust based on your game's speed units
    float speed = length(velocity);

    // Determine if motion blur should be applied based on speed
    float blur_factor = smoothstep(0.0, 1.0, (speed - speed_threshold) / speed_threshold);

    // Directional motion blur effect (horizontal)
    vec2 blur_dir = velocity * 0.005; // Adjust scale factor as needed

    vec4 blur_color = vec4(0.0);
    float blur_steps = 10.0; // Number of blur steps, keep it low for subtlety

    // Accumulate samples along the blur direction
    for (float i = 1.0; i <= blur_steps; i++) {
        blur_color += texture(SCREEN_TEXTURE, uv + blur_dir * blur_amount * i);
    }
    blur_color /= (blur_steps + 1.0);

    // Blend the original color with the blurred color, based on blur_factor
    COLOR = mix(color, blur_color, blur_factor);
}
